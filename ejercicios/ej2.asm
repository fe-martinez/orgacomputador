global main
extern puts,gets,printf

section     .data
    mensaje1 db     "Nombre: ",0
    mensaje2 db     "Apellido: ",0
    mensaje3 db     "Padron: ",0
    mensaje4 db     "Edad: ",0
    mensajefinal db "El alumno %s %s de Padrón N°%s tiene %s años",0
    nuevalinea db        "\n"

section     .bss
    nombre      resb 50
    apellido    resb 50
    padron      resb 50
    edad        resb 50

section     .text
main:
    call    preguntar
    call    responder
    ret

preguntar:
    mov     rdi, mensaje1
    call    puts
    mov     rdi,nombre
    call    gets
    mov     rdi, mensaje2
    call    puts
    mov     rdi,apellido
    call    gets
    mov     rdi, mensaje3
    call    puts
    mov     rdi,padron
    call    gets
    mov     rdi, mensaje4
    call    puts
    mov     rdi,edad
    call    gets
    ret

responder:
    mov     rdi,mensajefinal
    mov     rsi,nombre
    mov     rdx,apellido
    mov     rcx,padron
    mov     r8,edad
    xor     rax,rax
    call    printf
    mov     rdi,nuevalinea
    call    puts
    ret