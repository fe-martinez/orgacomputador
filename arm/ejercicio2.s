    .equ END_PROGRAM 0x11
    .equ PRINT_STRING 0x69

    .data
hola:
    .asciz "Hola\n"
chau:
    .asciz "Chau\n"

    .text
    .global _start
_start:
    ldr r3, =hola
    bl imprimir

    ldr r3, =chau
    bl imprimir

    b fin

imprimir:
    @stmfd sp!, {r0,r1,lr}
    mov r0,#1
    mov r1, r3
    swi PRINT_STRING
    mov pc, lr
    @ldmfd sp!, {r0,r1,pc}
fin:
    swi END_PROGRAM
    .end