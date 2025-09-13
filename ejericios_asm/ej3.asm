section .data

    nums: db 2, 7, 45, 2, 2, 7, 5, 7, 7
    N equ ($ - nums)/1
    newline db 10

section .bss

    num_mod resb 2 ; el numero que mas se repite

section .text

    global _start

_start:

    xor rcx, rcx ; i=0 en loop loopN1
    xor r8, r8 ; i=0 en loopN2
    xor rax, rax ; nums[i]
    mov rsp, 0 ; valor inicial

loopN1:

    cmp rcx, N
    je fin
    movzx eax, byte [nums + rcx*1] ;rax = num[i]
    xor r9, r9
    xor r8, r8
    inc rcx
    jmp loopN2

loopN2:

    cmp r8, N
    je loopN1
    movzx esi, byte [nums + r8*1] ;rsi sera los numero de nums
    inc r8
    cmp eax, esi
    je contador
    jmp loopN2

contador:

    inc r9
    cmp r9, rsp
    jg asignar_moda
    jmp loopN2

asignar_moda:

    mov rbp, rax
    mov rsp, r9
    jmp loopN2

fin:

    add bpl, '0'
    mov [num_mod], bpl
    ;syswrite
    mov rax, 1
    mov rdi, 1
    mov rsi, num_mod
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ;exit
    mov rax, 60
    mov rdi, 0
    syscall





