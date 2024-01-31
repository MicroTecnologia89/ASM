List p=18F26k22
#include "p18f26k22.inc"

; CONFIG1H
  CONFIG  FOSC = INTIO67           ; Oscillator Selection bits (HS oscillator (medium power 4-16 MHz))
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

	VAR1
	VAR2
	VAR3
	CURSOR
	
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

	BSF	OSCCON,IRCF2			;CONFIGURO EL OSCILADOR INTERNO
	BSF	OSCCON,IRCF1			;A 16MHZ
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

	MOVLW	B'11111111'
	MOVWF	TRISA
	
;*********************************************************************************
;**************************CONFIGURACIÓN DE LCD *****************************
;*********************************************************************************
	CALL	INI_LCD			; INICIALIZO LCD
;*********************************************************************************
;**************************  ZONA DE CODIGO USUARIO  *****************************
;*********************************************************************************
    
	#DEFINE	INC		    PORTA,0
	#DEFINE	DEC		    PORTA,1
	#DEFINE	INC2		    PORTA,2
	#DEFINE	DEC2		    PORTA,3	
	
	FLECHA	EQU B'01111110'
	
	
	CLRF	VAR1
	CLRF	VAR2
	CLRF	VAR3
	CALL	READ_EEPROM	
	
	
PRINCIPAL
	CALL	PRINT_V1		 ; IMPRIMO VARIABLE 1
	CALL	PRINT_V2		; IMPRIMO VARIABLE 2
	BTFSS	INC		        ; TESTEO BOTON DE INCREMENTO
	GOTO	INC_V1			; RUTINA DE INCREMENTO
	BTFSS	DEC			; TESTEO BOTON DE DECREMENTO
	GOTO	DEC_V1			; RUTINA DE DECRMENTO
	BTFSS	INC2			; TESTEO INCREMENTO V2
	GOTO	INC_V2			; RUTINA DE INCREMENTO V2
	BTFSS	DEC2			; TESTEO DECREMENTO V2
	GOTO	DEC_V2			; RUTINA DECREMENTO V2
	GOTO	PRINCIPAL		; REGRESO A LOOP PRINCIPAL

;*******************************************************************************
INC_V1
	CALL	RET_500ms
	INCF	VAR1,F
	CALL	WRITE_EEPROM
	GOTO	PRINCIPAL
DEC_V1
	CALL	RET_500ms
	DECF	VAR1,F
	CALL	WRITE_EEPROM
	GOTO	PRINCIPAL
INC_V2
	CALL	RET_500ms
	INCF	VAR2,F
	CALL	WRITE_EEPROM
	GOTO	PRINCIPAL
DEC_V2
	CALL	RET_500ms
	DECF	VAR2,F
	CALL	WRITE_EEPROM
	GOTO	PRINCIPAL	
;*******************************************************************************	
PRINT_V1
	CALL	LCD_L1			; POSICIONAMIENTO LCD L1
	MOVLW	'V'			; CARACTER A MOSTRAR
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVLW	'A'			; CARACTER A MOSTRAR
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVLW	'R'			; CARACTER A MOSTRAR
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 	
	MOVLW	'1'			; CARACTER A MOSTRAR
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVLW	':'			; CARACTER A MOSTRAR
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVLW	' '			; CARACTER A MOSTRAR
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVF	VAR1,W			; MUEVO VARIABLE A W
	CALL	CONVERSION_BCD		; CONVERSION BCD
	MOVF	AUX_CENTENAS,W
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVF	AUX_DECENAS,W
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVF	AUX_UNIDADES,W
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD  
	RETURN				; RETORNO DE CALL

;*******************************************************************************	
PRINT_V2
	CALL	LCD_L2			; POSICIONAMIENTO LCD L1
	MOVLW	'V'			; CARACTER A MOSTRAR
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVLW	'A'			; CARACTER A MOSTRAR
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVLW	'R'			; CARACTER A MOSTRAR
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 	
	MOVLW	'2'			; CARACTER A MOSTRAR
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVLW	':'			; CARACTER A MOSTRAR
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVLW	' '			; CARACTER A MOSTRAR
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVF	VAR2,W			; MUEVO VARIABLE A W
	CALL	CONVERSION_BCD		; CONVERSION BCD
	MOVF	AUX_CENTENAS,W
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVF	AUX_DECENAS,W
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 
	MOVF	AUX_UNIDADES,W
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD  
	RETURN				; RETORNO DE CALL
	;*********************************************************
