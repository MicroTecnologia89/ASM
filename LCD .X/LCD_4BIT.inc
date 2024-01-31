    CBLOCK
    LCD_DATO
    LCD_GuardaDato
    LCD_Auxiliar1
    LCD_Auxiliar2
    AUX_UNIDADES		; 	
    AUX_DECENAS			; 
    AUX_CENTENAS		;
    AUXILIAR 
    ENDC

CHAR_X_LINEA	EQU	.20		; Número de caracteres por línea de la pantalla.

#DEFINE  RS		LATC,2		; PIN DE CONTROL LCD
#DEFINE  RE		LATC,3		; PIN DE CONTROL LCD
#DEFINE  LCD_BUS	LATC		; BUS DE DATOS 4 BITS ALTOS

	
;***************************************************************************************************
;**************** RUTINAS ESPECIALES PARA CONVERSIÓN BINARIO A TRES DIGITOS ************************
;***************************************************************************************************	
CONVERSION_BIN
	MOVWF 	AUXILIAR		; MOVEMOS EL VALOR QUE VIENE EN W AL REGISTRO AUXILIAR
	CLRF	AUX_UNIDADES		; LIMPIAMOS NUESTROS AUXILIARES	
	CLRF	AUX_DECENAS		; LIMPIAMOS NUESTROS AUXILIARES
	CLRF	AUX_CENTENAS		; LIMPIAMOS NUESTROS AUXILIARES
BS_CENTENAS
	MOVLW 	.100			; CARGAMOS UN 100 A W
	SUBWF 	AUXILIAR,W		; LE RESTAMOS A NUESTRO VALOR PRINCIPAL 
	BTFSC 	STATUS,C		; PREGUNTAMOS SI ES MAYOR O MENOR
	GOTO 	BSUMA_CENTENAS		; SI NO ES MENOR PROCEDEMOS A SUMAR CENTENAS
	GOTO 	BS_DECENAS		; SI ES MENOR VAMOS A SUMAR DECENAS
BSUMA_CENTENAS
	MOVWF 	AUXILIAR		; EL RESULTADO LO ACTUALIZAMOS EN W
	INCF 	AUX_CENTENAS,F		; INCREMENTAMOS EL REGISTRO DE CENTENAS EN 1
	GOTO 	BS_CENTENAS		; REGRESAMOS A LA ETIQUETA S_CENTENAS
BS_DECENAS
	MOVLW 	.10			; CARGAMOS EL VALOR 10 A W
	SUBWF 	AUXILIAR,W		; PARA RESTARLO A NUESTRO VALOR PRINCIPAL
	BTFSC 	STATUS,C		; PREGUNTAMOS SI ES MAYOR O MENOR
	GOTO 	BSUMA_DECENAS		; SI FUE MAYOR EL NUMERO VAMOS A SUMAR DECENAS
	GOTO 	BSUMA_UNIDADES		; SI ES MENOR VAMOS A SUMAR UNIDADES
BSUMA_DECENAS
	MOVWF 	AUXILIAR		; AUCTUALIZAMOS LA VARIABLE AUXILIAR
	INCF 	AUX_DECENAS,1		; INCREMENTAMOS EN 1 AL REGISTRO DECENAS
	GOTO 	BS_DECENAS		; REGRESAMOS A ETIQUETA DE S_DECENAS
BSUMA_UNIDADES	
	MOVF 	AUXILIAR,W		; EN UNIDADES EL RESIDUO DE LAS OPERACIONES ES CARGADO A AUX_UNIDADES
	MOVWF 	AUX_UNIDADES		; AUN SI ES CERO
	RETURN				; QUEDO LISTA LA CONVERSION DE BINARIO A BCD REGRESO CON VALORES EN REGISTROS AUXILIARES	
;***************************************************************************************************
;******************* RUTINAS ESPECIALES PARA CONVERSIÓN BINARIO A BCD ******************************
;***************************************************************************************************
CONVERSION_BCD
	MOVWF 	AUXILIAR			; MOVEMOS EL VALOR QUE VIENE EN W AL REGISTRO AUXILIAR
	CLRF	AUX_UNIDADES		; LIMPIAMOS NUESTROS AUXILIARES	
	CLRF	AUX_DECENAS			; LIMPIAMOS NUESTROS AUXILIARES
	CLRF	AUX_CENTENAS		; LIMPIAMOS NUESTROS AUXILIARES
