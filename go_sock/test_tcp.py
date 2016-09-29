#!/bin/python
import os
import time

os.system("go build TCPClient.go")
os.system("go build TCPServer.go")

for i in [6,7,8,9]:
    print("\nTest for " + str(2**i) +" concurrent connections")
    os.system("./TCPClient -a=10.0.0.26 -l=1000 -s=10000 -rl=5000 -n="+str(2**i)+ \
        " -of=tcp_oneway_"+str(2**i) + " -rf=tcp_roundtrip_" + str(2**i)+" &")
    time.sleep(1)
    os.system("python measure.py -n TCPClient -t 0")
    time.sleep(5)
