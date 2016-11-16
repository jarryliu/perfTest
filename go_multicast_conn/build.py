#!/usr/bin/python
import os, glob

for file in glob.glob('./*.go'):
    os.system("go build " + file)
    os.system("go build " + file)
