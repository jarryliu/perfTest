#!/usr/bin/python
import os
import time
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-c',"--ctype", default = "tcp",
                    help='sum the integers (default: find the max)')
parser.add_argument('-b', "--buildonly", help="go build everything only",
                    action="store_true")
parser.add_argument("-t", "--type", default="fanout",
                    help="type of test, either fanin or fanout")
parser.add_argument("-a", "--address", default="10.0.0.26",
                    help="ip address of producer")
parser.add_argument("-s", "--stopnum", type= int, default=20000,
                    help="number of message to send before stop")



args = parser.parse_args()

if (args.buildonly) :
    os.system("go build Consumer.go")
    os.system("go build Producer.go")
    exit(0)

if args.type == "fanout":
    for i in [6,7,8,9]:
        print("\nTest for " +args.type +" model with "+ str(2**i) +" concurrent consumers and 1 producer")
        os.system("./Producer -c "+ args.ctype+ " -l=1000 -s="+ str(args.stopnum) +" -pn 1 -n="+str(2**i) + " &")
        time.sleep(1)
        os.system("python measure.py -n Producer -t 0")
elif args.type == "fanin" :
    for i in [6,7,8,9]:
        print("\nTest for " +args.type +" model with 1 consumers and "+ str(2**i) +" producer")
        os.system("./Producer -c "+ args.ctype+ " -l=1000 -s=" + str(args.stopnum) + " -n=1 -pn="+str(2**i)+" &")
        time.sleep(1)
        os.system("python measure.py -n Producer -t 0")
