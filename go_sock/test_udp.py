#!/bin/python
import os
import time

os.system("go build UDPClient.go")
os.system("go build UDPServer.go")

for i in [6,7,8,9]:
    print("\nTest for " + str(2**i) +" concurrent connections")
    os.system("./UDPClient -a=10.0.0.26 -l=1000 -s=10000 -rl=5000 -n="+str(2**i)+ \
        " -of=udp_oneway_"+str(2**i) + " -rf=udp_roundtrip_" + str(2**i)+" &")
    time.sleep(1)
    os.system("python measure.py -n UDPClient -t 0")
    time.sleep(5)
