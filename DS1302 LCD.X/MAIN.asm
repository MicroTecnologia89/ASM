List p=18F26k22
#include "p18f26k22.inc"

; CONFIG1H
  CONFIG  FOSC = HSMP           ; Oscillator Selection bits (HS oscillator (medium power 4-16 MHz))
  CONFIG  PLLCFG = ON           ; 4X PLL Enable (Oscillator multiplied by 4)
  CONFIG  PRICLKEN = ON         ; Primary clock enable bit (Primary clock enabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRTEN = OFF          ; Power-up Timer Enable bit (Power up timer disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 190            ; Brown Out Reset Voltage bits (VBOR set to 1.90 V nominal)

; CONFIG2H
  CONFIG  WDTEN = OFF            ; Watchdog Timer Enable bits (WDT is always enabled. SWDTEN bit has no effect)
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC1       ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<5:0> pins are configured as digital I/O on Reset)
  CONFIG  CCP3MX = PORTB5       ; P3A/CCP3 Mux bit (P3A/CCP3 input/output is multiplexed with RB5)
  CONFIG  HFOFST = ON           ; HFINTOSC Fast Start-up (HFINTOSC output and ready status are not delayed by the oscillator stable status)
  CONFIG  T3CMX = PORTC0        ; Timer3 Clock input mux bit (T3CKI is on RC0)
  CONFIG  P2BMX = PORTB5        ; ECCP2 B output mux bit (P2B is on RB5)
  CONFIG  MCLRE = INTMCLR       ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection Block 0 (Block 0 (000800-003FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection Block 1 (Block 1 (004000-007FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection Block 2 (Block 2 (008000-00BFFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection Block 3 (Block 3 (00C000-00FFFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection Block 0 (Block 0 (000800-003FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection Block 1 (Block 1 (004000-007FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection Block 2 (Block 2 (008000-00BFFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection Block 3 (Block 3 (00C000-00FFFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot Block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection Block 0 (Block 0 (000800-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection Block 1 (Block 1 (004000-007FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection Block 2 (Block 2 (008000-00BFFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection Block 3 (Block 3 (00C000-00FFFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot Block (000000-0007FFh) not protected from table reads executed in other blocks)

	
	
	CBLOCK	0x00
	W_TEMP
	STATUS_TEMP
	BSR_TEMP

	POT_VALUE
	AUX_DS1302
	
	CONT
	AUX_SPI
	AUX_SPIR
	ENDC
;*********************************************************************************
;****************** ORIGEN DE EJECUCION POSTERIOR AL RESET ***********************
;*********************************************************************************
	ORG	0x000			; ORIGEN INICIO RESET
 	GOTO	INICIO			; ME VOY A INICIO
	ORG	0x008			; ORIGEN ISR ALTA PRIORIDAD
	GOTO	BAJA_PRIORIDAD
	ORG	0x018			; ORIGEN ISR BAJA PRIORIDAD
BAJA_PRIORIDAD
	MOVWF	W_TEMP			; MUEVO EL ULTIMA VALOR DE W 
	MOVFF	STATUS,STATUS_TEMP	; DE STATUS Y DE BSR
	MOVFF	BSR,BSR_TEMP		; PARA RESTAURARLOS AL VALOR ANTES DE LA INTERRUPCION
FIN_INTER
	MOVWF	W_TEMP			; MUEVO EL ULTIMA VALOR DE W 
	MOVFF	STATUS,STATUS_TEMP	; DE STATUS Y DE BSR
	MOVFF	BSR,BSR_TEMP		; PARA RESTAURARLOS AL VALOR ANTES DE LA INTERRUPCION
	RETURN				; REGRESO DE INTERRUPCION
ALTA_PRIORIDAD
	GOTO	FIN_INTER		; VE A FINAL DE INTERRUPCION
	
;*********************************************************************************
;**************************CONFIGURACIÓN DE PUERTOS ******************************
;*********************************************************************************
INICIO
	MOVLB 	0xF			; PARA ACCEDER CORRECTAMENTE
	CLRF	ANSELA			; ANALOGICAS NECESARIAS Y LO
	CLRF	ANSELB			; DEMAS COMO ENTRADAS Y SALIDAS
	CLRF	ANSELC			; DIGITALES
	MOVLB 0xF
	CLRF	PORTA			; LIMPIO EL PUERTO A
	CLRF	PORTB			; LIMPIO EL PUERTO B
	CLRF	PORTC			; LIMPIO EL PUERTO C
	MOVLB	0X0			; PARA ACCEDER CORRECTAMENTE	
	CLRF	LATA			; LIMPIO LATCH A
	CLRF	LATB			; LIMPIO LATCH B
	CLRF	LATC			; LIMPIO LATCH C
	

	CLRF	TRISA			; SALIDAS DIGITALES PUERTO A
	CLRF	TRISB			; SALIDAS DIGITALES PUERTO B
	CLRF	TRISC			; SALIDAS DIGITALES PUERTO C
	
;*********************************************************************************
;**************************CONFIGURACIÓN DE RETARDOS *****************************
;*********************************************************************************
	CALL	CONFIG_RETARDO		; INICIO EL TIMER ASOCIADO A LOS RETARDOS	
	MOVLW	B'00110010'		; HABILITO SPI
	MOVWF	SSP1CON1		; 
	BSF	TRISC,4
;*********************************************************************************
;**************************  ZONA DE CODIGO USUARIO  *****************************
;*********************************************************************************	
    #DEFINE	    CS		LATC,7	    ; PIN CHIP SELECT
;*********************************************************************************
;*********************************************************************************
;*********************************************************************************    

;*********************************************************************************
;**************************CONFIGURACIÓN DE LCD *****************************
;*********************************************************************************
	CALL	INI_LCD			; INICIALIZO LCD    
    
    
READ_SEC	EQU	0X81		; LEO SEGUNDOS
WRITE_SEC	EQU	0X80		; LEO SEGUNDOS
READ_MIN	EQU	0X83		; LEO SEGUNDOS
WRITE_MIN	EQU	0X82		; LEO SEGUNDOS
READ_HRS	EQU	0X85		; LEO SEGUNDOS
WRITE_HRS	EQU	0X84		; LEO SEGUNDOS

	

	
	
	BCF	CS
	CALL	RET_100ms

	CALL	LCD_L1
	CALL	MENSAJE_1
PRINCIPAL
	CALL	LEER_SEGUNDOS
	MOVFF	AUX_DS1302,LATA
	MOVF	AUX_DS1302,W
	CALL	CONVERSION_BCD

	CALL	LCD_L2
	MOVF	AUX_UNIDADES,W
	CALL	ENVIAR_DATO
	MOVF	AUX_DECENAS,W
	CALL	ENVIAR_DATO
	MOVF	AUX_CENTENAS,W
	CALL	ENVIAR_DATO	
	
	CALL	RET_100ms
	GOTO	PRINCIPAL
	
	MOVLW	.4
	CALL	ESCRIBIR_SEGUNDOS
	CALL	RET_1s	
	MOVLW	.0
	CALL	ESCRIBIR_MINUTOS
	CALL	RET_1s
	MOVLW	.1
	CALL	ESCRIBIR_HORAS
	CALL	RET_1s	
	GOTO	PRINCIPAL		; LOOP PRINCIPAL
	
LEER_SEGUNDOS
	BSF	CS			; ACTIVO CHIP SELECT
	MOVLW	READ_SEC		; MOUEVO EL COMANDO A W
	CALL	SPI_DATA		; ESCRIBO EN SPI
	BSF	TRISC,5
	MOVLW	0X00
	CALL	SPI_DATA		; ESCRIBO EN SPI	
	MOVFF	SSP1BUF,AUX_DS1302
	BCF	CS			; REGRESA CHIP SELECT A ESTADO INACTIVO
	BCF	TRISC,5

	RETURN	
ESCRIBIR_SEGUNDOS
	MOVWF	AUX_DS1302		; GUARDO EL VALOR A ESCRIBIR
	BSF	CS			; ACTIVO CHIP SELECT
	MOVLW	WRITE_SEC		; MOUEVO EL COMANDO A W
	CALL	SPI_DATA		; ESCRIBO EN SPI
	MOVF	AUX_DS1302,W		; MUEVO EL VALOR A W REG
	CALL	SPI_DATA		; ESCRIBO EN SPI	
	BCF	CS			; REGRESA CHIP SELECT A ESTADO INACTIVO
	RETURN
ESCRIBIR_MINUTOS	
	MOVWF	AUX_DS1302		; GUARDO EL VALOR A ESCRIBIR
	BSF	CS			; ACTIVO CHIP SELECT
	MOVLW	WRITE_MIN		; MOUEVO EL COMANDO A W
	CALL	SPI_DATA		; ESCRIBO EN SPI
	MOVF	AUX_DS1302,W		; MUEVO EL VALOR A W REG
	CALL	SPI_DATA		; ESCRIBO EN SPI	
	BCF	CS			; REGRESA CHIP SELECT A ESTADO INACTIVO
	RETURN
ESCRIBIR_HORAS	
	MOVWF	AUX_DS1302		; GUARDO EL VALOR A ESCRIBIR
	BSF	CS			; ACTIVO CHIP SELECT
	MOVLW	WRITE_HRS		; MOUEVO EL COMANDO A W
	CALL	SPI_DATA		; ESCRIBO EN SPI
	MOVF	AUX_DS1302,W		; MUEVO EL VALOR A W REG
	CALL	SPI_DATA		; ESCRIBO EN SPI	
	BCF	CS			; REGRESA CHIP SELECT A ESTADO INACTIVO
	RETURN	
;*********************************************************************************
;*********************************************************************************	
SPI_DATA
	MOVWF	AUX_SPI
INVERTIR
; CON ESTAS INST. EJECUTO CAMBIO DE MSB A LSB
; MOST SIGNIFICANT BIT ---- LESS SIGNIFICANT BIT 
;   ORIGINAL	ROTADO
;	B7-	B0
	BCF	AUX_SPIR,0		; EN 0 BIT 0 ROTADO 
	BTFSC	AUX_SPI,7		; PREGUNTO POR EL BIT 7 DATO ORIGNIAL
	BSF	AUX_SPIR,0		; SI ESTA EN UNO LO PRENDO	
;	B6-	B1
	BCF	AUX_SPIR,1		; EN 0 BIT 1 ROTADO 
	BTFSC	AUX_SPI,6		; PREGUNTO POR EL BIT 6 DATO ORIGNIAL
	BSF	AUX_SPIR,1		; SI ESTA EN UNO LO PRENDO	
;	B5-	B2
	BCF	AUX_SPIR,2		; EN 0 BIT 2 ROTADO 
	BTFSC	AUX_SPI,5		; PREGUNTO POR EL BIT 5 DATO ORIGNIAL
	BSF	AUX_SPIR,2		; SI ESTA EN UNO LO PRENDO	
;	B4-	B3
	BCF	AUX_SPIR,3		; EN 0 BIT 3 ROTADO 
	BTFSC	AUX_SPI,4		; PREGUNTO POR EL BIT 4 DATO ORIGNIAL
	BSF	AUX_SPIR,3		; SI ESTA EN UNO LO PRENDO	
;	B3-	B4
	BCF	AUX_SPIR,4		; EN 0 BIT 4 ROTADO 
	BTFSC	AUX_SPI,3		; PREGUNTO POR EL BIT 3 DATO ORIGNIAL
	BSF	AUX_SPIR,4		; SI ESTA EN UNO LO PRENDO		
;	B2-	B5
	BCF	AUX_SPIR,5		; EN 0 BIT 5 ROTADO 
	BTFSC	AUX_SPI,2		; PREGUNTO POR EL BIT 2 DATO ORIGNIAL
	BSF	AUX_SPIR,5		; SI ESTA EN UNO LO PRENDO	
;	B1-	B6
	BCF	AUX_SPIR,6		; EN 0 BIT 6 ROTADO 
	BTFSC	AUX_SPI,1		; PREGUNTO POR EL BIT 1 DATO ORIGNIAL
	BSF	AUX_SPIR,6		; SI ESTA EN UNO LO PRENDO	
;	B0-	B7
	BCF	AUX_SPIR,7		; EN 0 BIT 7 ROTADO 
	BTFSC	AUX_SPI,0		; PREGUNTO POR EL BIT 0 DATO ORIGNIAL
	BSF	AUX_SPIR,7		; SI ESTA EN UNO LO PRENDO	

	MOVF	AUX_SPIR,W
	MOVWF	SSP1BUF			; MARGO EL VALOR EN W A BUFFER DE TRANSMISION
WAIT_SPI
	BTFSS	PIR1,SSP1IF		; ESPERO A QUE TRANSMISION TERMINE
	GOTO	WAIT_SPI		; SI NO TERMINA SIGO ESPERANDO
	BCF	PIR1,SSP1IF		; LIMPIO BANDERA
	RETURN				; REGRESO
;*********************************************************************************
;*********************************************************************************	
MENSAJE_1
	MOVLW	UPPER(TXT_1)		; DIRECCIÓN UPPER MENSAJE 
	MOVWF	TBLPTRU			; LO MUEVO A LA DIRECCIÓN UPPER DE LA TABLA
	MOVLW	HIGH(TXT_1)		; DIRECCION H DEL MENSAJE
	MOVWF	TBLPTRH			; LO MUEVO A DIRECCIÓN H DE LA TABLA
	MOVLW	LOW(TXT_1)	    	; DIRECCION L DEL MENSAJE
	MOVWF	TBLPTRL			; LO MUEVO A DIRECCION L DE LA TABLA
	GOTO	SENDING_TEXT		; ME DIRIJO A MANDAR LOS CARACTERES
;**********************************************************************************
;**********************************************************************************
SENDING_TEXT
	TBLRD*+ 			; LEO TABLA E INCREMENTO EN UNO LA DIRECCION DESPES DE LEER	
	MOVF	TABLAT,W		; MOVEMOS EL REGISTRO TBLAT A W PARA LEER EL DATO
	BTFSS	STATUS,Z		; PREGUNTO SI YA FUE CERO AL VALOR PARA SALIR
	BRA	TEXTS			; SI NO FUE ASI NOS DIRIGIMOS A ENVIAR A LA LCD EL DATO OBTENIDO
	RETURN				; LLEGAMOS A ESTE PUNTO CUANDO YA ENCONTRAMOS EL 0X00 DE LA TABLA
TEXTS
	MOVF	TABLAT,W		; MOVEMOS EL REGISTRO TABLAT A W
	CALL	ENVIAR_DATO		; LO ENVIAMOS A LA LCD
	BRA	SENDING_TEXT		; SEGUIMOS LEYENDO EL SIGUIENTE DATO DE LA TABLA
;**********************************************************************************
;************************ MENSAJES PARA LCD EN TABLAS *****************************
;**********************************************************************************
	
	
TXT_1:	    DATA  "HOLA MICROTECNOLOGIA",0x00 	
TXT_2:	    DATA  "--HOLA MUNDO TABLAS-",0x00

#INCLUDE<RETARDOS.INC>	
#INCLUDE<LCD_4BIT.INC>	

	
	
	END	


