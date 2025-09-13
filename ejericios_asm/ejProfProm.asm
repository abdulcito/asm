section .data
    nums: dd 10, 20, 30, 40, 50     ; enteros de 32 bits
    CUENTA equ ($ - nums) / 4        ; numero de elementos

    newline db 10                   ; enter

section .bss

    buf resb 32

section .text
    global _start

_start:

    xor rax, rax        ; rax => sumatoria
    xor rcx, rcx        ; rcx => indice

sum_loop:
    cmp rcx, CUENTA
    je fin_suma
    mov edx, [nums + rcx*4]
    add rax, rdx
    inc rcx
    jmp sum_loop


fin_suma:
    xor rdx, rdx
    mov rbx, CUENTA
    div rbx
    mov rsi, rax

; ----- Conversion entera en registro RSI a cadena de caracteres decimal en buf ------
; Vamos a escribir los numeros al reves para que se vean correctamente en el terminal
    mov rdi, buf + 31       ; nos ponemos al final del arreglo de impresion
    mov rcx, 0              ; contador de digitos

conversion:
    xor rdx, rdx            ; limpiamos rdx -> rdx = 0
    mov rax, rsi
    mov rbx, 10
    div rbx
    add dl, '0'             ; desplazamiento desde la base ascii
    dec rdi 
    mov [rdi], dl
    inc rcx
    mov rax, rsi
    cmp rsi, 0
    jnz conversion

    ; syswrite
    mov rax, 1
    mov rdi, 1
    mov rsi, buf
    mov rdx, rcx
    syscall


    ; syswrite enter
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; sysexit
    mov rax, 60
    mov rdi, 0
    syscall