package main

import (
	"bufio"
	"encoding/binary"
	"flag"
	"fmt"
	"math/rand"
	"net"
	"os"
	"sync"
	"time"
)

const (
	BUFSIZE = 2048
)

//import "strconv"
//import "io/ioutil"

var recordlen int
var ctype string
var ip string
var port string
var stopNum int
var msglen int
var interval int
var cnum int
var oneFile string
var roundFile string
var pktLost int

/* A Simple function to verify error */
func CheckErrorExit(errString string, err error) {
	if err != nil {
		fmt.Println(errString+": ", err)
		os.Exit(1)
	}
}

func handleUDP(wg *sync.WaitGroup, id int, recordOrNot bool) {
	//time.Sleep(time.Microsecond * time.Duration(interval*rand.Intn(1000)))
	var err error
	/* Lets prepare a address at any address at port 10001*/
	localAddr, err := net.ResolveUDPAddr("udp", ":0")
	CheckErrorExit("Resolve UDP ERROR", err)

	serverAddr, err := net.ResolveUDPAddr("udp", ip+":"+port)
	CheckErrorExit("Resolve UDP ERROR", err)

	conn, err := net.DialUDP("udp", localAddr, serverAddr)
	CheckErrorExit("UDP Dial Error", err)

	//buffer := make([]byte, msglen)
	bufferRcv := make([]byte, msglen)
	buff := make([]byte, msglen)
	binary.PutVarint(buff, 0)
	//binary.PutVarint(buff[8:], )
	conn.Write(buff)
	//lostPacket := make([]int64, 20000)
	startTime := time.Now().UnixNano()
	//lostPkt := 0
	rcvPkt := 0
	i := 0

	conn.SetReadBuffer(4 * 1024 * 1024) // setup the read buffer as 10MB.
	conn.SetWriteBuffer(4 * 1024 * 1024)
	gap := stopNum / 10000
	oneWayLatencies := make([]int64, 10000)

	recNum := 0
	for i = 0; i < stopNum; i++ {
		//conn.SetReadDeadline(time.Now().Add(time.Second*1))
		n, err := conn.Read(bufferRcv)
		currentTime := time.Now().UnixNano()
		if n != msglen {
			fmt.Println("expecting ", msglen, " Bytes and recieved ", n, " Bytes")
		}
		if err != nil {
			fmt.Println("Read Error:", err)
			conn.Close()
			break
		}
		//sentNum, _ := binary.Varint(bufferRcv)
		serverSentTime, _ := binary.Varint(bufferRcv[8:])
		if rcvPkt%gap == 0 && recNum < 10000 {
			oneWayLatencies[recNum] = currentTime - serverSentTime
			recNum++
		}
		// if int(sentNum) > i && lostPkt+2 < 20000{
		//   lostPacket[lostPkt] = i
		//   lostPacket[lostPkt+1] = int(sentNum)-1
		//   lostPkt += 2
		//   i = int(sentNum)
		// }
		rcvPkt++
	}
	// if lostPkt+1 < 20000 {
	// 	lostPacket[lostPkt] = i
	// 	lostPkt++
	// }
	endTime := time.Now().UnixNano()
	fmt.Println(endTime-startTime, " ns passed")
	fmt.Println(rcvPkt, "packets received")
	//writeLines(lostPacket, "lostpkt.log")
	writeLines(oneWayLatencies, "latency.log")
	wg.Done()
}

func writeLines(lines []int64, path string) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	w := bufio.NewWriter(file)
	for _, line := range lines {
		fmt.Fprintln(w, line)
	}
	return w.Flush()
}

func main() {

	flag.IntVar(&interval, "i", 5, "The interval of sending message in ms")
	flag.IntVar(&msglen, "l", 1000, "The message length")
	flag.IntVar(&cnum, "n", 1, "Number of concurrent client connections")
	flag.StringVar(&ip, "a", "127.0.0.1", "The IP address of remote server")
	flag.StringVar(&port, "p", "8080", "The port number of remote server")
	flag.StringVar(&ctype, "t", "udp", "The connection type, TCP or UDP or UDT")
	flag.IntVar(&stopNum, "s", 400, "Number of message to send before stop")
	flag.IntVar(&recordlen, "rl", 200, "The number of latency to record")
	flag.StringVar(&oneFile, "of", "udp_oneway", "The file name for one way latency")
	flag.StringVar(&roundFile, "rf", "udp_roundtrip", "The file name for round trip latancy")
	flag.Parse()

	var wg sync.WaitGroup
	var recordOrNot bool
	recordNum := rand.Intn(cnum)
	for i := 1; i <= cnum; i++ {
		recordOrNot = false
		if i-1 == recordNum {
			recordOrNot = true
		}
		wg.Add(1)
		go handleUDP(&wg, i, recordOrNot)
	}
	wg.Wait()
	fmt.Println("END Client Program, ", pktLost, " packets lost")
}
