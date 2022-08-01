global  main
extern  printf

section     .data
    matriz      dq  1,2,3
                dq  4,10,6
                dq  7,8,9

    fil         dq  0
    col         dq  0
    sumatoria   dq  0
    mensaje     db  "El valor de la traza es %li",10,0

section     .text
main:
    mov     rcx,3

traza:
    mov     rax,[fil]
    mov     rbx,[col]
    imul    rax,8
    imul    rax,3
    imul    rbx,8
    mov     r8,rax
    add     r8,rbx
    mov     rdx,[matriz + r8]
    add     [sumatoria],rdx

    mov     rax,[fil]
    mov     rbx,[col]
    add     rax,1
    add     rbx,1
    mov     [fil],rax
    mov     [col],rax
    loop    traza

imprimir:
    mov     rdi,mensaje
    mov     rsi,[sumatoria]
    sub     rax,rax
    call    printf

    ret

