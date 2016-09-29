#!/usr/bin/python
import os
import time
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-b', "--buildonly", help="go build everything only",
                    action="store_true")
parser.add_argument("-a", "--address", default="10.0.0.26",
                    help="ip address of producer")
parser.add_argument("-s", "--stopnum", type=int, default=10000000,
                    help="number of message to send before stop")

args = parser.parse_args()

ctypeList = ["tcp", "udp"]# "udt"]
sizeList = [100, 1000, 2000]
intervalList = [100, 10, 0]
if (args.buildonly) :
    os.system("go build Consumer.go")
    os.system("go build Producer.go")
    exit(0)

stopNum = args.stopnum
for ctype in ctypeList:
    for interval in intervalList:
        if interval != 0 :
            stopNum = args.stopnum/interval
        else:
            stopNum = args.stopnum
        for size in sizeList:
            print("\nTest for " + ctype + " with 1 consumer and 1 producer")
            cmdStr = "./Consumer -c "+ ctype+ " -a="+ args.address +" -s=" +str(stopNum)+ " -rl=10000 -pn 1 -n=1 -l " + str(size) + \
                " -of="+ctype+"_len_" + str(size)+ "_int_"+str(interval)+" &"
            print(cmdStr)
            os.system(cmdStr)
            time.sleep(1)
            os.system("python measure.py -n Consumer -t 0")
            time.sleep(5)
