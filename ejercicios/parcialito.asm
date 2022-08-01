global 	main
extern 	printf
extern	gets
extern 	sscanf
extern	fopen
extern	fread
extern	fclose

section     .data
    ;Archivo binario
    fileName    db  "precios.dat",0
    fileModo    db  "rb",0
    msjError    db  "Error en la apertura del archivo",10,0

    ;Registro
    registro        times 0 db  ""
        piso        times 2 db  " "
        depto               db 0
        precio              dd 0

    pisoStr         db "**"
    pisoFormat      dw "%hi"
    pisoNumero      db  0
    desplazamiento  db  0

    matriz      dd  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


section     .bss
    filePointer     resq    1
    registroValido  resb    1
    plusRsp         resq    1

section     .text
main:
    call    abrirArchivo
    cmp     qword[filePointer],0
    jle     errorApertura

    call    leerArchivo
ret

abrirArchivo:
    mov     rdi,fileName
    mov     rsi,fileModo
    call    fopen

    mov     qword[filePointer],rax
ret

errorApertura:
    mov     rdi,msjError
    sub     rax,rax
    call    printf
ret

leerArchivo:
leerReg:
    mov     rdi,registro
    mov     rsi,7
    mov     rdx,1
    mov     rcx,qword[filePointer]
    call    fread

    cmp     rax,0
    jle     eof

    call    VALREG

    cmp     byte[registroValido],'S'
    jne     leerReg

    call    sumarDepto
    jmp     leerReg

eof:
    mov     rdi,[filePointer]
    call    fclose
ret

sumarDepto:
    mov     rbx,pisoNumero
    mov     rdx,depto
    call    obtenerDesplazamiento

    mov     rax,[desplazamiento]
    mov     dword[matriz + rax],precio
ret

obtenerDesplazamiento:
    dec     rbx
    imul    rbx,rbx,16 ;valor del desplazamiento por fila

    mov     [desplazamiento],rbx

    dec     rdx
    imul    rdx,4  ;valor del desplazamiento por columna

    add     qword[desplazamiento],rdx
ret


;===========VALIDACION================
VALREG:
    mov     byte[registroValido],'N'

    call    validarPiso
    cmp     byte[registroValido],'N'
    je      finalValidacion

    call    validarDepto
    cmp     byte[registroValido],'N'
    je      finalValidacion

finalValidacion:
ret

validarPiso:
    mov     byte[registroValido],'N'

    mov     rcx,2
    mov     rsi,piso
    mov     rdi,pisoStr
rep movsb

    mov     rdi,pisoStr
    mov     rsi,pisoFormat
    mov     rsi,pisoNumero
    call	checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]

    cmp     word[pisoNumero],1
    jl      novalido
    cmp     word[pisoNumero],12
    jg      novalido

    mov     byte[registroValido],'S'
novalido:
ret

validarDepto:
    mov     byte[registroValido],'N'
    cmp     byte[depto],1
    jl      deptoNovalido

    cmp     byte[depto],12
    jg      deptoNovalido

    mov     byte[registroValido],'S'
deptoNovalido:
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
