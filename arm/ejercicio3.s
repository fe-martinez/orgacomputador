    .equ END_PROGRAM 0x11

    .data
x:
    .word 5

y:
    .word 4

    .text
    .global _start
_start:
    ldr r0, =x
    ldr r0, [r0]

    ldr r1, =y
    ldr r1, [r1]

    add r2, r0, r1
    sub r3, r0, r1
    mul r4, r0, r1

    and r5, r0, r1
    eor r6, r0, r1
    orr r7, r0, r1
    mov r8, r0, LSL r1
    mov r9, r0, LSR r1
    mov r10, r0, ASR r1

    swi END_PROGRAM
    .end