;	MOVF	VAR4,W			; MUEVO VARIABLE A WREG
	CALL	CONVERSION_BCD		; LLAMO RUTINA DE CONVERSIÓN BCD
	MOVF	AUX_CENTENAS,W		; MUEVO EL RESULTADO CENTENAS A W 
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 	
	MOVF	AUX_DECENAS,W		; MUEVO EL RESULTADO DECENAS A W 
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 	
	MOVF	AUX_UNIDADES,W		; MUEVO EL RESULTADO UNIDADES A W 
	CALL	ENVIAR_DATO		; ENVIO CARACTER A LCD 	
	;**********************************************************	
	RETURN				; RETORNO DE CALL
;*******************************************************************************	

READ_EEPROM
	MOVLW	0X00			; DIR DE 0 A 1023
	MOVWF	EEADRH
	MOVLW	0X00
	MOVWF	EEADR			; Data Memory Address to read
	BCF	EECON1, EEPGD		; Point to DATA memory
	BCF	EECON1, CFGS		; Access EEPROM
	BSF	EECON1, RD		; EEPROM Read
	MOVF	EEDATA, W		; W = EEDATA
	MOVWF	VAR1
;*******************************************************************************
	MOVLW	0X00			; DIR DE 0 A 1023
	MOVWF	EEADRH
	MOVLW	0X01
	MOVWF	EEADR			; Data Memory Address to read
	BCF	EECON1, EEPGD		; Point to DATA memory
	BCF	EECON1, CFGS		; Access EEPROM
	BSF	EECON1, RD		; EEPROM Read
	MOVF	EEDATA, W		; W = EEDATA
	MOVWF	VAR2	
;*******************************************************************************	
	RETURN
WRITE_EEPROM
;*******************************************************************************	
	MOVLW	0X00			; DIRECCION H DE EEPROM
	MOVWF	EEADRH			; 
	MOVLW	0X00			; DIRECCION L DE EEPROM  
	MOVWF	EEADR			;
	MOVF	VAR1,W			; MUEVO EL VALOR QUE SE VA A ESCRIBIR A W
	MOVWF	EEDATA			; PARA ASIGNARLO A REGISTRO DE EERPOM 
	CALL	WEEPROM			; RUTINA DE ESCRITURA
;*******************************************************************************
;*******************************************************************************	
	MOVLW	0X00			; DIRECCION H DE EEPROM
	MOVWF	EEADRH			; 
	MOVLW	0X01			; DIRECCION L DE EEPROM  
	MOVWF	EEADR			;
	MOVF	VAR2,W			; MUEVO EL VALOR QUE SE VA A ESCRIBIR A W
	MOVWF	EEDATA			; PARA ASIGNARLO A REGISTRO DE EERPOM 
	CALL	WEEPROM			; RUTINA DE ESCRITURA
;*******************************************************************************	
	RETURN

WEEPROM
	BCF	EECON1, EEPGD	    	; Point to DATA memory
	BCF	EECON1, CFGS		; Access EEPROM
	BSF	EECON1, WREN		 ; Enable writes
	BCF	INTCON, GIE		; Disable Interrupts
	MOVLW	55h			;Required 
	MOVWF	EECON2			; Write 55h	Sequence 
	MOVLW	0AAh			;
	MOVWF	EECON2			; Write 0AAh
	BSF	EECON1, WR		; Set WR bit to begin write

	BTFSC	EECON1, WR		; Wait for write to complete
	BRA	$-2
	
;	BSF	INTCON, GIE		; Enable Interrupts	; User code execution
	BCF	EECON1, WREN		; Disable writes on write complete (EEIF set)	
	RETURN
	
#INCLUDE<RETARDOS.INC>
#INCLUDE<LCD_4BIT.INC>	

	END	
 