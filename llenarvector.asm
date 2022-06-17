global  main
extern  printf
extern  sscanf
extern  gets

section     .data
    msjIngreso      db  "Ingrese un numero: ",0
    mensaje         db  "| %i |",0
    espacio         db  10,0
    formato         db  "%i"
    tamVector       dq  0
section     .bss
    ingresoUsr      resb  50
    numero          resq  1
    vector          times   8   resq    1
    plusRsp         resq    1
section     .text
main:
seguirIngreso:
    call    tomarIngreso
    cmp     byte[ingresoUsr],'*'
    je      terminarIngreso
    call    transformarIngreso
    call    llenarVector
    jmp     seguirIngreso
terminarIngreso:
    mov     rbx,0
    call    imprimirVector

ret

tomarIngreso:
    mov     rdi,msjIngreso
    sub     rax,rax
    call    printf

    mov     rdi,ingresoUsr
    call    gets
ret

transformarIngreso:
    mov     rdi,ingresoUsr
    mov     rsi,formato
    mov     rdx,numero
    call    checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]
ret

llenarVector:
    mov     rax,[numero]
    mov     rbx,[tamVector]
    imul    rbx,rbx,8
    mov     [vector + rbx],rax
    mov     rax,1
    add     qword[tamVector],rax
ret

imprimirVector:
    mov     rdi,mensaje
    mov     rsi,[vector+rbx*8]
    sub     rax,rax
    call    printf
    add     rbx,1
    cmp     rbx,qword[tamVector]
    jle     imprimirVector
    jg      finLoop

finLoop:
    mov     rdi,espacio
    sub     rax,rax
    call    printf


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