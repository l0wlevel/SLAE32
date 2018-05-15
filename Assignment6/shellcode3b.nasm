global _start			

section .text
_start:

	;push byte 25
	;pop eax
	xor eax,eax
	mov al, 20
	add al, 5
	cdq
	push edx
	mov ebx,esp
	int 0x80
	;inc eax
	add eax,1
	int 0x80
