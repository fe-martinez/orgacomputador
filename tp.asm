global  main
extern  printf
extern  fopen
extern  fread
extern  gets

;BubbleSort con numeros en BPF c/signo de 8bits. Cada byte del archivo representa a uno de los numeros.

section     .data
    mensajeIngreso          db  "Ingrese el nombre del archivo a ordenar: ",0
    mensajeIngresoOrd       db  "Ingrese A para ordenar de manera ascendente, D para hacerlo de manera descendente: ",0
    mensajeErrorApertura    db  "El archivo no pudo ser abierto, ingrese el nombre nuevamente",10,0
    mensajeArchivoVacio     db  "El archivo ingresado esta vacio",10,0
    mensajeTruncamiento     db  "~~AVISO: El archivo ingresado tiene mas de 30 numeros, el vector fue llenado con los primeros 30 valores.~~",10,10,0
    mensajePasosIntermedios db  "¿Desea que se muestren los pasos intermedios? (Y para mostrar solo la siguiente iteracion, N para mostrar todas las iteraciones, X para mostrar solo el resultado final): ",0
    mensajeIteracion        db  "->Estado del vector despues de la iteracion %i:",10,0
    mensajeSigIteracion     db  "¿Desea mostrar solo la siguiente iteracion? (Y para mostrar la siguiente iteracion/N para mostrar todo hasta el final/X para mostrar solo el resultado): ",0
    mensajeVectorInicial    db  "Vector cargado: ",10,0
    mensajeVectorFinalAsc   db  "Vector ordenado de manera ascendente: ",10,0
    mensajeVectorFinalDes   db  "Vector ordenado de manera descendente: ",10,0
    mensajeGuiones          db  "////////////////////////////////////////////////////////////////////",10,0
    modo                    db  "rb",0
    mensaje                 db  "| %hhi |",0
    espacio                 db  10,10,0
    fileHandle              dq  0
    topeVector              dq  0
    registro                db  0

section     .bss
    fileNameP                   resb 50
    modoOrdenamiento            resb 4
    mostrarIntermedios          resb 4
    mostrarIntermediosMedio     resb 4
    inputValido                 resb 1
    vector          times 30    resb 1
    posicion                    resq 1

section     .text
;=========================================================
;                       MAIN
;=========================================================
main:
    call    procesarArchivo
    jmp     validarCantidad
cantidadesOk:
    call    imprimirInicial
    call    tipoOrdenamiento
    call    mostrarPasosIntermedios

    call    BubbleSort
mensajeFinal:
    call    imprimirMensajeFinal
finalPrograma:
ret

;=========================================================
;                   MANEJO DE ARCHIVO
;=========================================================
procesarArchivo:
    call    pedirNombreArchivo
    call    abrirArchivo
    cmp     byte[inputValido],'N'
    je      procesarArchivo
ret

pedirNombreArchivo:
    mov     rdi,mensajeIngreso
    sub     rax,rax
    call    printf

    mov     rdi,fileNameP
    call    gets
ret

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

    ;Lee el archivo mientras haya datos
    call    llenarVector
    jmp     leerArchivo

endOfFile:
ret

;Vuelve a pedir el nombre del archivo
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

;Por enunciado, n <= 30, 0 y 1 se tratan como casos borde
validarCantidad:
    cmp     qword[topeVector],0
    je      imprimirVectorVacio
 
    cmp     qword[topeVector],1
    je      mensajeFinal

    cmp     qword[topeVector],30
    jle     cantidadesOk

    ;Se trunca a 30 por enunciado.
    mov     qword[topeVector],30
    call    imprimirAvisoTruncamiento
    jmp     cantidadesOk

;=========================================================
;                   MODO DE ORDENAMIENTO
;=========================================================
;A/a para ascendente, D/d para descendente.
tipoOrdenamiento:
    call    pedirModoOrdenamiento
    call    validarModoOrdenamiento
    cmp     byte[inputValido],'N'
    je      tipoOrdenamiento
ret

pedirModoOrdenamiento:
    mov     rdi,mensajeIngresoOrd
    sub     rax,rax
    call    printf

    mov     rdi,modoOrdenamiento
    call    gets
ret

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

;=========================================================
;              MOSTRAR PASOS INTERMEDIOS
;=========================================================
;Y/y para mostrar la siguiente iteracion, N/n para mostrar todas las iteraciones juntas, X/x para mostrar solo el resultado
mostrarPasosIntermedios:
    call    preguntarPasosIntermedios
    call    validarPasosIntermedios
    cmp     byte[inputValido],'N'
    je      mostrarPasosIntermedios
ret

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

    cmp     byte[mostrarIntermedios],'X'
    je      validoIntermedio

    cmp     byte[mostrarIntermedios],'x'
    je      validoMinusculaIntermedio

    mov     byte[inputValido],'N'

validoMinusculaIntermedio:
    sub     byte[mostrarIntermedios],20h
validoIntermedio:
ret

;=========================================================
;                   BUBBLE SORT
;=========================================================
BubbleSort:
    mov     rcx,[topeVector]
    mov     rax,0
    mov     rdx,0
    dec     rcx

loopExterno:
    mov     [posicion],rcx
    mov     r8,0
    mov     rbx,rcx     ;mas alla del indice en rcx, el vector esta ordenado

loopInterno:
    mov     al,[vector+r8]
    mov     r9,r8
    inc     r9
    mov     dl,[vector+r9]

    cmp     byte[modoOrdenamiento],'A'
    je      ascendente

    cmp     byte[modoOrdenamiento],'D'
    je      descendente

;Se comparan i e i+1, se hace un swap en el vector si estan desordenados
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

    push    rcx
    ;Si el user ingreso y, se le pregunta que quiere hacer, si ingreso N se imprimen todas las iteraciones sin preguntar.
    cmp     byte[mostrarIntermedios],'X'
    je      continuarOrdenamiento

    call    imprimirIteracion
    call    imprimirVector

    cmp     byte[mostrarIntermedios],'N'
    je      continuarOrdenamiento

    call    imprimirSiguienteIter
    call    validarPasosIntermedios
continuarOrdenamiento:
    pop     rcx
    dec     rcx
    cmp     rcx,0
    jg      loopExterno ;cmp y jg porque excede el near jump
ret

;=========================================================
;                       MENSAJES
;=========================================================
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

imprimirVectorVacio:
    mov     rdi,mensajeArchivoVacio
    sub     rax,rax
    call    printf
    mov     rbx,0
    ;Hace un salto directamente al final del programa.
    jmp     finalPrograma

imprimirAvisoTruncamiento:
    mov     rdi,mensajeTruncamiento
    sub     rax,rax
    call    printf
ret

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

imprimirSiguienteIter:
    mov     rdi,mensajeSigIteracion
    sub     rax,rax
    call    printf

    mov     rdi,mostrarIntermedios
    call    gets
ret

imprimirMensajeFinal:
    call    imprimirGuiones
    cmp     byte[modoOrdenamiento],'A'
    je      msjAscendente

    cmp     byte[modoOrdenamiento],'D'
    je      msjDescendente

msjAscendente:
    mov     rdi,mensajeVectorFinalAsc
    jmp     continuarFinal

msjDescendente:
    mov     rdi,mensajeVectorFinalDes

continuarFinal:
    sub     rax,rax
    call    printf
    mov     rbx,0
    call    imprimirVector
    call    imprimirGuiones
ret

imprimirGuiones:
    mov     rdi,mensajeGuiones
    sub     rax,rax
    call    printf
ret