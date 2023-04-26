; Ensamblador Motorola 6809

; Programa de ejemplo: hola.asm

        	.area PROG (ABS)

        	.org 0x100



; Variable booleana coordenadas
coordenadas:	.byte 0


; Texto coordenadas introducidas

texto_coordenadas_introducidas:	.ascii "\nLas coordenadas introducidas son: \n"
				.byte 0


; Texto coordenadas iniciales
texto_coordenadas_iniciales:	.ascii "\nIntroduzca las coordenadas iniciales de los jugadores.\n"
				.ascii "Las coordenadas son de 0 a 7, siendo 0 la esquina superior izquierda.\n"
				.ascii "Debes introducir las dos coordenadas de cada jugador en el mismo texto.\n"
				.ascii "Por ejemplo: '0 0 7 7¡, pero sin espacios entre medias '0077'\n"
				.ascii "Introduzca las coordenadas: \n"
				.byte   0       ; 0 es CTRL-@: fin de cadena

; Variable char
char:		.byte 0

;; Variables de coordenadas las coordenadas son de 0 a 7, siendo 0 la esquina superior izquierda

; Jugador 1
x1:		.byte 0
y1:		.byte 0
; Jugador 2
x2:		.byte 0
y2:		.byte 0
cero:		.byte 0

; Saltos

saltos:		.ascii "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
		.byte 0

; Tablero de ajedrez
tablero:	.ascii "\n --- --- --- --- --- --- --- --- \n"
		.ascii "|   |   |   |   |   |   |   |   |\n"
		.ascii " --- --- --- --- --- --- --- --- \n"
		.ascii "|   |   |   |   |   |   |   |   |\n"
		.ascii " --- --- --- --- --- --- --- --- \n"
		.ascii "|   |   |   |   |   |   |   |   |\n"
		.ascii " --- --- --- --- --- --- --- --- \n"
		.ascii "|   |   |   |   |   |   |   |   |\n"
		.ascii " --- --- --- --- --- --- --- --- \n"
		.ascii "|   |   |   |   |   |   |   |   |\n"
		.ascii " --- --- --- --- --- --- --- --- \n"
		.ascii "|   |   |   |   |   |   |   |   |\n"
		.ascii " --- --- --- --- --- --- --- --- \n"
		.ascii "|   |   |   |   |   |   |   |   |\n"
		.ascii " --- --- --- --- --- --- --- --- \n"
		.ascii "|   |   |   |   |   |   |   |   |\n"
		.ascii " --- --- --- --- --- --- --- --- \n"
        	.byte   0       ; 0 es CTRL-@: fin de cadena
; Menú de opciones
;	(1) Introducir las coordenadas iniciales.
;	(2) Jugar.
;	(S) Salir.

menu:		.ascii "\n\n (1) Introducir las coordenadas iniciales."
menu2:		.ascii "\n (2) Jugar.\n"
		.ascii " (S) Salir.\n\n"
		.byte   0       ; 0 es CTRL-@: fin de cadena



        	.globl programa
programa:	
		ldx #saltos
		jsr imprime_cadena ; Imprime Saltos
		jsr elige_menu ; Elige el menú a imprimir
		jsr imprime_cadena ; Imprime el menú
		jsr consigue_caracter_char ; Consigue el caracter introducido y lo guarda en char
		jmp comprueba_menu
		jmp programa
salida:		;; Acabar el programa
		clra
	   	sta 0xFF01

        	.org 0xFFFE     ; Vector de RESET
        	.word programa

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; elige_menu                                                       ;
;     guarda en X menu o menu2 segun el que haya que imprimir      ;
;                                                                  ;
;   Entrada: coordenadas			                   ;
;   Salida:  X                                                     ;
;   Registros afectados: X.                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

elige_menu:
		lda coordenadas
		cmpa #1
		beq es_uno
		cmpa #0
		beq es_cero
es_uno:		ldx #menu2
		jmp fin
es_cero:	ldx #menu
fin:		rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; imprime_cadena                                                   ;
;     saca por la pantalla la cadena acabada en '\0 apuntada por X ;
;                                                                  ;
;   Entrada: X-direcciOn de comienzo de la cadena                  ;
;   Salida:  ninguna                                               ;
;   Registros afectados: X, CC.                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
imprime_cadena:
        pshs a
