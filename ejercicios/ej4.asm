global main
extern sscanf, printf, gets, puts

section     .data
    msjingreso      db  "Ingrese un nro %li: ",0
    msjdevolucion   db  "El numero ingresado es: %li",10,0
    formatonumero   db  "%li",0
    posicion        dq  3

section     .bss
    buffer      resb    10
    numero      resq    1
    vector      times   4 resq 1
    plusRsp		resq	1

section     .text
main:
    mov     rcx,3
circulo:
    mov     rbx,[posicion*8]
    add     rbx,vector
    mov     r8,rbx
    call    ingresoNumero
    mov     rcx,[posicion]
    mov     rbx,[posicion]
    dec     rbx
    mov     [posicion],rbx
    loop    circulo
    call    resultado
    ret

ingresoNumero:
    mov     rdi,msjingreso
    mov     rsi,r8
    sub     rax,rax
    call    printf
    mov     rdi,buffer
    call    gets

    mov     rdi,buffer
    mov     rsi,formatonumero
    mov     rdx,r8
    call    checkAlign
    sub     rsp,[plusRsp]
    call    sscanf
    add     rsp,[plusRsp]

    cmp     rax,1
    jl      ingresoNumero     
    ret

resultado:
    mov     rdi,msjdevolucion
    sub     rax,rax
    mov     rsi,[vector]
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