S_CENTENAS
	MOVLW 	.100				; CARGAMOS UN 100 A W
	SUBWF 	AUXILIAR,W			; LE RESTAMOS A NUESTRO VALOR PRINCIPAL 
	BTFSC 	STATUS,C			; PREGUNTAMOS SI ES MAYOR O MENOR
	GOTO 	SUMA_CENTENAS		; SI NO ES MENOR PROCEDEMOS A SUMAR CENTENAS
	GOTO 	S_DECENAS			; SI ES MENOR VAMOS A SUMAR DECENAS
SUMA_CENTENAS
	MOVWF 	AUXILIAR			; EL RESULTADO LO ACTUALIZAMOS EN W
	INCF 	AUX_CENTENAS,F		; INCREMENTAMOS EL REGISTRO DE CENTENAS EN 1
	GOTO 	S_CENTENAS			; REGRESAMOS A LA ETIQUETA S_CENTENAS
S_DECENAS
	MOVLW 	.10					; CARGAMOS EL VALOR 10 A W
	SUBWF 	AUXILIAR,W			; PARA RESTARLO A NUESTRO VALOR PRINCIPAL
	BTFSC 	STATUS,C			; PREGUNTAMOS SI ES MAYOR O MENOR
	GOTO 	SUMA_DECENAS		; SI FUE MAYOR EL NUMERO VAMOS A SUMAR DECENAS
	GOTO 	SUMA_UNIDADES		; SI ES MENOR VAMOS A SUMAR UNIDADES
SUMA_DECENAS
	MOVWF 	AUXILIAR			; AUCTUALIZAMOS LA VARIABLE AUXILIAR
	INCF 	AUX_DECENAS,1		; INCREMENTAMOS EN 1 AL REGISTRO DECENAS
	GOTO 	S_DECENAS			; REGRESAMOS A ETIQUETA DE S_DECENAS
SUMA_UNIDADES	
	MOVF 	AUXILIAR,W		; EN UNIDADES EL RESIDUO DE LAS OPERACIONES ES CARGADO A AUX_UNIDADES
	MOVWF 	AUX_UNIDADES		; AUN SI ES CERO
	MOVLW	B'00110000'		; CARGAMOS EL VALOR PARA PODER VISUALIZARLO EN ASCCI
	ADDWF	AUX_UNIDADES,F		; SE LO SUMO A UNIDADES
	ADDWF	AUX_DECENAS,F		; SE LO SUMO A CENTENAS 
	ADDWF   AUX_CENTENAS,F		; SE LO SUMO A DECENAS
	RETURN						; QUEDO LISTA LA CONVERSION DE BINARIO A BCD REGRESO CON VALORES EN REGISTROS AUXILIARES
INI_LCD
    BCF		RE			; DESHABILITAMOS PIN 
    BCF		RS			; ACTIVAMOS MODO COMANDO PONIENDO RS EN 0
    CALL	RET_10ms		; RETARDO PARA ESTABILIZACIÓN LCD
    MOVLW	B'00110000'		;
    CALL	LCD_WRITE		; ESCRIBIMOS DATO EN LCD
    CALL	RET_5ms
    CALL	RET_1ms	
    MOVLW	B'00110000'	
    CALL	LCD_WRITE
    CALL	RET_100us
    MOVLW	B'00110000'	
    CALL	LCD_WRITE
    CALL	RET_100us		; Este retardo es necesario para simular en PROTEUS.
    MOVLW	B'00100000'		; Interface de 4 bits.
    CALL	LCD_WRITE
    CALL	RET_100us		; Este retardo es necesario para simular en PROTEUS.
    CALL	LCD_2Lineas4Bits5x7	; LCD de 2 líneas y caracteres de 5x7 puntos.
    CALL	LCD_CLEAR		; Pantalla encendida y limpia. Cursor al principio
    CALL	LCD_C_OFF		; de la línea 1. Cursor apagado.
    CALL	LCD_CursorIncr		; Cursor en modo incrementar.
    RETURN
