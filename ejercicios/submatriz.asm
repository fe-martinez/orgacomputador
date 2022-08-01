global  main
extern  printf
extern  gets
extern  sscanf

section     .data
    mensajeSolicitarFil     db "Ingrese la fila (1 a 20): ",0
    mensajeSolicitarCol     db "Ingrese la columna (1 a 20): ",0
    mensajeSolicitarDim     db "Ingrese la dimension de la matriz (recuerde que va a ser una matriz cuadrada): ",0
    debugcito               db "(%li ; %li)",10,0
    formato                 db "%li",0
    sumatoria               dq  0
    desplazamiento          dq  0
    ; filaInicio              dq  2
    ; columnaInicio           dq  2
    ; dimension               dq  3
    matrizPrueba            dq  3,5,6,23,1,3,5,6,6,1,3,5,6,6,1,3,5,6,1,1,3,5,6,7,1
          
    msjSumatoria            db  "El valor de la diagonal es %li",10,0

section     .bss
    filaInicioStr           resq 1
    columnaInicioStr        resq 1
    dimensionStr            resq 1
    inputValido             resb 1
    plusRsp		            resq 1
    filaInicio              resq 1
    columnaInicio           resq 1
    dimension               resq 1

section     .text
main:
    call    solicitarFilColDim
    call    validarFilColDim
    cmp     byte[inputValido],'N'
    je      main

    call    obtenerDesplazamientoDiagonal
    call    sumarDiagonal

    mov     rdi,msjSumatoria
    mov     rsi,[sumatoria]
    sub     rax,rax
    call    printf
ret

solicitarFilColDim:
    mov     rdi,mensajeSolicitarFil
    sub     rax,rax
    call    printf

    mov     rdi,filaInicioStr
    call    gets

    mov     rdi,mensajeSolicitarCol
    sub     rax,rax
    call    printf

    mov     rdi,columnaInicioStr
    call    gets

    mov     rdi,mensajeSolicitarDim
    sub     rax,rax
    call    printf

    mov     rdi,dimensionStr
    call    gets
ret

validarFilColDim:
    mov     byte[inputValido],'N'

    mov     rdi,filaInicioStr
    mov     rsi,formato
    mov     rdx,filaInicio
    call    checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]

    cmp     rax,1
    jne     invalido

    cmp     qword[filaInicio],1
    jl      invalido
    cmp     qword[filaInicio],20
    jg      invalido

    mov     rdi,columnaInicioStr
    mov     rsi,formato
    mov     rdx,columnaInicio
    call    checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]

    cmp     rax,1
    jne     invalido

    cmp     qword[columnaInicio],1
    jl      invalido
    cmp     qword[columnaInicio],20
    jg      invalido

    mov     rdi,dimensionStr
    mov     rsi,formato
    mov     rdx,dimension
    call    checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]

    cmp     rax,1
    jne     invalido

    cmp     qword[dimension],1
    jl      invalido
    cmp     qword[dimension],20
    jg      invalido

    mov     byte[inputValido],'S'
invalido:
ret

obtenerDesplazamiento:
    mov     rbx,[filaInicio]
    dec     rbx
    imul    rbx,rbx,40 ;valor del desplazamiento por fila

    mov     [desplazamiento],rbx

    mov     rdx,[columnaInicio]
    dec     rdx
    imul    rdx,8  ;valor del desplazamiento por columna

    add     qword[desplazamiento],rdx
ret

sumarDiagonal:
    mov     rbx,[desplazamiento]
    mov     rcx,[dimension]

traza:
    mov     rax,[matrizPrueba + rbx]
    add     [sumatoria],rax

    add     rbx,[desplazamiento]
    loop    traza
ret

checkAlign:
	push rax
	push rbx
;	push rcx
	push rdx
	push rdi

	mov   qword[plusRsp],0
	mov		rdx,0

	mov		rax,rsp		
	add     rax,8		;para sumar lo q restó la CALL 
	add		rax,32	;para sumar lo que restaron las PUSH
	
	mov		rbx,16
	idiv	rbx			;rdx:rax / 16   resto queda en RDX

	cmp     rdx,0		;Resto = 0?
	je		finCheckAlign
;mov rdi,msj
;call puts
	mov   qword[plusRsp],8
finCheckAlign:
	pop rdi
	pop rdx
;	pop rcx
	pop rbx
	pop rax
	ret