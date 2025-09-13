section .data
    palabra db "tortilla", 0
    N       equ $ - palabra - 1        ; longitud sin el byte 0
    spc     db ' '
    nl      db 10

section .bss
    buf     resb 4                     ; hasta 3 dígitos

section .text
    global _start

_start:
    xor rsi, rsi                       ; índice 0..N-1

.next_char:
    cmp rsi, N
    je  .end

    ; 1) cargar carácter actual → EAX (0..255)
    movzx eax, byte [palabra + rsi]

    ; 2) conversión decimal EN LÍNEA (sin call/ret)
    mov r8d, eax                       ; valor a convertir
    mov rdi, buf + 3                   ; cursor al final del buffer
    xor rcx, rcx                       ; contador de dígitos

    ; caso raro: si el valor fuese 0 (no pasa con letras, pero por robustez)
    test r8d, r8d
    jnz .conv_loop
    mov byte [buf+2], '0'
    mov rdi, buf + 2
    mov rcx, 1
    jmp .print_number

.conv_loop:
    xor rdx, rdx
    mov eax, r8d
    mov ebx, 10
    div ebx                            ; eax=cociente, edx=resto
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    mov r8d, eax
    test r8d, r8d
    jnz .conv_loop

.print_number:
    ; 3) write(1, rdi, rcx)  -> imprimir número
    mov r10, rdi                       ; guardo puntero (porque rdi se usa en write)
    mov rax, 1
    mov rdi, 1
    mov rsi, r10
    mov rdx, rcx
    syscall

    ; 4) imprimir separador (espacio) o '\n' si es el último
    inc rsi
    cmp rsi, N
    je  .print_nl

    mov rax, 1
    mov rdi, 1
    mov rsi, spc
    mov rdx, 1
    syscall
    jmp .next_char

.print_nl:
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall
    jmp .next_char

.end:
    mov rax, 60
    xor rdi, rdi
    syscall