LCD_WRITE
    ANDLW	B'11110000'		; Se queda con el nibble alto del dato que es el
    MOVWF	LCD_DATO		; que hay que enviar y lo guarda.
    MOVF	LCD_BUS,W		; Lee la información actual de la parte baja
    ANDLW	B'00001111'		; del Puerto B, que no se debe alterar.
    IORWF	LCD_DATO,F		; Enviará la parte alta del dato de entrada
    MOVF	LCD_DATO,W		; Recupera el dato a enviar.
    MOVWF	LCD_BUS			; Envía el dato al módulo LCD.
    BSF		RE			; Permite funcionamiento del LCD mediante un pequeño
    BCF		RE			; pulso y termina impidiendo el funcionamiento del LC
    RETURN
LCD_CursorIncr				; Cursor en modo incrementar.
    MOVLW	B'00000110'
    BRA		LCD_CMD
LCD_CTMP
    MOVLW	B'11001000'
    BRA		LCD_CMD
LCD_L1MENU
    MOVLW	B'10000001'		;POSICION MENU 1
    BRA		LCD_CMD
LCD_L2MENU
    MOVLW	B'11000001'		;POSICION MENU 1
    BRA		LCD_CMD
LCD_L1							; Cursor al principio de la Línea 1.
    MOVLW	B'10000000'				; Dirección 00h de la DDRAM
    BRA		LCD_CMD
LCD_L2							; Cursor al principio de la Línea 2.
    MOVLW	B'11000000'				; Dirección 40h de la DDRAM
    BRA		LCD_CMD
LCD_L3							; Cursor al principio de la Línea 3
    MOVLW	B'10010100'				; Dirección 14h de la DDRAM
    BRA		LCD_CMD
LCD_L3.2						; Cursor al principio de la Línea 3
    MOVLW	B'10010101'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.3						; Cursor al principio de la Línea 3
    MOVLW	B'10010110'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.4						; Cursor al principio de la Línea 3
    MOVLW	B'10010111'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.5						; Cursor al principio de la Línea 3
    MOVLW	B'10011000'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.6						; Cursor al principio de la Línea 3
    MOVLW	B'10011001'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.7						; Cursor al principio de la Línea 3
    MOVLW	B'10011010'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.8						; Cursor al principio de la Línea 3
    MOVLW	B'10011011'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.9						; Cursor al principio de la Línea 3
    MOVLW	B'10011100'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.10						; Cursor al principio de la Línea 3
    MOVLW	B'10011101'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.11						; Cursor al principio de la Línea 3
    MOVLW	B'10011110'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.12						; Cursor al principio de la Línea 3
    MOVLW	B'10011111'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.13						; Cursor al principio de la Línea 3
    MOVLW	B'10100000'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.14						; Cursor al principio de la Línea 3
    MOVLW	B'10100001'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.15						; Cursor al principio de la Línea 3
    MOVLW	B'10100010'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.16						; Cursor al principio de la Línea 3
    MOVLW	B'10100011'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD
LCD_L3.17						; Cursor al principio de la Línea 3
    MOVLW	B'10100100'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD  
LCD_L3.18						; Cursor al principio de la Línea 3
    MOVLW	B'10100101'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD  
LCD_L3.19						; Cursor al principio de la Línea 3
    MOVLW	B'10100110'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD  
LCD_L3.20						; Cursor al principio de la Línea 3
    MOVLW	B'10100111'				; Dirección 15h de la DDRAM
    BRA		LCD_CMD  
LCD_L4							; Cursor al principio de la Línea 4
    MOVLW	B'11010100'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD
LCD_L4.2
    MOVLW	B'11010101'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD    
LCD_L4.3
    MOVLW	B'11010110'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD    
LCD_L4.4
    MOVLW	B'11010111'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD    
LCD_L4.5
    MOVLW	B'11011000'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD   
LCD_L4.6
    MOVLW	B'11011001'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD   
LCD_L4.7
    MOVLW	B'11011010'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD   
