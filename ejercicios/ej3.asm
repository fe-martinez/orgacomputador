global main
extern printf

section     .data
    varx dq     5    
    vary dq     2
    resultado db    "%i",0

section     .bss
    actual      resq 8
section     .text
main:
    mov     rcx,[vary]
    mov     rbx,[varx]
    mov     rax,rbx
    cmp     rcx,1
    je      fin
    dec     rcx

multi:
    imul    rbx
    loop    multi

fin:
    mov     rdi,resultado
    mov     rsi,rax
    xor     rax,rax
    call    printf
    ret
