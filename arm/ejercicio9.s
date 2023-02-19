    .equ OPEN_FILE 0x66
    .equ CLOSE_FILE 0x68
    .equ READ_INTEGER 0x6c
    .equ PRINT_INTEGER 0x6b
    .equ EXIT_PROGRAM 0x11
    .equ PRINT_STRING 0x69

    .data
stringMinimo:
    .asciz "Min"

stringMaximo:
    .asciz "Max"

filename:
    .asciz "archivo.txt"

    .text
    .global _start
_start:
abrirArchivo:
    ldr r0, =filename
    mov r1, #0
    swi OPEN_FILE

leerArchivo:
    mov r6, r0
    swi READ_INTEGER
    mov r2, r0
    swi READ_INTEGER
    mov r3, r0

cerrarArchivo:
    mov r0, r6
    swi CLOSE_FILE

calcularResultado:
    cmp r2, r3
    movmi r2, r4
    movmi r3, r5
    movpl r2, r5
    movpl r3, r4

imprimirResultado
    ldr r1, =stringMinimo
    mov r0, #1
    swi PRINT_STRING

    mov r0, #1
    mov r1, r4
    swi PRINT_INTEGER

    ldr r1, =stringMaximo
    mov r0, #1
    swi PRINT_STRING

    mov r0, #1
    mov r1, r5
    swi PRINT_INTEGER

    swi EXIT_PROGRAM
    .end
