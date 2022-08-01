; Dado un archivo en formato BINARIO que contiene informacion sobre autos llamado listado.dat
; donde cada REGISTRO del archivo representa informacion de un auto con los campos: 
;   marca:							10 caracteres
;   año de fabricacion:				4 caracteres
;   patente:						7 caracteres
;	precio							7 caracteres
; Se pide codificar un programa en assembler intel que lea cada registro del archivo listado y guarde
; en un nuevo archivo en formato binario llamado seleccionados.dat las patentes y el precio (en bpfc/s) de aquellos autos
; cuyo año de fabricación esté entre 2010 y 2020 inclusive
; Como los datos del archivo pueden ser incorrectos, se deberan validar mediante una rutina interna.
; Se deberá validar Marca (que sea Fiat, Ford, Chevrolet o Peugeot), año (que sea un valor
; numérico y que cumpla la condicion indicada del rango) y precio que sea un valor numerico.

global  main
extern  fopen
extern  fread
extern  printf
extern  sscanf

section     .data
    fileNameLista       db  "listado.dat",0
    modo                db  "rb",0
    mensajeErrorLis     db  "El archivo listado.dat no existe",10,0
    mensajeAperturaL    db  "Listado.dat fue correctamente abierto",10,0
    printString         db  "%s",10,0
    printNumero         db  "%hi",10,0
    punteroListado      dq  0

    fileNameSeleccion   db  "seleccion.dat",0
    modoSeleccion       db  "wb",0
    mensajeErrorSel     db  "El archivo seleccion.dat no existe",10,0
    mensajeAperturaS    db  "Seleccion.dat fue correctamente abierto",10,0
    punteroSeleccion    dq  0

    vectorMarcas        db  "Ford      Chevrolet Peugeot   Fiat      ",0

    anioStr             db  "****",0
    anioFormat          db  "%hi",0
    anioNumero          dw  0

    

    registroLista       times   0   db  ''
        marca           times   10  db  ' '
        anio            times   4   db  ' '
        patente         times   7   db  ' '
        precio          times   7   db  ' '

    registroSeleccion   times   0   db  ''
        patenteSel      times   7   db  ' '
        precioSel                   dd  0

section     .bss
    registroValido      resb 1
    datoValido          resb 1
    plusRsp		        resq 1

section     .text
main:
    mov     rdi,fileNameLista
    mov     rsi,modo
    call    fopen
    cmp     rax,0
    jle     errorAperturaLista
    mov     qword[punteroListado],rax

    mov     rdi,mensajeAperturaL
    sub     rax,rax
    call    printf

    mov     rdi,fileNameSeleccion
    mov     rsi,modoSeleccion
    call    fopen
    cmp     rax,0
    jle     errorAperturaSeleccion
    mov     qword[punteroSeleccion],rax
    
    mov     rdi,mensajeAperturaS
    sub     rax,rax
    call    printf

    mov     rbx,3
leyendo:
    mov     rdi,registroLista
    mov     rsi,28
    mov     rdx,1
    mov     rcx,[punteroListado]
    call    fread

    mov     rdi,printString
    mov     rsi,registroLista
    sub     rax,rax
    call    printf

    call    validarRegistro
    dec     rbx
    cmp     rbx,0
    jg      leyendo

ret

errorAperturaLista:
    mov     rdi,mensajeErrorLis
    sub     rax,rax
    call    printf
    ret

errorAperturaSeleccion:
    mov     rdi,mensajeErrorSel
    sub     rax,rax
    call    printf
    ret

;=====================VALIDACIONES================================

validarRegistro:
    mov     byte[registroValido],'N'
    call    validarAnio
    ret

validarAnio:
    mov     byte[registroValido],'S'

    mov     rcx,4
    mov     rsi,anio
    mov     rdi,anioStr
rep movsb

    mov     rdi,anioStr
    mov     rsi,anioFormat
    mov     rdx,anioNumero
    call	checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]

    mov     rdi,printNumero
    mov     rsi,[anioNumero]
    sub     rax,rax
    call    printf
    ret

validarMarca:
    mov     byte[registroValido],'S'
    mov     rbx,0
    mov     rcx,4

proxMarca:
    push    rcx
    mov     rcx,10  
    lea     rsi,[marca]
    lea     rdi,[vectorMarcas + rbx]
rep cmpsb
    pop     rcx
    je      coincidencia

    loop    proxMarca

    mov     byte[registroValido],'S'
coincidencia:
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