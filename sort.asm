global main
extern printf

section     .data
    array       dq  1,4,15,6,13,9,0,2
    mensaje     db  "| %i |",0
    espacio     db  10,0
    posicion    dq  7
    cantidad    dq  7

section     .text
main:
    mov     rcx,[cantidad]
    call    BubbleSort
    call    imprimir
ret

BubbleSort:
loopExterno:
    mov     [posicion],rcx
    mov     r8,0
    mov     rbx,rcx

loopInterno:
    mov     rax,[array+r8*8]
    mov     r9,r8
    add     r9,1
    mov     rdx,[array+r9*8]
    cmp     rax,rdx

    jle      noSwap

    mov     [array+r8*8],rdx
    mov     [array+r9*8],rax

noSwap:    
    inc     r8
    dec     rbx
    cmp     rbx,0
    jne     loopInterno

    call    imprimir

    mov     rcx,[posicion]
    loop    loopExterno
ret


imprimir:
    mov     rdi,mensaje
    mov     rsi,[array+rbx*8]
    sub     rax,rax
    call    printf
    add     rbx,1
    cmp     rbx,qword[cantidad]
    jle     imprimir
    jg      finLoop

finLoop:
    mov     rdi,espacio
    sub     rax,rax
    call    printf

ret