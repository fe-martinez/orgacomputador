    .equ PRINT_INTEGER 0x6b
    .equ EXIT_PROGRAM 0x11
    
    .data
comienzo:
    .word 0

final:
    .word 10

    .text
    .global _start
_start:
    mov r5, =final
    mov r5, [r5]
    mov r4, =comienzo
    mov r4, [r4]
    mov r0, #1

loop:
    mov r1, r4
    swi PRINT_INTEGER
    add r4, 1
    cmp r4, r5
    bpl loop

    swi EXIT_PROGRAM
    .end