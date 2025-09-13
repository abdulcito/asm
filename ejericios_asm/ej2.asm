section .data
    nums: dw 7, 19, 6, 12, 10, 5, 3, 60, 8, 22 ;2 bytes
    newline db 10
    N equ 10

section .bss

    buf_p resb 1 
    buf_i resb 1

section .text

    global _start

_start:

    ;loop de 10 veces

    xor rax, rax ; rax sera el cociente
    xor rcx, rcx ; rcx sera el indice
    xor r9, r9 ; r9 contador par
    xor r8, r8 ; r8 contador impar

division:

    cmp rcx, N
    je fin
    movzx eax, word [nums+rcx*2] ; eax=nums[rcx] ahora se limpiaron 32/64 bits de rax
    ;xor rdx, rdx
    ;mov rbx, 2
    ;div rbx; rdx:rax/2 , si rdx==0 par, sino impar
    inc rcx
    test eax, 1 ; eax & 1 == 0 (es par)
    jz f_par
    jmp f_impar


f_impar:

    inc r8
    jmp division

f_par:

    inc r9
    jmp division

fin:


    add r8b, '0'
    mov [buf_i], r8b
    ;syswrite impar
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_i
    mov rdx, 1
    syscall

    ;salto de linea
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall    


    add r9b, '0'
    mov [buf_p], r9b
    ;syswrite par
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_p
    mov rdx, 1
    syscall

    ;salto de linea
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall 

    ;exit
    mov rax, 60
    mov rdi, 0
    syscall


