package main

import (
	"bufio"
	"encoding/binary"
	"flag"
	"fmt"
	"os"
	"time"

	"./transport"
)

//import "strconv"

const (
	BUFSIZE       = 10000
	INTERVAL_SIZE = 10000
)

var recordlen int
var ctype string
var ip string
var port string
var stopNum int
var msglen int
var interval int
var cnum int
var sfile string
var maddr string
var intf string

const defaultBufferSize = 1024

/* A Simple function to verify error */
func CheckErrorExit(errStr string, err error) {
	if err != nil {
		fmt.Println(errStr+": ", err)
		os.Exit(1)
	}
}

/* A Simple function to verify error */
func CheckError(errStr string, err error) {
	if err != nil {
		fmt.Println(errStr+": ", err)
	}
}

func main() {

	flag.IntVar(&interval, "i", 0, "The interval of sending message in us")
	flag.IntVar(&msglen, "l", 1000, "The message length")
	flag.IntVar(&cnum, "n", 1, "Number of concurrent client connections")
	//flag.StringVar(&ip, "a", "127.0.0.1", "The IP address of remote server")
	flag.StringVar(&port, "p", "8080", "The port number of remote server")
	flag.StringVar(&ctype, "t", "udp", "The connection type, TCP or UDP or UDT")
	flag.IntVar(&stopNum, "s", 5000000, "Number of message to send before stop")
	flag.IntVar(&recordlen, "rl", 10000, "The number of latency to record")
	//recordOrNot := flag.Bool("record", false, "Indicate whether to record the latency or not")
	flag.StringVar(&sfile, "f", "tcp_server", "The file name for recording the latency")
	flag.StringVar(&maddr, "m", "224.0.0.1", "Multicast Address")
	flag.StringVar(&intf, "I", "em1", "Name of the interface for multicast")
	flag.Parse()

	conn, err := transport.NewMTCConn(intf, maddr, port)
	CheckError("New MTC Coon fail", err)
	w := bufio.NewWriterSize(conn, defaultBufferSize)
	b := make([]byte, 1000)

	currentTime := time.Now().UnixNano()
	startTime := time.Now().UnixNano()
	for i := 1; i <= stopNum; i++ {
		binary.PutVarint(b, int64(i))
		currentTime = time.Now().UnixNano()
		binary.PutVarint(b[8:], currentTime)
		//The application can also send both unicast and multicast packets.
		w.Write(b)
		w.Flush()
	}
	endTime := time.Now().UnixNano()
	time.Sleep(time.Microsecond * 100)
	binary.PutVarint(b, int64(-1))
	//currentTime = time.Now().UnixNano()
	//binary.PutVarint(sendBuf[8:], currentTime)
	//c.WriteToUDP(sendBuf, addr)
	//The application can also send both unicast and multicast packets.
	_, err = w.Write(b)
	CheckError("Write To multicast Error", err)
	w.Flush()

	fmt.Println((endTime-startTime)/1000/1000, "ms passed")
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