LCD_L4.8
    MOVLW	B'11011011'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD   
LCD_L4.9
    MOVLW	B'11011100'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD   
LCD_L4.10
    MOVLW	B'11011101'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD   
LCD_L4.11
    MOVLW	B'11011110'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD   
LCD_L4.12
    MOVLW	B'11011111'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD      
LCD_L4.13
    MOVLW	B'11100000'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD  
LCD_L4.14
    MOVLW	B'11100001'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD  
LCD_L4.15
    MOVLW	B'11100010'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD  
LCD_L4.16
    MOVLW	B'11100011'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD  
LCD_L4.17
    MOVLW	B'11100100'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD  
LCD_L4.18
    MOVLW	B'11100101'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD     
LCD_L4.19
    MOVLW	B'11100110'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD     
LCD_L4.20
    MOVLW	B'11100111'				; Dirección 54h de la DDRAM
    BRA		LCD_CMD  
    
LCD_PosicionLinea1					; Cursor a posición de la Línea 1, a partir de la
    IORLW	b'10000000'				; dirección 00h de la DDRAM más el valor del
    BRA		LCD_CMD		; registro W.
LCD_PosicionLinea2					; Cursor a posición de la Línea 2, a partir de la
    IORLW	b'11000000'				; dirección 40h de la DDRAM más el valor del
    BRA		LCD_CMD		; registro W.
LCD_OFF								; Pantalla apagada.
    MOVLW	B'00001000'
    BRA		LCD_CMD
LCD_C_ON						; Pantalla encendida y cursor encendido.
    MOVLW	B'00001110'
    BRA		LCD_CMD
LCD_C_OFF						; Pantalla encendida y cursor apagado.
    MOVLW	B'00001100'
    BRA		LCD_CMD
LCD_CLEAR							; Borra toda la pantalla, memoria DDRAM y pone el 
    MOVLW	B'00000001'				; cursor a principio de la línea 1.
    BRA		LCD_CMD
LCD_2Lineas4Bits5x7					; Define la pantalla de 2 líneas, con caracteres
    MOVLW	B'00101000'				; de 5x7 puntos y conexión al PIC mediante bus de
LCD_CMD
    BCF	RS				; Activa el Modo Comando, poniendo RS=0.
    BRA	LCD_Envia
SET_CURSOR
    BRA		LCD_CMD
LCD_CURSOR_BON
    MOVLW	B'00001111'
    BRA		LCD_CMD
ENVIAR_DATO
    BSF	RS					; Activa el "Modo Dato", poniendo RS=1.
    CALL	LCD_CodigoCGROM			; Obtiene el código para correcta visualización.
LCD_Envia
    MOVWF	LCD_GuardaDato			; Guarda el dato a enviar.
    CALL	LCD_WRITE			; Primero envía el nibble alto.
    SWAPF	LCD_GuardaDato,W		; Ahora envía el nibble bajo. Para ello pasa el
						; nibble bajo del dato a enviar a parte alta del byte.
    CALL	LCD_WRITE			; Se envía al visualizador LCD.
    BTFSS	RS				; Debe garantizar una correcta escritura manteniendo 
    CALL	RET_1ms				; 2 ms en modo comando y 50 µs en modo cáracter.
    CALL	RET_1ms
    RETURN	
LCD_CodigoCGROM
    MOVWF	LCD_DATO				; Guarda el valor del carácter y comprueba si es
LCD_EnheMinuscula					; un carácter especial.
    SUBLW	'ñ' 					; ¿Es la "ñ"?
    BTFSS	STATUS,Z
    GOTO	LCD_EnheMayuscula		; No es "ñ".
    MOVLW	B'11101110'				; Código CGROM de la "ñ".
    MOVWF	LCD_DATO
    GOTO	LCD_FinCGROM
LCD_EnheMayuscula
    MOVF	LCD_DATO,W				; Recupera el código ASCII de entrada.
    SUBLW	'Ñ' 					; ¿Es la "Ñ"?
    BTFSS	STATUS,Z
    GOTO	LCD_Grado				; No es "Ñ".
    MOVLW	b'11101110'				; Código CGROM de la "ñ". (No hay símbolo para
    MOVWF	LCD_DATO				; la "Ñ" mayúscula en la CGROM).
    GOTO	LCD_FinCGROM	
