/*
 * tcpclient.c - A simple TCP client
 * usage: tcpclient <host> <port>
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <linux/types.h>
//#include <linux/spinlock.h>
#include <time.h>
#include <pthread.h>
#include <stdbool.h>

#define BUFSIZE 2048
#define MILLION 1000000L
#define THOUSAND 1000
/*
 * error - wrapper for perror
 */
void error(char *msg) {
    perror(msg);
    exit(0);
}


int sockfd;

int stopCount = 10000;
int pktLen = 1500;
int sendInterval =  100;  // in us

char sendbuf[BUFSIZE];
char recvbuf[BUFSIZE];


#define RINGBUFADD(index) index = index+1>=BUFSIZE?index+1-BUFSIZE:index+1
#define HEADMEETTAIL() head+1-(head+1>=BUFSIZE)*BUFSIZE ==tail

void *measureReport()
{
  printf("Packet Num\tThroughput (Mb/s)\tAverage Delay\n");
  while(!exitFlag){
    sleep(1);

    pthread_mutex_lock(&lock_x);
    int counter = pktCounter -lastPktCount;
    double throughput = 8.0*(byteCounter - lastByteCount)/1024/1024;
    double aveDelay = delayCount ? 1.0*(delays)/(delayCount)/2 : 0.0;
    delays = 0;
    delayCount = 0;
    lastPktCount = pktCounter;
    lastByteCount = byteCounter;
    pthread_mutex_unlock(&lock_x);

    printf("%d\t\t\t%.2f\t\t\t%.2f\n", counter, throughput, aveDelay);
  }
  pthread_exit(NULL);
  return NULL;
}


void *measureDelay(void*argv)
{
  char * buf = (char *) recvbuf;
  int counter = 0;
  struct timespec sendTime, recvTime;
  struct sockaddr_in serveraddr;
  socklen_t addrlen = sizeof(serveraddr);
  int n;
  /* print the server's reply */
  bzero(buf, BUFSIZE);
  while (counter < stopCount){
    n = recvfrom(sockfd, buf, BUFSIZE, 0, (struct sockaddr *)&serveraddr, &addrlen);
    if (n < 0)
      error("ERROR reading from socket");

    if (n != pktLen){
      printf("%d\t", n);
      //erro("ERROR received less pkt");
    }

    //printf("Received packet with length %d, head is %d, tail is %d\n", n, head, tail);

    clock_gettime(CLOCK_MONOTONIC, &recvTime);
    memcpy((void*)&sendTime, buf, sizeof(struct timespec));
    pthread_mutex_lock(&lock_x);
    pktCounter += 1;
    byteCounter += n;
    delays += MILLION * (recvTime.tv_sec - sendTime.tv_sec) + 1.0*(recvTime.tv_nsec - sendTime.tv_nsec)/THOUSAND;
    delayCount += 1;
    pthread_mutex_unlock(&lock_x);
    counter += 1;
  }
  exitFlag = true;
  pthread_exit(NULL);
  return NULL;
}


int main(int argc, char **argv) {
    int portno, n;
    struct sockaddr_in serveraddr, clientaddr;
    struct hostent *server;
    char *hostname;

    struct thread_info receiving_thread;
    struct thread_info report_thread;

    /* check command line arguments */
    if (argc < 3) {
       fprintf(stderr,"usage: %s <hostname> <port>\n", argv[0]);
       exit(0);
    }
    hostname = argv[1];
    portno = atoi(argv[2]);

    // stop after sending and receiving stopCount packets


    if (argc > 3) {
      stopCount = atoi(argv[3]);
    }

    if (argc >4){
      pktLen = atoi(argv[4]);
    }

    if (argc > 5){
      sendInterval = atoi(argv[5]);
    }

    double sendSpeed = 1.0*MILLION/sendInterval * pktLen * 8/1024/1024;

    printf("Hostname: %s\t port number: %d\n", hostname, portno);
    printf("Stop Count: %d\t packet length: %d\n", stopCount, pktLen);
    printf("Sending Interval is %d us\n", sendInterval);
    printf("Sending Speed set to %.2f Mb/s\n\n", sendSpeed);

    pthread_mutex_init(&lock_x, NULL);

    /* socket: create the socket */
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
        error("ERROR opening socket");

    int optval = 1;
    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR,
         (const void *)&optval , sizeof(int));

    /*
     * build the server's Internet address
     */
    bzero((char *) &clientaddr, sizeof(clientaddr));

    /* this is an Internet address */
    clientaddr.sin_family = AF_INET;

    /* let the system figure out our IP address */
    clientaddr.sin_addr.s_addr = htonl(INADDR_ANY);

    /* this is the port we will listen on */
    clientaddr.sin_port = htons((unsigned short)portno);

    /*
     * bind: associate the parent socket with a port
     */
    if (bind(sockfd, (struct sockaddr *) &clientaddr,
       sizeof(clientaddr)) < 0)
      error("ERROR on binding");

    /* gethostbyname: get the server's DNS entry */
    server = gethostbyname(hostname);
    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host as %s\n", hostname);
        exit(0);
    }


    /* build the server's Internet address */
    bzero((char *) &serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    bcopy((char *)server->h_addr,
    (char *)&serveraddr.sin_addr.s_addr, server->h_length);
    serveraddr.sin_port = htons(portno);

    /* connect: create a connection with the server */
    if (connect(sockfd, &serveraddr, sizeof(serveraddr)) < 0)
      error("ERROR connecting");

    /* create thread for print out the measure information for each second */
    pthread_create(&report_thread.thread_id, NULL, measureReport, NULL);
    pthread_create(&receiving_thread.thread_id, NULL, measureDelay, NULL);

    /* get message line from the user */
    bzero(sendbuf, BUFSIZE);
    //fgets(buf, BUFSIZE, stdin);

    /* send the message line to the server */
    struct timespec sendTime;
    int k;
    for (k=1; k <= stopCount; k++){
      clock_gettime(CLOCK_MONOTONIC, &sendTime);
      memcpy(sendbuf, (const void*)&sendTime, sizeof(struct timespec));
      //printf("Send packet with length %d\n", n);
      n = sendto(sockfd, sendbuf, pktLen, 0, (struct sockaddr *)&serveraddr, sizeof(serveraddr));
      if (n < 0)
        error("ERROR writing to socket");
      if (sendInterval != 0)
        usleep(sendInterval);
    }

    //printf("Echo from server: %s", buf);
    pthread_join(report_thread.thread_id, NULL);
    pthread_join(receiving_thread.thread_id, NULL);

    close(sockfd);
    return 0;
}
