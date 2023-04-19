; Ensamblador Motorola 6809

; Programa de ejemplo: hola.asm

        	.area PROG (ABS)

        	.org 0x100



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
menu:		.ascii "\n\n (1) Introducir las coordenadas iniciales.\n"
		.ascii " (2) Jugar.\n"
		.ascii " (S) Salir.\n\n"
		.byte   0       ; 0 es CTRL-@: fin de cadena



        	.globl programa
programa:
		ldx #menu
		jsr imprime_cadena ; Imprime el menú
		jsr consigue_caracter_char ; Consigue el caracter introducido y lo guarda en char
		lda char
		cmpa #49 ; Código ASCII de 1
		jsr coordenadas_iniciales ; Si se ha introducido 1, se introducen las coordenadas iniciales

		;; Acabar el programa
		clra
        	sta 0xFF01

        	.org 0xFFFE     ; Vector de RESET
        	.word programa

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
	cmpa #57
	bhi coordenadas_iniciales
	; Guardar el número en x1
	sta x1
	; Consigue el siguiente caracter
	jsr consigue_caracter_char
	; Comprobar que el caracter introducido es un número
	cmpa #48
	blo coordenadas_iniciales
	cmpa #57
	bhi coordenadas_iniciales
	; Guardar el número en y1
	sta y1
	; Consigue el siguiente caracter
	jsr consigue_caracter_char
	; Comprobar que el caracter introducido es un número
	cmpa #48
	blo coordenadas_iniciales
	cmpa #57
	bhi coordenadas_iniciales
	; Guardar el número en x2
	sta x2
	; Consigue el siguiente caracter
	jsr consigue_caracter_char
	; Comprobar que el caracter introducido es un número
	cmpa #48
	blo coordenadas_iniciales
	cmpa #57
	bhi coordenadas_iniciales
	; Guardar el número en y2
	sta y2
	; Mostrar en pantalla las coordenadas introducidas
	ldx #texto_coordenadas_introducidas
	jsr imprime_cadena
	ldx #x1
	jsr imprime_cadena
	ldx #y1
	jsr imprime_cadena
	ldx #x2
	jsr imprime_cadena
	ldx #y2
	jsr imprime_cadena
	puls x
	puls a
	rts



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

