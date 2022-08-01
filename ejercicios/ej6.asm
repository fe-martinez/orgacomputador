global main
extern printf

section     .data
    vector      dq  1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
    posicion    dq  0
    largo       dq  20
    mensaje     db  "Pos %li ----> %li",10,0

section     .text
main:

swap:
    mov     rax,[posicion]
    mov     rbx,[largo]
    sub     rbx,[posicion]
    mov     rdx,[vector + rax*8]
    mov     r8,[vector + rbx*8]
    mov     [vector + rax*8],r8
    mov     [vector + rbx*8],rdx

    add     rax,1
    mov     [posicion],rax
    cmp     rax,rbx
    jge     terminar
    loop    swap

terminar:
    mov     rcx,[largo+1]
    mov     rbx,0
imprimir:
    mov     rdi,mensaje
    mov     rsi,rbx
    mov     rdx,[vector+rbx*8]
    sub     rax,rax
    call    printf
    add     rbx,1
    cmp     rbx,[largo]
    jg      finalizar
    loop    imprimir

finalizar:
    ret
