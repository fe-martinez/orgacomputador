    .equ OPEN_FILE 0x66
    .equ CLOSE_FILE 0x68
    .equ END_PROGRAM 0x11
    .equ READ_INTEGER 0x6c
    .equ PRINT_INTEGER 0x6b

    .data
filename:
    .asciz "archivo.txt"
    .align

    .text
    .global _start
_start:
abrirArchivo:
    ldr r0, =filename
    mov r1, #0
    swi OPEN_FILE
    mov r5, r0

    bcs fileError
    swi READ_INTEGER

calcularAbsoluto:

    cmp r0, #0
    bmi valorNegativo
    mov r1, r0

cerrarArchivo:
    mov r0, r5
    swi CLOSE_FILE

imprimirPorPantalla:
    mov r0, #1
    swi PRINT_INTEGER
    b fin


fileError:
    b fin

fin:
    swi END_PROGRAM
    .end

valorNegativo:
    mov r3, #0
    sub r0, r3, r0
    mov r1, r0
    b cerrarArchivo
