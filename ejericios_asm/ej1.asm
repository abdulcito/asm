section .data

    newline db 10

section .bss

    buffer resb 2

section .text

    global _start

_start:

    mov r8, 7 ;contador de iteraciones
    mov bl, 1 ;primer numero

    ;No uses RAX, RCX, R11 para contadores/estado que viven entre syscalls.
    ;Si vas a imprimir en un bucle, guarda el número en BL, R12B, R13B, R14B, R15B (o R8B/R9B si no los usas de argumento).
    ;Cada syscall vuelve a cargar RAX (retorno), así que no confíes en AL después del syscall.
    ;Si usas loop, recuerda que también usa RCX; mejor dec/jnz con un registro “seguro” (ej. R12).
    

printLoop:

    mov al, bl  
    add al, '0'   ; se convierte los 8 bits mas bajos de rbx
    mov [buffer], al
    mov byte [buffer+1], 10

    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 2
    syscall

    inc bl
    dec r8
    jnz printLoop

    mov rax, 60
    mov rdi, 0
    syscall

