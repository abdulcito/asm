section .data

    nums: dd 10, 20, 30, 40, 50
    newline db 10

    cuenta equ ($ - nums)/4

section .bss

    buffer resd 34

section .text
    global _start

_start:

    xor rax, rax ; rax=0 (acumulador de sumatoria)
    xor rcx, rcx ; rcx = 0 (indice i)

    ;sumatoria
sumaloop:

    cmp rcx, cuenta ; cuando rcx==cuenta , se acabara la sumatoria
    je finsuma
    mov edx, [nums + rcx*4] ; edx=nums(rcx)
    add rax, rdx ;sumatoria
    inc rcx ; se incrementa el indice
    jmp sumaloop

finsuma:

    xor rdx, rdx ; rdx=0
    mov rbx, cuenta ;rbx=cuenta
    div rbx ; rdx:rax / rbx 
    mov rsi, rax ;rsi=rax (resultado del promedio)

    mov rdi, buffer + 31
    xor rcx, rcx


convert:

    xor rdx, rdx
    mov rax, rsi
    mov rbx, 10
    div rbx ; divide rdx:rax/rbx -> rdx=resto, rax=cociente
    add dl, '0'
    dec rdi ; retrocede 1 byte
    mov [rdi], dl
    inc rcx
    mov rsi, rax
    test rsi, rsi
    jnz convert

    ;impresion

    mov rax, 1
    mov rsi, rdi
    mov rdi, 1
    mov rdx, rcx
    syscall
    
    ;implementar salto de linea

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ;salir

    mov rax, 60
    mov rdi, 0
    syscall

