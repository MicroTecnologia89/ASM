List p=18F26k22
#include "p18f26k22.inc"

; CONFIG1H
  CONFIG  FOSC = INTIO67          ; Oscillator Selection bits (HS oscillator (medium power 4-16 MHz))
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
	AUX_TABLA90
	UNIDADES
	DECENAS
	MUESTRAS
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
	BSF	OSCCON,IRCF2 	;CONFIGURO EL OSCILADOR INTERNO
	BSF	OSCCON,IRCF1 	;A 16MHZ
	BSF	OSCCON,IRCF0
	BSF	OSCTUNE,PLLEN
	CLRF	SLRCON
	
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
	
;*********************************************************************************
;**************************  ZONA DE CODIGO USUARIO  *****************************
;*********************************************************************************	
	CLRF	UNIDADES
	CLRF	DECENAS
	MOVLW	.10
	MOVWF	MUESTRAS
PRINCIPAL
	CALL	MUESTRA_DISPLAY		; RETUNA DE VISUALIZACIÓN DE VALORES EN DISPLAY
	INCF	UNIDADES,F		; INCREMENTO UNIDADES EN 1
	MOVF	UNIDADES,W		; MUEVO VARIABLE A W
	SUBLW	.10			; LE RESTO 10
	BTFSS	STATUS,Z		; PREGUNTO SI ES CERO
	GOTO	PRINCIPAL		; CONTINUO EL CONTEO
	CLRF	UNIDADES		; REINICIO VARIABLE
	INCF	DECENAS,F		; INCREMENTO DECENAS EN 1
	MOVF	DECENAS,W		; MUEVO A W
	SUBLW	.10			; LE RESTO 10
	BTFSS	STATUS,Z		; SABER SI LLEGO
	GOTO	PRINCIPAL		; CONTINUO CONTEO
	
	MOVLW	.9			; MUEVO EL 9 A W
	MOVWF	DECENAS			; RECARGO EL VALOR
	MOVLW	.9			; RECARGO 9 A W
	MOVWF	UNIDADES		; RECARGO VALOR
CONTADOR_DECREMENTO
	; AL LLEGAR AQUI MI VARIABLE UNIDADES VALE 9 Y DECENAS VALE 9= 99
	CALL	MUESTRA_DISPLAY		; RETUNA DE VISUALIZACIÓN DE VALORES EN DISPLAY
	DECF	UNIDADES,F		; INCREMENTO UNIDADES EN 1
	MOVF	UNIDADES,W		; MUEVO VARIABLE A W
	SUBLW	.255			; LE RESTO 10
	BTFSS	STATUS,Z		; PREGUNTO SI ES CERO
	GOTO	CONTADOR_DECREMENTO	; CONTINUO EL CONTEO
	MOVLW	.9			; RECARGO CON 9
	MOVWF	UNIDADES		; REINICIO VARIABLE
	DECF	DECENAS,F		; INCREMENTO DECENAS EN 1
	MOVF	DECENAS,W		; MUEVO A W
	SUBLW	.255			; LE RESTO 10
	BTFSS	STATUS,Z		; SABER SI LLEGO
	GOTO	CONTADOR_DECREMENTO	; CONTINUO CONTEO
	CLRF	DECENAS			; LIMPIO VARIABLE
	CLRF	UNIDADES
	GOTO	PRINCIPAL		; CONTEO ASCENDENTE

	
	
MUESTRA_DISPLAY	
	BSF	LATB,0			; PRENDO DISPLAY 1
	BCF	LATB,1			; APAGO DISPLAY 2
	MOVF	UNIDADES,W		; MUEVO EL VALOR DE UNIDADES A W
	CALL	TABLA_NUMERO		; LLAMO MI SUBRUTINA TABLA
	MOVWF	LATC			; EL RESULTADO LO MUEVO A PUERTO C
	CALL	RET_10ms		; RETARDO DE VISUALIZACION

	BSF	LATB,1			; PRENDO DISPLAY 1
	BCF	LATB,0			; APAGO DISPLAY 2
	MOVF	DECENAS,W		; MUEVO EL VALOR DE UNIDADES A W
	CALL	TABLA_NUMERO		; LLAMO MI SUBRUTINA TABLA
	MOVWF	LATC			; EL RESULTADO LO MUEVO A PUERTO C
	CALL	RET_10ms		; RETARDO DE VISUALIZACION	
	DECFSZ	MUESTRAS,F
	GOTO	MUESTRA_DISPLAY
	
	MOVLW	.25
	MOVWF	MUESTRAS
	RETURN

TABLA_NUMERO
	; GUARDO EL VALOR DE COMPARACION
	MOVWF	AUX_TABLA90		; GUARDO EL VALOR EN AUX
	; DIRECCIONO LA TABLA
	MOVLW   UPPER(TABLA)		; DIRECCION UPPER TABLA
	MOVWF   TBLPTRU			; SE ASIGNA
	MOVLW   HIGH(TABLA)		; DIRECCION HIGH TABLA
	MOVWF   TBLPTRH			; SE ASIGNA 
	MOVLW   LOW(TABLA)		; DIRECCION LOW TABLA
	MOVWF   TBLPTRL			; SE ASIGNA
	; LEER EL VALOR DE W+TABLA
	MOVF	AUX_TABLA90,W		; REGRESAMOS EL VALOR DE AUX A W
	ADDWF	TBLPTRL,F		; LO SUMAMOS CON EL PUNTERO
	TBLRD*				; LEEMOS LA TABLA
	MOVF	TABLAT,W		; EL VALOR LEIDO ES MOVIDO A W
	RETURN				; RETORNAMOS
	
TABLA:   DB 0X3F,0X06,0X5B,0X4F,0X66,0X6D,0X7D,0X07,0X7F,0X67	
     
	#INCLUDE<RETARDOS.INC>	
	
	END	


