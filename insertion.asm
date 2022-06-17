;*************************************************************************
;				~	 I N S E R T I O N   S O R T		~
;*************************************************************************


global		main
extern		printf
extern		fopen
extern		fwrite
extern		fread
extern		fclose
extern 		gets


;*************************************************************************
;							SECTION .DATA
;*************************************************************************

section		.data

	msgInputFile 			db 	10,"Ingrese nombre de archivo: ",0	
	mode					db	"rb",0
	fileHandle				dd	0
	msgErrOpen				db  10,"Error en apertura de archivo",10,0,
	
	msgLine					db  " %d ",0
	
	msgLenLine				db  10,"len vector: %d",10,0
	lenVector				dd	0

	lenRegister				dd	33

	msgOrderMode 			db 	10,"Ingrese modo ordenamiento: Descendente [D] o Ascendente [A]: ",0
	modeOrder 				db 	" ",0
	letterA 				db 	"A",0
	letterB 				db  "D",0


	msgColocarVector	 	db 10,"Se coloca los siguientes numeros en un vector: ",10,0
	msgAveriguarLen 		db 10,10,"Se obtiene longitud del vector n: %d",10,0
	msgInsercionTitulo 		db 10, "**************************************************************************************",10,"               ~	 I N S E R T I O N   S O R T	 ~               ",10,"**************************************************************************************",10,10,0
	msgSeEntraEnCiclo_i 	db "	Iniciando el ciclo i menor a n=%d.",10,0
	msgSeEntraEnCiclo_j 	db "		Iniciando el ciclo j menor al i=%d.",10,0
	msgEnCiclo_j 		 	db "			 Si j=%d menor al i=%d.",10,0
	msgComparacion 			db "					Se comparan los numeron %d y %d.",10,0
	msgSwap 				db "							Numeros desordenados",10,"								swap de posiciones.",10,0
	msgContinue				db "							Numeros ordenados continuo.",10,0
	msgEndInsertionSort 	db 10, "**************************************************************************************",10,"				FIN INSERTION SORT 	 				",10, "**************************************************************************************",10, 10,"RESULTADO: ",10,0
	msgSaltoDeLinea 		db 10,10,0
	msgArchivoVacio 		db "Archivo vacio",10,0


	


;*************************************************************************
;							SECTION .BSS
;*************************************************************************
	
section		.bss

	fileName				resb 	30

	registro 				resd	1

	posVector 				resd	1
	vector		times	30	resd	1

	num1	 				resd	1
	num2	 				resd	1
	aux	 					resd	1


;*************************************************************************
;							SECTION .TEXT
;*************************************************************************

section		.text

;_________________________________main_____________________________________

main:

	call   	inputData
	
	mov 	dword[posVector], 1
	call 	readBinaryFile



	call 	printInitialization

	call 	insertionSort
		
	ret	

;_________________________________inputData__________________________________


inputData:

	call inputFileName
	call inputOrderMode
	ret

inputFileName:

	push msgInputFile
	call printf
	add esp, 4

	push fileName
	call gets
	add esp, 4
	
	ret
	
inputOrderMode:

	push msgOrderMode
	call printf
	add esp, 4

	push modeOrder
	call gets
	add esp, 4

	mov ah, byte[modeOrder]
	cmp ah, byte[letterA]
	je 	endInputOrderMode

	mov ah, byte[modeOrder]
	cmp ah, byte[letterB]
	jne inputOrderMode

endInputOrderMode:
	ret

;_____________________________readBinaryFile_______________________________

readBinaryFile:

	push	mode			
	push	fileName		
	call	fopen		
	mov		[fileHandle],eax
	add		esp,8

	cmp		eax,0

	jle		errorOpen
	mov		[fileHandle],eax

readLine:

	push	dword[fileHandle]
	push	1
	push	4
	push	registro
	call	fread
	add		esp,16

	cmp		eax,0	
	jle		eof

	call 	fillVector

	inc   	dword[lenVector]

	jmp		readLine


fillVector:

	mov		eax,dword[posVector]				
	dec		eax						
	imul	dword[lenRegister]		
	lea		eax,[vector+eax]		

	mov 	edx, dword[registro]
	mov 	dword[eax], edx

	inc		dword[posVector]

	ret

eof:

	push	dword[fileHandle]
	call	fclose
	add		esp,4

	ret

	
errorOpen:

	push	msgErrOpen
	call	printf
	add		esp,4

	call 	inputData
	jmp 	readBinaryFile
	
endReadBinaryFile:

	ret

;___________________________insertionSort___________________________________




