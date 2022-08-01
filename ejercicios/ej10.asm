global  main
extern  printf
;es el ejercicio 11
section     .data
	dia			dw	'VI'
	validos		dw 	'LU', 'MA', 'MI', 'JU', 'VI', 'SA', 'DO'
	debug		db	'Posicion %s',10,0
	msjExito	db	'El dia ingresado es valido',10,0
	msjError	db	'El dia ingresado no es valido',10,0
section     .bss
    input           resb 16
    inputValido     resb 1

section     .text
main:

    call	validar
	cmp		byte[inputValido],'S'
	je		hayDia

	mov		rdi,msjError
	sub		rax,rax
	call	printf	

ret

hayDia:
	mov		rdi,msjExito
	sub		rax,rax
	call	printf
ret

validar:
	mov		rcx,7
	mov		rbx,0
chequear:
	mov		rdx,rcx
	mov		rcx,2
    lea		rsi,[dia]
	lea		rdi,[validos + rbx*2]
repe cmpsb
	je		coincidencia
	add		rbx,1
	mov		rcx,rdx
	loop	chequear

	mov		byte[inputValido],'N'
	ret

coincidencia:
	mov		byte[inputValido],'S'
ret