sgte:   lda ,x+
        beq ret_imprime_cadena
        sta 0xFF00
        bra sgte
ret_imprime_cadena:
        puls a
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; coordenadas_iniciales                                            ;
;     lleva a la rutina de la opciOn elegida			   ;
;                                                                  ;
;   Entrada: X-direcciOn de comienzo de la cadena                  ;
;   Salida:  ninguna                                               ;
;   Registros afectados: X, CC.                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
coordenadas_iniciales:
		pshs a
		pshs x
		ldx #texto_coordenadas_iniciales
		jsr imprime_cadena ; Imprime el texto de las coordenadas iniciales

		jsr consigue_caracter_char ; Consigue el caracter introducido y lo guarda en char
		lda char
		; Comprobar que el caracter introducido es un número
		cmpa #48
		blo coordenadas_iniciales
		cmpa #55
		bhi coordenadas_iniciales
		; Guardar el número en x1
		sta x1


		; Consigue el siguiente caracter
		jsr consigue_caracter_char
		lda char
		; Comprobar que el caracter introducido es un número
		cmpa #48
		blo coordenadas_iniciales
		cmpa #55
		bhi coordenadas_iniciales
		; Guardar el número en y1
		sta y1


		; Consigue el siguiente caracter
coord2:		jsr consigue_caracter_char
		lda char
		; Comprobar que el caracter introducido es un número
		cmpa #48
		blo coordenadas_iniciales
		cmpa #55
		bhi coordenadas_iniciales
		cmpa x1
		beq coord2
		; Guardar el número en x2
		sta x2


		; Consigue el siguiente caracter
		jsr consigue_caracter_char
		lda char
		; Comprobar que el caracter introducido es un número
		cmpa #48
		blo coordenadas_iniciales
		cmpa #55
		bhi coordenadas_iniciales
		cmpa y1
		beq coord2
		; Guardar el número en y2
		sta y2


		; Mostrar en pantalla las coordenadas introducidas
		ldx #texto_coordenadas_introducidas
		jsr imprime_cadena
		ldx #x1
		jsr imprime_cadena
		lda #1
		sta coordenadas
		puls x
		puls a
		jmp volver_de_salto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; comprueba_menu                                                   ;
;     lleva a la rutina de la opciOn elegida			   ;
;                                                                  ;
;   Entrada: X-direcciOn de comienzo de la cadena                  ;
;   Salida:  ninguna                                               ;
;   Registros afectados: X, CC.                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba_menu:
        pshs a
	lda coordenadas ; Comprobación de si se han introducido las coordenadas
	cmpa #1
	beq true
	lda char
	cmpa #49 ; Compara a con el código ASCII de 1
	beq coordenadas_iniciales
true:	lda char
	cmpa #50 ; Compara a con el código ASCII de 2
	beq jugar
	cmpa #83 ; Compara a con el código ASCII de S
	beq salir
	puls a
volver_de_salto:
	jmp programa


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; salir				   	                           ;                                            ;
;     lleva a la direccion de memoria de salida			   ;
;                                                                  ;
;   Entrada: nada				                   ;
;   Salida:  ninguna                                               ;
;   Registros afectados: nada .                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
salir:
	jmp salida

jugar:
	ldx #tablero
	jsr imprime_cadena ; Imprime el tablero
	jsr consigue_caracter_char
	jmp volver_de_salto




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; consigue_caracter_char                                           ;
;     guarda en la variable char el caracter introducido por el    ;
;     teclado.                                                     ;
;                                                                  ;
;   Entrada: ninguna                                               ;
;   Salida:  char                                                  ;
;   Registros afectados: X, CC.                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

consigue_caracter_char:
	pshs a
	lda 0xFF02
	sta char
	puls a
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; coordenadas_iniciales				  	           ;
;     guarda en las variables x1, y1, x2, y2 las coordenadas       ;
;     introducidas por el teclado.                                 ;
;     Mostrar en pantalla un texto que indique que se deben        ;
;     introducir las coordenadas y como introducirlas.             ;
;                                                                  ;
;   Entrada: ninguna                                               ;
;   Salida:  x1, y1, x2, y2                                        ;
;   Registros afectados: X, CC.                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