LCD_Grado
    MOVF    LCD_DATO,W				; Recupera el código ASCII de entrada.
    SUBLW	'º' 					; ¿Es el símbolo "º"?
    BTFSS   STATUS,Z
    GOTO    LCD_FinCGROM			; No es "º".
    MOVLW   b'11011111'				; Código CGROM del símbolo "º".
    MOVWF   LCD_DATO
LCD_FinCGROM
    MOVF	LCD_DATO,W				; En (W) el código buscado.
    RETURN
    
LCD_CLEAR_L1
    CALL    LCD_L1
    CALL    LCD_LINEA_CLEAR
    RETURN
LCD_CLEAR_L2
    CALL    LCD_L2
    CALL    LCD_LINEA_CLEAR
    RETURN
LCD_CLEAR_L3
    CALL    LCD_L3
    CALL    LCD_LINEA_CLEAR
    RETURN
LCD_CLEAR_L4
    CALL    LCD_L4
    CALL    LCD_LINEA_CLEAR
    RETURN    
LCD_LINEA_CLEAR
    MOVLW   CHAR_X_LINEA
    MOVWF   LCD_Auxiliar1			; (LCD_Auxiliar1) se utiliza como contador.
LCD_SEND_WHITE	
    MOVLW	' '						; Esto es un espacio en blanco.
    CALL	ENVIAR_DATO
    DECFSZ	LCD_Auxiliar1,F			; haya cargado en (LCD_Auxiliar1).
    GOTO	LCD_SEND_WHITE
    RETURN

; Subrutinas "LCD_ByteCompleto" y "LCD_Byte" --------------------------------------------
;
; Subrutina "LCD_ByteCompleto", visualiza el byte que almacena el registro W en el
; lugar actual de la pantalla. Por ejemplo, si (W)=b'10101110' visualiza "AE".
;
; Subrutina "LCD_Byte" igual que la anterior, pero en caso de que el nibble alto sea cero 
; visualiza en su lugar un espacio en blanco. Por ejemplo si (W)=b'10101110' visualiza "AE"
; y si (W)=b'00001110', visualiza " E" (un espacio blanco delante).
;
; Utilizan la subrutina "LCD_Nibble" que se analiza más adelante.
LCD_Byte
	movwf	LCD_Auxiliar2			; Guarda el valor de entrada.
	andlw	b'11110000'				; Analiza si el nibble alto es cero.
	btfss	STATUS,Z				; Si es cero lo apaga.
	goto	LCD_VisualizaAlto		; No es cero y lo visualiza.
	movlw	' '						; Visualiza un espacio en blanco.
	call	LCD_DATO
	goto	LCD_VisualizaBajo

LCD_ByteCompleto
	movwf	LCD_Auxiliar2			; Guarda el valor de entrada.
LCD_VisualizaAlto
	swapf	LCD_Auxiliar2,W			; Pone el nibble alto en la parte baja.
	call	LCD_Nibble				; Lo visualiza.
LCD_VisualizaBajo
	movf	LCD_Auxiliar2,W			; Repite el proceso con el nibble bajo.
LCD_Nibble
	andlw	b'00001111'				; Se queda con la parte baja.
	movwf	LCD_Auxiliar1			; Lo guarda.
	sublw	0x09					; Comprueba si hay que representarlo con letra.
	btfss	STATUS,C	
	goto	LCD_EnviaByteLetra
	movf	LCD_Auxiliar1,W
	addlw	'0'						; El número se pasa a carácter ASCII sumándole
	goto 	LCD_FinVisualizaDigito	; el ASCII del cero y lo visualiza.
LCD_EnviaByteLetra
	movf	LCD_Auxiliar1,W
	addlw	'A'-0x0A				; Sí, por tanto, se le suma el ASCII de la 'A'.
LCD_FinVisualizaDigito
	goto	LCD_DATO			; Y visualiza el carácter. Se hace con un "goto"
									; para no sobrecargar la pila.








