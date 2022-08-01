global  main
extern  printf
extern  sscanf
extern  gets

section     .data
    formato     db  "%li/%li/%li",0
    chequeo     db  "El dia es %li, el mes %li, el año %li",10,0
    msjError    db  "El dia ingresado no es valido",10,0
    msjExito    db  "El dia ingresado es valido",10,0
    msjPedido   db  "Ingrese una fecha en formato dd/mm/aaaa: ",0

section     .bss
    fecha           resb    25
    dia             resq    1
    mes             resq    1
    anio            resq    1
    inputValido     resb    1
    plusRsp		    resq	1

section     .text
main:
    call    pedirFecha
    call    separar
    call    chequeoSeparacion
    call    validar

    cmp     byte[inputValido],'N'
    je      imprimirMsjError

    mov     rdi,msjExito
    sub     rax,rax
    call    printf
ret

imprimirMsjError:
    mov     rdi,msjError
    sub     rax,rax
    call    printf
ret

pedirFecha:
    mov     rdi,msjPedido
    sub     rax,rax
    call    printf
    
    mov     rdi,fecha
    call    gets
ret

separar:
    mov     rdi,fecha
    mov     rsi,formato
    mov     rdx,dia
    mov     rcx,mes
    mov     r8,anio
    call	checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]
ret

chequeoSeparacion:
    mov     rdi,chequeo
    mov     rsi,[dia]
    mov     rdx,[mes]
    mov     rcx,[anio]
    sub     rax,rax
    call    printf
ret

validar:
    mov     byte[inputValido],'N'

    cmp     qword[dia],1
    jl      invalido
    cmp     qword[dia],31
    jg      invalido

    cmp     qword[mes],1
    jl      invalido
    cmp     qword[mes],12
    jg      invalido

    cmp     qword[anio],1
    jl      invalido
    cmp     qword[anio],9999
    jg      invalido

    mov     byte[inputValido],'S'
invalido:
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