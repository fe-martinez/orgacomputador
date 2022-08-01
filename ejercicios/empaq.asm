global 	main
extern 	printf
extern	gets
extern 	sscanf

section     .data
    msjIngreso  db  "EMPAQ: ",0
    empaqStr    db  "2233D",0
    imprimirStr db  "%s",10,0
    formatoString   db  "%s",0
    letraValida         db  "ABCDEF",0
    formatoPasajeEmpaq  db  "%hi",0
    imprimirEmpaq       db  "%li",10,0
    MAX_NUMERO          dq  32768

section     .bss
    ingresoUser         resb    50
    empaquetado         resw    1
    empaquetadoSinLetra resw    1
    empaquetadoSinSigno resw    1
    empaqValorFinal     resw    1
    letraEmpaq          resb    1
    filaEmpaq           resq    1
    columnaEmpaq        resq    1
    plusRsp             resq    1
    inputValido         resb    1 

section     .text
main:
    call    validarEmpaq

    mov     rdi,imprimirEmpaq
    mov     rsi,empaqValorFinal
    sub     rax,rax
    call    printf

    mov     rdi,formatoString
    mov     rsi,empaqValorFinal
    sub     rax,rax
    call    printf

ret


; VALING:
;     mov		byte[inputValido],'N'

;     mov     rdi,empaqStr
;     mov     rsi,formatoString
; 	mov		rdx,empaquetado
;     call	checkAlign
; 	sub		rsp,[plusRsp]
; 	call	sscanf
; 	add		rsp,[plusRsp]


validarEmpaq:
    mov     byte[inputValido],'N'
	mov		rbx,0
proxDigito:
	cmp		byte[empaqStr+rbx],'0'
	jl		noEsDigito
	cmp		byte[empaqStr+rbx],'9'
	jg		noEsDigito
	inc		rbx
	jmp     proxDigito

    ;Tengo la cantidad de digitos en rbx

    mov     rdx,0
    mov     rcx,5

noEsDigito:
;     mov     rax, byte[letraValida + rcx]
;     cmp     byte[empaquetado+rbx],rax ;Miro el byte justo despues del ultimo numero
;     je      hayLetraValida
;     loop    noEsDigito

;     mov     byte[inputValido],'N'
;     ret

hayLetraValida:
    mov     rcx,rbx ;Cantidad de bytes que son digitos
    lea     rsi,[empaqStr]
    mov     rdi,empaquetadoSinLetra
rep movsb

    ; push    rax ;Tengo la letra del empaq

    mov     rdi,empaquetadoSinLetra
    mov     rsi,formatoPasajeEmpaq
    mov     rdx,empaquetadoSinSigno
    call	checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]

    ; pop     rax ;Vuelve la letra del empaq

    ; cmp     rax,'B'
    ; je      valorNegativo
    ; cmp     rax,'D'
    ; je      valorNegativo

    mov     rbx,[empaquetadoSinSigno]
    cmp     rbx,qword[MAX_NUMERO]
    jg      noValido
    mov     [empaqValorFinal],rbx
    jle     valido

    valorNegativo:
    mov     rbx,[empaquetadoSinSigno]
    cmp     rbx,qword[MAX_NUMERO]
    jg      noValido

    neg     rbx     
    mov     [empaqValorFinal],rbx

valido:
	mov     byte[inputValido],'S'
noValido:
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