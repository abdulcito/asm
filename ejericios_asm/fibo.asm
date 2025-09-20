section .data
    newline db 10

section .bss
    num resb 4 ;alamcenamos numero de hasta 3 digitos + '0'
section .text
    global _start
_start:


    xor r8, r8 ; contador
    mov rbx, 0
    mov r12, 1
    ; rbx, r12, rax --> estructura de serie de fibonacci

loop:   
    cmp r8, 10
    je fin

    mov rax, rbx
    call print

    mov rax, rbx
    add rax, r12
    mov rbx, r12
    mov r12, rax
    inc r8

    jmp loop


print:
  ;caso en donde rax=0
    test rax, rax
    jnz pre_conv
    mov byte[num+2], '0'
    mov rsi, num+2
    mov r10, 1
    jmp emit


pre_conv:                ;rsi --> sera cursor del buffer
    mov rsi, num+3
    mov byte[rsi], 0
    mov r10, 0 ;   r10 --> sera contador de digitos

conv:
    xor rdx, rdx ; rdx --> residuo
    mov r9, 10 ; r9 --> dividendo
    div r9  ; rdx = residuo , rax = cociente
    add dl, '0' ; digito ascii
    dec rsi  ;retrocedemos un byte en rsi
    inc r10 ; incrementamos el contador de digitos
    mov [rsi], dl
    test rax, rax ; si rax(cociente != 0) volvera a dividir 
    jnz conv


emit:
    ;syswrite
    mov rax, 1
    mov rdi, 1
    mov rdx, r10
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ret


fin:

    mov rax, 60
	mov rdi, 0
	syscall
