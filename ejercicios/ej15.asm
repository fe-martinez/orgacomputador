global  main
extern  fgets
extern  fopen
extern  printf
extern  sscanf

section     .data
    nombreArchivo       db  "numeritos.txt",0
    modo                db  "r",0
    mensajePrueba       db  "El numero es %s",10,0
    mensajeNumero       db  "El numero es %li",10,0
    mensajeSumatoria    db "La sumatoria es %li",10,0
    formato             db  "%li"
    largo               dq  8
    sumatoria           dq  0

section     .bss
    idArchivo       resq    1
    registro        resb    12
    vector          times   5   resq    1
    plusRsp		    resq	1
    numerovich      resq    1
    stringovich     resq    1

section     .text
main:
    mov     rbx,0
    mov     rdi,nombreArchivo
    mov     rsi,modo
    call    fopen

    mov     qword[idArchivo],rax
leerNumeros:
    mov     rdi,registro
    mov     rsi,8
    mov     rdx,[idArchivo]
    call    fgets
    mov     [stringovich],rax

    mov     rdi,[stringovich]
    mov     rsi,formato
    mov     rdx,numerovich
    call	checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]

    mov     rcx,[numerovich]
    mov     [vector + rbx*8],rcx
    add     rbx,1
    cmp     rbx,5
    jl      leerNumeros
    
    mov     rbx,0
imprimiendo:
    mov     rdi,mensajeNumero
    mov     rsi,[vector + rbx*8]
    sub     rax,rax
    call    printf
    add     rbx,1
    cmp     rbx,5
    jl      imprimiendo

    mov     rax,0
    mov     rbx,0
sumando:
    add     rax,[vector + rbx*8]
    inc     rbx
    cmp     rbx,5
    jl      sumando

    mov     [sumatoria],rax
    mov     rdi,mensajeSumatoria
    mov     rsi,[sumatoria]
    sub     rax,rax
    call    printf

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