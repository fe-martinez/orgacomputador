    .equ END_PROGRAM 0x11
    .equ PRINT_STRING 0x69

    .data
string:
    .asciz "Hola"

    .text
    .global _start
_start:
    mov r0, #1
    ldr r1, =string
    swi PRINT_STRING

    swi END_PROGRAM
    .end


