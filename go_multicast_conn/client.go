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

const (
	INTERVAL_SIZE = 1000
)

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
var maddr string
var intf string // name of interface

const defaultBufferSize = 1024

func CheckError(errString string, err error) {
	if err != nil {
		fmt.Println(errString+": ", err)
	}
}

/* A Simple function to verify error */
func CheckErrorExit(errString string, err error) {
	if err != nil {
		fmt.Println(errString+": ", err)
		os.Exit(1)
	}
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
	flag.IntVar(&stopNum, "s", 5000000, "Number of message to send before stop")
	flag.IntVar(&recordlen, "rl", 10000, "The number of latency to record")
	flag.StringVar(&oneFile, "of", "udp_oneway", "The file name for one way latency")
	flag.StringVar(&roundFile, "rf", "udp_roundtrip", "The file name for round trip latancy")
	flag.StringVar(&maddr, "m", "224.0.0.1", "Multicast Address")
	flag.StringVar(&intf, "I", "em1", "Name of the interface for multicast")
	flag.Parse()

	startTime := time.Now().UnixNano()
	//lostPkt := 0
	rcvPkt := 0

	//c.SetReadBuffer(4 * 1024 * 1024) // setup the read buffer as 10MB.
	//c.SetWriteBuffer(4 * 1024 * 1024)
	latencygap := stopNum / recordlen / 2
	//intervalgap := stopNum / INTERVAL_SIZE / 2
	oneWayLatencies := make([]int64, recordlen)

	latencyNum := 0
	currentTime := time.Now().UnixNano()

	conn, err := transport.NewMTCConn(intf, maddr, port)
	CheckErrorExit("New MTCConn Fail", err)
	r := bufio.NewReaderSize(conn, defaultBufferSize)
	//w := bufio.NewWriterSize(conn, defaultBufferSize)
	b := make([]byte, 1000)
	for i := 1; i <= stopNum; i++ {
		_, err := r.Read(b)
		//if n != 1000
		CheckError("Read Bufio", err)
		sentNum, _ := binary.Varint(b)
		serverSentTime, _ := binary.Varint(b[8:])

		if sentNum == int64(-1) {
			break
		}
		if rcvPkt >= stopNum/4 && rcvPkt%latencygap == 0 && latencyNum < recordlen {
			oneWayLatencies[latencyNum] = currentTime - serverSentTime
			latencyNum++
		}
		rcvPkt++

		//The application can also send both unicast and multicast packets.
		//_, err = p.WriteTo(b, nil, src)
		//CheckErrorExit("Write to socket Error", err)
		// dst := &net.UDPAddr{IP: group, Port: 1024}
		// for _, ifi := range []*net.Interface{en0} {
		// 	if err := p.SetMulticastInterface(ifi); err != nil {
		// 		// error handling
		// 	}
		// 	p.SetMulticastTTL(2)
		// 	if _, err := p.WriteTo(b, nil, dst); err != nil {
		// 		// error handling
		// 	}
		// }
	}
	//wg.Wait()
	conn.Close()
	endTime := time.Now().UnixNano()
	fmt.Println("END Client Program, ", stopNum-rcvPkt, " packets lost")
	fmt.Println((endTime-startTime)/1000/1000, "ms passed")
	fmt.Println(rcvPkt, "packets received")
	//writeLines(lostPacket, "lostpkt.log")
	writeLines(oneWayLatencies, "latency.log")
}
