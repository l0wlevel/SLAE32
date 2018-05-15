global _start			

section .text
_start:

	push byte 25
	pop eax
	cdq
	push edx
	mov ebx,esp
	int 0x80
	inc eax
	int 0x80
