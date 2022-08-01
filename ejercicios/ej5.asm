global main
extern sscanf, printf, gets, puts

section     .data
    vector      dq  1,4,25,6,18,9,0,2
    imprimir    db  "El maximo es %li, el minimo es %li y el promedio es %li",10,0
    imprimir2   db  "%i",10,0
    posicion    dq  7
    cantidad    dq  8
    
section     .bss
    maxActual   resq 1
    minActual   resq 1
    sumatoria   resq 1

section     .text
main:
    mov     rbx,[posicion]
    mov     rax,[vector+rbx*8]
    mov     [maxActual],rax
    mov     [minActual],rax

    mov     qword[sumatoria],0
    call    verNumero
    call    resultado
    ret

verNumero:
    mov     rbx,[posicion]
    mov     rax,[vector+rbx*8]

maximo:
    mov     rdx,[maxActual]
    cmp     rax,rdx
    jl      minimo
    call    esMaximo
minimo:
    mov     rdx,[minActual]
    cmp     rax,rdx
    jg      suma
    call    esMinimo
suma:
    add     [sumatoria],rax

    mov     rbx,[posicion]
    dec     rbx
    mov     [posicion],rbx
    mov     rcx,rbx
    loop    verNumero
    ret

esMaximo:
    mov     [maxActual],rax
    ret

esMinimo:
    mov     [minActual],rax
    ret

resultado:
    mov     rdi,imprimir
    mov     rsi,[maxActual]
    mov     rdx,[minActual]
    mov     rax,[sumatoria]
    div     qword[cantidad]
    mov     rcx,rax
    sub     rax,rax
    call    printf
    ret

; checkAlign:
; 	push rax
; 	push rbx
; ;	push rcx
; 	push rdx
; 	push rdi

; 	mov   qword[plusRsp],0
; 	mov		rdx,0

; 	mov		rax,rsp		
; 	add     rax,8		;para sumar lo q restó la CALL 
; 	add		rax,32	;para sumar lo que restaron las PUSH
	
; 	mov		rbx,16
; 	idiv	rbx			;rdx:rax / 16   resto queda en RDX

; 	cmp     rdx,0		;Resto = 0?
; 	je		finCheckAlign
; ;mov rdi,msj
; ;call puts
; 	mov   qword[plusRsp],8
; finCheckAlign:
; 	pop rdi
; 	pop rdx
; ;	pop rcx
; 	pop rbx
; 	pop rax
; 	ret