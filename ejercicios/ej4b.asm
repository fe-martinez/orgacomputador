global main
extern sscanf, printf, gets, puts

section     .data
    vector      dq  1,4,5,6,8,9,2,2
    imprimir    db  "El numero %i, ----> %i",10,0
    posicion    dq  5
section     .bss
    buffer      resb    10
    numero      resq    1
    plusRsp		resq	1

section     .text
main:
    mov     rcx,5
    call    circulo
    ret

circulo:
    mov     rdi,imprimir
    mov     rbx,[posicion]
    mov     rsi,[vector+rbx]
    mov     rdx,rcx
    sub     rax,rax
    call    printf
    mov     rbx,[posicion]
    dec     rbx
    mov     [posicion],rbx
    loop    circulo
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