insertionSort:

	cmp 	dword[lenVector], 0
	je 		printfArchivoVacio

	call 	printInsercionTitulo

	cmp 	dword[lenVector], 1
	je 		endInsertionSort

	call 	printEntrarCiclo_i

	mov 	dword[posVector], 1
	mov 	esi, 1

iterar_i:
	

	cmp 	esi, dword[lenVector]
	jge 	endInsertionSort

	mov 	edi, esi
	push 	esi

	call 	printEntrarCiclo_j
	
	iterar_j:

		call 	printEnCiclo_j

	buscoNum1:

		mov		eax, dword[posVector]
		add 	eax, esi
		dec		eax
		imul	dword[lenRegister]		
		lea		eax,[vector+eax]

		mov 	edx, dword[eax]
		mov 	dword[num2], edx


	buscoNum2:

		mov		eax,dword[posVector]
		add 	eax, esi
		dec		eax
		dec		eax
		imul	dword[lenRegister]	
		lea		eax,[vector+eax]

		mov 	edx, dword[eax]
		mov 	dword[num1], edx

	isOrderCorrect:

		call 	printComparar

		mov 	ah, byte[modeOrder]
		cmp 	ah, byte[letterA]

		mov 	eax, dword[num1]
		mov 	ebx, dword[num2]

		je 		isOrderAscendent
		jmp 	isOrderDescendent
	
	isOrderAscendent:

		cmp 	eax, ebx
		jmp 	swapOrder

	isOrderDescendent:

		cmp 	ebx, eax

	swapOrder:

		jle 	continue

		call 	pritnSwap
		call  	swap


	continue:

		call 	printContinue

		dec		esi
		cmp 	esi, 0
		jg		iterar_j

		pop 	esi
		inc 	esi
		jmp 	iterar_i	

endInsertionSort:

	call 	printEndInsertionSort

	ret


swap:

; guardo en aux
	mov 	eax, dword[num2]
	mov 	dword[aux], eax

; busco num2

	mov		eax,dword[posVector]
	add 	eax, esi
	dec		eax		
	imul	dword[lenRegister]		
	lea		eax,[vector+eax]

	mov 	edx, dword[num1]
	mov 	dword[eax], edx

; busco num1

	mov		eax,dword[posVector]
	add 	eax, esi
	dec		eax
	dec		eax				
	imul	dword[lenRegister]		
	lea		eax,[vector+eax]

	mov 	edx, dword[aux]
	mov 	dword[eax], edx

	ret


;___________________________printMessages___________________________________

printVector:

	mov		eax,dword[posVector]	
	dec		eax						
	imul	dword[lenRegister]		
	lea		eax,[vector+eax]		

	push 	dword[eax]
	push 	msgLine
	call 	printf
	add 	esp, 8

	inc		dword[posVector]
	mov     eax, dword[lenVector]
	cmp		dword[posVector],eax
	jle		printVector			

	ret

printInitialization:

	push 	msgColocarVector
	call 	printf
	add 	esp, 4

	mov 	dword[posVector], 1
	call 	printVector 

	push 	dword[lenVector]
	push 	msgAveriguarLen
	call 	printf
	add 	esp, 8

	ret

printInsercionTitulo:

	push 	msgInsercionTitulo
	call 	printf
	add 	esp, 4

	ret

printEntrarCiclo_i:

	push 		esi
	push 		dword[lenVector]
	push 		msgSeEntraEnCiclo_i
	call 		printf
	add 		esp, 12

	ret

printEntrarCiclo_j:
	
	push 		esi
	push 		edi
	push 		msgSeEntraEnCiclo_j
	call 		printf
	add 		esp, 12

	ret

printEnCiclo_j:
	
	push 		edi
	push 		esi
	push 		msgEnCiclo_j
	call 		printf
	add 		esp, 12

	ret

printComparar:

	push 		dword[num2]
	push 		dword[num1]
	push 		msgComparacion
	call 		printf
	add 		esp, 12

	ret
	
pritnSwap:

	push 		msgSwap
	call 		printf
	add 		esp, 4

	ret

printContinue:

	push 		msgContinue
	call 		printf
	add 		esp, 4

	ret

printEndInsertionSort:
	
	push 		msgEndInsertionSort
	call 		printf
	add 		esp, 4

	mov 		dword[posVector], 1
	call 		printVector

	push 		msgSaltoDeLinea
	call 		printf
	add 		esp, 4


	ret

printfArchivoVacio:

	push 		msgArchivoVacio
	call 		printf
	add 		esp, 4
	
	ret
