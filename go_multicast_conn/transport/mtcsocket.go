package transport

import (
	"net"
	"strconv"
	"syscall"
	"time"

	"golang.org/x/net/ipv4"
)

type MTCConn struct {
	// ListenPacket and PacketConn for multicast
	conn  net.PacketConn
	pconn *ipv4.PacketConn

	intf  *net.Interface
	dst   *net.UDPAddr
	maddr net.IP
	laddr net.IP
	port  int
}

func NewMTCConn(intf string, maddr string, port string) (conn *MTCConn, err error) {

	// get interface
	en0, err := net.InterfaceByName(intf)
	if err != nil {
		return nil, err
	}

	group := net.ParseIP(maddr)
	//an application listens to an appropriate address with an appropriate service port.
	c, err := net.ListenPacket("udp4", ":"+port)
	if err != nil {
		return nil, err
	}
	// join group
	p := ipv4.NewPacketConn(c)
	err = p.JoinGroup(en0, &net.UDPAddr{IP: group})
	if err != nil {
		return nil, err
	}

	// if the application need a dest address in the packet
	err = p.SetControlMessage(ipv4.FlagDst, true)
	if err != nil {
		return nil, err
	}

	intPort, err := strconv.Atoi(port)
	dst := &net.UDPAddr{IP: group, Port: intPort}

	p.SetTOS(0x0)
	p.SetTTL(2)
	err = p.SetMulticastInterface(en0)
	if err != nil {
		return nil, err
	}

	conn = &MTCConn{
		conn:  c,
		pconn: p,
		intf:  en0,
		dst:   dst,
		maddr: group,
		port:  intPort,
	}

	return conn, err
}

// the implementation of Conn interface

func (c *MTCConn) ok() bool { return c != nil && c.pconn != nil && c.conn != nil }

func (c *MTCConn) Read(b []byte) (n int, err error) {
	if !c.ok() {
		return 0, syscall.EINVAL
	}
	// Read to MTCConn readBuffer
	n, _, _, err = c.pconn.ReadFrom(b)
	return n, err
}

func (c *MTCConn) Write(b []byte) (n int, err error) {
	if !c.ok() {
		return 0, syscall.EINVAL
	}
	return c.pconn.WriteTo(b, nil, c.dst)
}

func (c *MTCConn) Close() error {
	if !c.ok() {
		return syscall.EINVAL
	}
	err := c.conn.Close()
	return err
}

func (c *MTCConn) SetDeadline(t time.Time) error {
	if !c.ok() {
		return syscall.EINVAL
	}
	return c.conn.SetDeadline(t)
}

func (c *MTCConn) SetReadDeadline(t time.Time) error {
	if !c.ok() {
		return syscall.EINVAL
	}
	return c.conn.SetReadDeadline(t)
}

func (c *MTCConn) SetWriteDeadline(t time.Time) error {
	if !c.ok() {
		return syscall.EINVAL
	}
	return c.conn.SetWriteDeadline(t)
}
