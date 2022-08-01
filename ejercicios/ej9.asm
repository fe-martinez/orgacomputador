global  main
extern  puts, printf

section     .data
    matriz      dq  1,2,3,8,9
                dq  0,1,6,5,5
                dq  0,0,9,6,7
                dq  0,0,0,6,7
                dq  0,0,0,0,7

    fil         dq  1
    col         dq  0
    sumatoria   dq  0
    totalfilas  dq  4
    mensajeError        db  "La matriz no es triangular inferior",10,0
    mensajeExito        db  "La matriz es triangular inferior",10,0
    mensaje             db  "fil %li, col %li",10,0

section     .text
main:
    mov     rdx,0

empezarfila:
    mov     r8,[fil]
    add     r8,[col]  
    add     r8,1        ;cantidad de veces que voy a tener que iterar la fila actual

continuar:
    mov     rbx,[fil]
    mov     rcx,[col]
    imul    rbx,8
    imul    rbx,5
    imul    rcx,8

    mov     rax,rbx
    add     rax,rcx
    add     rdx,[matriz + rax]

    mov     rdi,mensaje
    mov     rsi,r8
    sub     rax,rax
    call    printf

    cmp     rdx,0
    jnz     final

    sub     r8,1
    cmp     r8,1
    jg      siguientenumero
    jle     siguientefil

siguientenumero:
    mov     rcx,[col]
    add     rcx,1
    mov     [col],rcx
    cmp     rcx,0
    jnz     continuar

siguientefil:
    mov     qword[col],0
    mov     rcx,[col]
    inc     rcx
    mov     [col],rcx
    mov     rbx,[fil]
    inc     rbx
    mov     [fil],rbx
    cmp     rbx,[totalfilas]
    jg      final
    jle     empezarfila

final:
    cmp     rdx,0
    je      imprimirmensajeexito
    jne     imprimrmensajenoexito

imprimirmensajeexito:
    mov     rdi,mensajeExito
    call    puts
    ret

imprimrmensajenoexito:
    mov     rdi,mensajeError
    call    puts
    ret
    

;  [(fila-1)*longFila]  + [(columna-1)*longElemento]
;  longFila = longElemento * cantidad columnas