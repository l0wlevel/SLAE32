#!/usr/bin/python
# Script to automate shellcode compiling process 
# fixing desired port by using template
# Author: l0wlevel

import os
import sys
import struct

f1=sys.argv[1]+'.nasm'
port=int(sys.argv[2])
f2=sys.argv[1]+'Compile.nasm'

# Reverse hex port
x = struct.unpack('<H', struct.pack('>H',port))[0]
revHexPort = hex(x)
# Replace selected port in template
os.system('cp '+f1+' '+f2)
with open(f2,'r') as file:
    filedata = file.read()
filedata= filedata.replace('#REPLACE#',str(revHexPort))
with open(f2,'w') as file:
    file.write(filedata)
#Assembling
y=f2.split(".")[0]+'.o '
os.system('nasm -f elf32 -o '+y+f2)
#Linking
os.system('ld -z execstack -o '+f2.split(".")[0]+' '+y)
os.system('sh launcher.sh '+f2.split(".")[0])

