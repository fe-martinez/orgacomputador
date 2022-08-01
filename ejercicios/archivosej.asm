global  main
extern  fopen
extern  fread
extern  fclose
extern  printf

section     .data
    fileName    db  "ejemplo.dat",0
    modo        db  "rb",0
    mensaje     db  "%s",10,0
    hola        db  "Hola",0

section     .bss
    idArchivo   resq    1
    registro    resb    32

section     .text
main:
    mov     rdi,fileName
    mov     rsi,modo
    call    fopen

    cmp     rax,0
    jle     errorOpen
    mov     qword[idArchivo],rax

    mov     rdi,registro
    mov     rsi,32
    mov     rdx,1
    mov     rcx,[idArchivo]
    call    fread

    mov     rdi,mensaje
    mov     rsi,registro
    sub     rax,rax
    call    printf

    mov     rdi,[idArchivo]
    call    fclose
ret

errorOpen:
    mov     rdi,mensaje
    mov     rsi,hola
    sub     rax,rax
    call    printf

    mov     rdi,[idArchivo]
    call    fclose
ret