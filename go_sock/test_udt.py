#!/bin/python
import os
import time

os.system("go build UDTClient.go")
os.system("go build UDTServer.go")

for i in [6,7,8,9]:
    print("\nTest for " + str(2**i) +" concurrent connections")
    os.system("./UDTClient -a=10.0.0.26 -l=1000 -s=10000 -rl=5000 -n="+str(2**i)+ \
        " -of=udt_oneway_"+str(2**i) + " -rf=udt_roundtrip_" + str(2**i)+" &")
    time.sleep(1)
    os.system("python measure.py -n UDTClient -t 0")
    time.sleep(5)
