    .equ END_PROGRAM 0x11
    .equ OPEN_FILE 0x66
    .equ CLOSE_FILE 0x68
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

    bcs inFileError
    mov r5,r0

leerEntero:
    swi READ_INTEGER
    mov r1, r0
    mov r0, #1
    swi PRINT_INTEGER

cerrarArchivo:
    mov r0, r5
    swi CLOSE_FILE
    b fin

inFileError:
    b fin

fin:
    swi END_PROGRAM
    .end