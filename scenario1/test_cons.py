#!/usr/bin/python
import os
import time
import argparse


parser = argparse.ArgumentParser()
parser.add_argument('-c',"--ctype", default="tcp",
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
        os.system("./Consumer -c "+ args.ctype+ " -a="+ args.address +" -l=1000 -s="+ str(args.stopnum) +" -rl=5000 -pn 1 -n="+str(2**i)+ \
            " -of="+args.ctype+"_"+args.type+"_oneway_"+str(2**i) + " -rf="+args.ctype+"_"+args.type+"_roundtrip_" + str(2**i)+" &")
        time.sleep(1)
        os.system("python measure.py -n Consumer -t 0")
        time.sleep(5)
elif args.type == "fanin" :
    for i in [6,7,8,9]:
        print("\nTest for " +args.type +" model with "+ str(2**i) +" concurrent producers and 1 consumer")
        os.system("./Consumer -c "+ args.ctype+ " -a="+ args.address +" -l=1000 -s="+ str(args.stopnum) +" -rl=5000 -n=1 -pn="+str(2**i)+ \
            " -of="+args.ctype+"_"+args.type+"_oneway_"+str(2**i) + " -rf="+args.ctype+"_"+args.type+"_roundtrip_" + str(2**i)+" &")
        time.sleep(1)
        os.system("python measure.py -n Consumer -t 0")
        time.sleep(5)
