global  main
extern  printf
extern  fopen
extern  fread
extern  gets

section     .data
    fileName                db  "listado.dat",0
    mensajeIngreso          db  "Ingrese el nombre del archivo a ordenar: ",0
    mensajeIngresoOrd       db  "Ingrese el caracer A para ordenar de manera ascendente, D para hacerlo de manera descendente: ",0
    mensajeErrorApertura    db  "El archivo no pudo ser abierto, ingrese el nombre nuevamente",10,0
    mensajeIteracion        db  "Estado del vector despues de la iteracion %i:",10,0
    mensajeSwap             db  "Intercambian la posicion %hhi y %hhi",10,0
    mensajeVectorInicial    db  "Vector cargado: ",10,0
    mensajeVectorFinal      db  "Vector ordenado: ",10,0
    mensajeGuiones          db  "----------------------------------------------------",10,10,0
    modo                    db  "rb",0
    mensaje                 db  "| %hhi |",0
    espacio                 db  10,10,0
    fileHandle              dq  0
    topeVector              dq  0
    registro                db  0

section     .bss
    fileNameP                   resb 50
    modoOrdenamiento            resb 1
    inputValido                 resb 1
    vector          times 30    resb 1
    posicion                    resq 1

section     .text
main:
    call    pedirNombreArchivo
    call    abrirArchivo
    cmp     byte[inputValido],'N'
    je      main

    mov     rbx,0
    mov     rdi,mensajeVectorInicial
    sub     rax,rax
    call    printf
    call    imprimirVector

pedirModo:
    call    pedirModoOrdenamiento
    cmp     byte[modoOrdenamiento],'A'
    je      ascendente
    cmp     byte[modoOrdenamiento],'D'
    je      descendente

ascendente:
    mov     rcx,[topeVector]
    mov     [posicion],rcx
    mov     rax,0
    mov     rdx,0
    dec     rcx
    call    BubbleSort
    jmp     finalizar

descendente:
    mov     rcx,[topeVector]
    mov     [posicion],rcx
    mov     rax,0
    mov     rdx,0
    dec     rcx
    call    BubbleSortDesc

finalizar:
    mov     rdi,mensajeGuiones
    sub     rax,rax
    call    printf    

    mov     rdi,mensajeVectorFinal
    sub     rax,rax
    call    printf
    mov     rbx,0
    call    imprimirVector

    mov     rdi,mensajeGuiones
    sub     rax,rax
    call    printf

finalPrograma:
ret

pedirNombreArchivo:
    mov     rdi,mensajeIngreso
    sub     rax,rax
    call    printf

    mov     rdi,fileNameP
    call    gets
ret

pedirModoOrdenamiento:
    mov     rdi,mensajeIngresoOrd
    sub     rax,rax
    call    printf

    mov     rdi,modoOrdenamiento
    call    gets
ret

;======== Archivo ==================
abrirArchivo:
    mov     byte[inputValido],'S'

    mov     rdi,fileNameP
    mov     rsi,modo
    call    fopen
    cmp     rax,0
    jle     errorApertura

    mov     qword[fileHandle],rax


leerArchivo:
    mov     rdi,registro
    mov     rsi,1
    mov     rdx,1
    mov     rcx,[fileHandle]
    call    fread

    cmp     rax,0
    jle     endOfFile

    call    llenarVector
    jmp     leerArchivo

endOfFile:
ret

errorApertura:
    mov     byte[inputValido],'N'
    mov     rdi,mensajeErrorApertura
    sub     rax,rax
    call    printf
ret

llenarVector:
    mov     ax,[registro]
    mov     rbx,[topeVector]
    imul    rbx,rbx,2
    mov     [vector + rbx],ax
    add     qword[topeVector],1
ret

;============== BubbleSort ===================

BubbleSort:
loopExterno:
    mov     [posicion],rcx
    mov     r8,0
    mov     rbx,rcx

loopInterno:
    mov     ax,[vector+r8*2]

    mov     r9,r8
    inc     r9

    mov     dx,[vector+r9*2]
    cmp     ax,dx

    jle     noSwap

    mov     [vector+r8*2],dx
    mov     [vector+r9*2],ax

noSwap:    
    inc     r8
    dec     rbx
    cmp     rbx,0
    jg      loopInterno

    push    rcx
    call    imprimirIteracion
    call    imprimirVector
    pop     rcx

    loop    loopExterno
ret

BubbleSortDesc:
loopExternoDesc:
    mov     [posicion],rcx
    mov     r8,0
    mov     rbx,rcx

loopInternoDesc:
    mov     ax,[vector+r8*2]

    mov     r9,r8
    inc     r9

    mov     dx,[vector+r9*2]
    cmp     ax,dx

    jge     noSwapDesc

    mov     [vector+r8*2],dx
    mov     [vector+r9*2],ax

noSwapDesc:    
    inc     r8
    dec     rbx
    cmp     rbx,0
    jg      loopInternoDesc

    push    rcx
    call    imprimirIteracion
    call    imprimirVector
    pop     rcx

    loop    loopExternoDesc
ret


;========= Imprimir ===============

imprimirVector:
    mov     rdi,mensaje
    mov     rsi,[vector+rbx*2]
    sub     rax,rax
    call    printf

    add     rbx,1
    cmp     rbx,qword[topeVector]
    jl      imprimirVector
    jg      finImprimir

finImprimir:
    mov     rdi,espacio
    sub     rax,rax
    call    printf
ret


imprimirIteracion:
    mov     rdi,mensajeIteracion
    mov     rax,[topeVector]
    sub     rax,[posicion]
    mov     rsi,rax
    sub     rax,rax
    call    printf
ret
