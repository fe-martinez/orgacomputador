global 	main
extern 	printf
extern	gets
extern 	sscanf

section     .data
    msjIngreso          db "Ingrese el numero en configuracion hexadecimal seguido de la fila y la columna donde desea ubicarlo, cada uno de los valores separados por un espacio: ",0
    msjFinal            db "Concluyo el ingreso de datos",10,0
    formatoString       db  "%s %i %i",0
    MensajeSumatoria    db  "La sumatoria de la columna %li es %li",10,0
    imprimeMatriz       db  "%i --- ",0
    letraValida         db  "ABCDEF",0
    desplazamiento      dq  0
    sumatoriaActual     dq  0
    
    MAX_NUMERO          dq  32768

    matriz              dw  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    formatoPasajeEmpaq  db  "%hi",0

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
proximoIngreso:
    call    solicitarIngreso
    cmp     byte[ingresoUser],'*'
    je      finalIngreso
    call    VALING
    cmp     byte[inputValido],'N'
    je      proximoIngreso
    call    agregarNumero
    jmp     proximoIngreso

finalIngreso:
    call    finalLectura
    call    mostrarPromedios
ret


solicitarIngreso:
    mov     rdi,msjIngreso
    sub     rax,rax
    call    printf

    mov     rdi,ingresoUser
    call    gets

ret

finalLectura:
    mov     rdi,msjFinal
    sub     rax,rax
    call    printf
ret

agregarNumero:
    mov     rbx,qword[filaEmpaq]
    mov     rdx,qword[columnaEmpaq]
    call    obtenerDesplazamiento 
ubicar:
    mov     ax,word[empaqValorFinal]
    mov     rbx,[desplazamiento]
    mov     [matriz + rbx],ax
ret

obtenerDesplazamiento:
    sub     rbx,1
    imul    rbx,rbx,8 ;valor del desplazamiento por fila

    mov     qword[desplazamiento],rbx

    sub     rdx,1
    imul    rdx,2  ;valor del desplazamiento por columna

    add     qword[desplazamiento],rdx
ret

mostrarPromedios:
    mov     rcx,15  ;Itero de izquierda a derecha
loopExterno:
    mov     rbx,rcx
    dec     rbx
    imul    rbx,rbx,30 ;valor del desplazamiento por fila (15 lugares * 2bytes)
    mov     rdx,0   
    mov     qword[sumatoriaActual],0

loopInterno:
    mov     rax,rbx
    add     rax,rdx    ;Lugar a donde tengo que ir para obtener el numero actual.

    mov     r8,[matriz  + rax]  ;Valor de la casilla actual
    add     [sumatoriaActual],r8
    add     rdx,2
    cmp     rdx,30
    jle     loopInterno ;Mientras tenga filas para leer

    mov     rax,qword[sumatoriaActual]
    idiv    15 ;se almacena en rax

    mov     rcx,rsi
    push    rcx

    mov     rdi,MensajeSumatoria
    ;Ya esta guardado el numero de columnas en rsi.
    mov     rdx,rax
    sub     rax,rax
    call    printf

    pop     rcx
    loop    loopExterno
ret

;======================================
;           VALING
;======================================
VALING:
    mov		byte[inputValido],'N'

    mov     rdi,ingresoUser
    mov     rsi,formatoString
	mov		rdx,empaquetado
	mov		rcx,filaEmpaq
    mov     r8,columnaEmpaq
    call	checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]

    cmp     rax,3
    jne     ingresoInvalido

    call    validarFila
    cmp		byte[inputValido],'N'
    je      ingresoInvalido

    call    validarCol
    cmp		byte[inputValido],'N'
    je      ingresoInvalido

    call    validarEmpaq
    cmp		byte[inputValido],'N'
    je      ingresoInvalido

    mov     byte[inputValido],'S'
ingresoInvalido:
ret

;------------------- VALIDAR FILA -----------------------------
validarFila:
    mov		byte[inputValido],'N'

    cmp     byte[filaEmpaq],1
    jl      filaInvalida

    cmp     byte[filaEmpaq],15
    jg      filaInvalida

    mov		byte[inputValido],'S'
filaInvalida:
ret

;------------------- VALIDAR COLUMNA -----------------------------

validarCol:
    mov		byte[inputValido],'N'

    cmp     byte[columnaEmpaq],1
    jl      colInvalida

    cmp     byte[columnaEmpaq],15
    jg      colInvalida

    mov		byte[inputValido],'S'
colInvalida:
ret

;------------------- VALIDAR EMPAQUETADO -----------------------------

validarEmpaq:
    mov     byte[inputValido],'N'

	mov		rbx,0
proxDigito:
	cmp		byte[empaquetado+rbx],'0'
	jl		noEsDigito
	cmp		byte[empaquetado+rbx],'9'
	jg		noEsDigito
	inc		rbx
	jmp     proxDigito

    ;Tengo la cantidad de digitos en rbx

    mov     rdx,0
    mov     rcx,5
noEsDigito:
    mov     rax, byte[letraValida + rcx]
    cmp     byte[empaquetado+rbx],rax ;Miro el byte justo despues del ultimo numero
    je      hayLetraValida
    loop    noEsDigito

    mov     byte[inputValido],'N'
    ret

hayLetraValida:
    mov     rcx,rbx ;Cantidad de bytes que son digitos
    lea     rsi,[empaquetado]
    lea     rdi,[empaquetadoSinLetra]
rep movsb

    push    rax ;Tengo la letra del empaq

    mov     rdi,empaquetadoSinLetra
    mov     rsi,formatoPasajeEmpaq
    mov     rdx,empaquetadoSinSigno
    call	checkAlign
	sub		rsp,[plusRsp]
	call	sscanf
	add		rsp,[plusRsp]

    pop     rax ;Vuelve la letra del empaq

    cmp     rax,'B'
    je      valorNegativo
    cmp     rax,'D'
    je      valorNegativo

    mov     rbx,[empaquetadoSinSigno]
    cmp     rbx,qword[MAX_NUMERO]
    jg      noValido
    mov     word[empaqValorFinal],rbx
    jle     valido

    valorNegativo:
    mov     rbx,[empaquetadoSinSigno]
    cmp     rbx,qword[MAX_NUMERO]
    jg      noValido

    neg     rbx     
    mov     word[empaqValorFinal],rbx

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