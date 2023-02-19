    .equ OPEN_FILE 0x66
    .equ CLOSE_FILE 0x68
    .equ PRINT_INTEGER 0x6b
    .equ READ_INTEGER 0x6c
    .equ EXIT_PROGRAM 0x11

    .data
filename:
    .asciz "archivin"

    .text
    mov r0, =filename
    mov r1, #0
    swi OPEN_FILE
    mov r5, r0
    swi READ_INTEGER

    mov r3, r0
    mov r4, #1
    @r4 acumulador, r3 numero leido por texto.

loop:
    mul r5, r4, r3
    mov r4, r5

    mov r0, #1
    mov r1, r4

    swi PRINT_INTEGER

    sub r4, #1
    cmp r4, 0
    ble fin
    b loop

fin:
    swi EXIT_PROGRAM
    .end