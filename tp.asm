global  main
extern  printf
extern  fopen
extern  fread
extern  gets

section     .data
    fileName                db  "listado.dat",0
    mensajeIngreso          db  "Ingrese el nombre del archivo a ordenar: ",0
    mensajeIngresoOrd       db  "Ingrese A para ordenar de manera ascendente, D para hacerlo de manera descendente: ",0
    mensajeErrorApertura    db  "El archivo no pudo ser abierto, ingrese el nombre nuevamente",10,0
    mensajeArchivoVacio     db  "El archivo ingresado esta vacio",10,0
    mensajePasosIntermedios db  "¿Desea que se muestren los pasos intermedios? (Y/n): ",0
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
    mostrarIntermedios          resb 1
    inputValido                 resb 1
    vector          times 30    resb 1
    posicion                    resq 1

section     .text
main:
    call    pedirNombreArchivo
    call    abrirArchivo
    cmp     byte[inputValido],'N'
    je      main

    call    imprimirInicial
    jmp     validarCantidad

tipoOrdenamiento:
    call    pedirModoOrdenamiento
    call    validarModoOrdenamiento
    cmp     byte[inputValido],'N'
    je      tipoOrdenamiento

mostrarPasosIntermedios:
    call    preguntarPasosIntermedios
    call    validarPasosIntermedios
    cmp     byte[inputValido],'N'
    je      mostrarPasosIntermedios

ordenamiento:
    mov     rcx,[topeVector]
    mov     [posicion],rcx
    mov     rax,0
    mov     rdx,0
    dec     rcx
    call    BubbleSort

finalizar:
    call    imprimirGuiones 
    call    imprimirMensajeFinal
    call    imprimirVector
    call    imprimirGuiones

finalPrograma:
ret

;=====================Solicitar ingresos=================
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
    mov     al,[registro]
    mov     rbx,[topeVector]
    mov     [vector + rbx],al
    add     qword[topeVector],1
ret

;============== BubbleSort ===================

BubbleSort:
loopExterno:
    mov     [posicion],rcx
    mov     r8,0
    mov     rbx,rcx     ;mas alla del indice rcx, el vector esta ordenado

loopInterno:
    mov     al,[vector+r8]

    mov     r9,r8
    inc     r9

    mov     dl,[vector+r9]

    cmp     byte[modoOrdenamiento],'A'
    je      ascendente

    cmp     byte[modoOrdenamiento],'D'
    je      descendente

ascendente:
    cmp     al,dl
    jmp     movimiento

descendente:
    cmp     dl,al

movimiento:
    jl      noSwap

    mov     [vector+r8],dl
    mov     [vector+r9],al

noSwap:    
    inc     r8
    dec     rbx
    cmp     rbx,0
    jg      loopInterno

    cmp     byte[mostrarIntermedios],'N'
    je      continuarOrdenamiento

    push    rcx
    call    imprimirIteracion
    call    imprimirVector
    pop     rcx

continuarOrdenamiento:
    loop    loopExterno
ret

;========= Validaciones ===========
validarModoOrdenamiento:
    mov     byte[inputValido],'S'

    cmp     byte[modoOrdenamiento],'A'
    je      valido

    cmp     byte[modoOrdenamiento],'a'
    je      validoMinuscula

    cmp     byte[modoOrdenamiento],'D'
    je      valido

    cmp     byte[modoOrdenamiento],'d'
    je      validoMinuscula

    mov     byte[inputValido],'N'

validoMinuscula:
    sub     byte[modoOrdenamiento],20h ;En la tabla ascii, las minusculas estan a 20h lugares de las mayusculas.
valido:
ret

validarCantidad:
    cmp     qword[topeVector],0
    je      vectorVacio
 
    cmp     qword[topeVector],1
    je      finalizar

    jmp     tipoOrdenamiento

validarPasosIntermedios:
    mov     byte[inputValido],'S'

    cmp     byte[mostrarIntermedios],'Y'
    je      validoIntermedio

    cmp     byte[mostrarIntermedios],'y'
    je      validoMinusculaIntermedio

    cmp     byte[mostrarIntermedios],'N'
    je      validoIntermedio

    cmp     byte[mostrarIntermedios],'n'
    je      validoMinusculaIntermedio

    mov     byte[inputValido],'N'

validoMinusculaIntermedio:
    sub     byte[mostrarIntermedios],20h
validoIntermedio:
ret

;========= Imprimir ===============

imprimirInicial:
    mov     rbx,0
    mov     rdi,mensajeVectorInicial
    sub     rax,rax
    call    printf
    call    imprimirVector
ret

preguntarPasosIntermedios:
    mov     rdi,mensajePasosIntermedios
    sub     rax,rax
    call    printf

    mov     rdi,mostrarIntermedios
    call    gets
ret

ret

vectorVacio:
    mov     rdi,mensajeArchivoVacio
    sub     rax,rax
    call    printf
    mov     rbx,0

    jmp     finalPrograma

imprimirVector:
    mov     rdi,mensaje
    mov     rsi,[vector+rbx]
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

imprimirMensajeFinal:
    mov     rdi,mensajeVectorFinal
    sub     rax,rax
    call    printf
    mov     rbx,0
ret

imprimirGuiones:
    mov     rdi,mensajeGuiones
    sub     rax,rax
    call    printf
ret