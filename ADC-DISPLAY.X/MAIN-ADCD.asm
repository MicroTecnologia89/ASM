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
	
	CONTADOR
	RESULTADO_H
	RESULTADO_L
	
	AUXILIAR			; 
	AUX_UNIDADES		        ;
	AUX_DECENAS	    		; 
	AUX_CENTENAS			; 
	
	RESULTADO_PUERTOC
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
	
	BSF 	ANSELA,ANSA0		; CONFIGURAMOS LA ENTRADA A0 PARA LEERLA	
	
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
	
	BSF	TRISA,0
	
;*****************************************************************************************************
;********************************CONFIGURACION DE ADC ************************************************
;*****************************************************************************************************	
	MOVLW	B'00111110'			; JUSTIFICADO A LA IZQUIERDA
	MOVWF	ADCON2			    	; CARGO EL VALOR DE CONFIGURACION
	MOVLW	B'00001111'
	MOVWF 	ADCON1				; ADCON1 ES 0 	
	
;*********************************************************************************
;**************************CONFIGURACIÓN DE RETARDOS *****************************
;*********************************************************************************
	CALL	CONFIG_RETARDO		; INICIO EL TIMER ASOCIADO A LOS RETARDOS	
	
;*********************************************************************************
;**************************  ZONA DE CODIGO USUARIO  *****************************
;*********************************************************************************	

PRINCIPAL
	CALL	ADC_CONVERSION			; LLAMO RUTINA DE CONVERSION ADC
	MOVF	RESULTADO_H,W			; EL SELTADO H O ALTO LO MUEVO AL PUERTO C
	
	CALL	CONVERSION_BCD
	MOVFF	AUX_UNIDADES,LATB
	MOVFF	AUX_DECENAS,RESULTADO_PUERTOC
	SWAPF	AUX_CENTENAS,W
	; 0000 0010
	; 0010 0000
	ADDWF	RESULTADO_PUERTOC,F
	; 0010 0000  VALOR CENTENAS
	; 0000 XXXX  VALOR DECENAS
	; 0010 XXXX  VALOR CENTENAS + VALOR DECENAS
	MOVFF	RESULTADO_PUERTOC,LATC
	CALL	RET_1ms				; RETARDO 1mS
	
	GOTO	PRINCIPAL

	
ADC_CONVERSION
	MOVLW 	B'00000011'			; VAMOS A SELECCIONAR EL ADC 0 Y HABILITAR EL PUERTO DE CONVERSIÓN
	MOVWF 	ADCON0				; SELECCIONAMOS EL CH 0	
	;BSF 	ADCON0,ADON			; SELECCIONO CANAL ADC 0
	;BSF 	ADCON0,GO			; INICIO LA CONVERSION
ADC_PROC
	BTFSC	ADCON0,GO			; ESPERO A QUE ACABE LA CONVERSION
	GOTO	ADC_PROC			; MIENTRAS NO ACABE QUEDO EN LOOP
	MOVFF	ADRESH,RESULTADO_H		; UNA VEZ FNALIZADA EL REGISTRO H LO MUEVO A VARIABLE
	MOVFF	ADRESL,RESULTADO_L		; Y EL REGISTRO L LO MUEVO A RESULTADO L
	RETURN					; RETORNO

	
;***************************************************************************************************
;******************* RUTINAS ESPECIALES PARA CONVERSIÓN BINARIO A BCD ******************************
;***************************************************************************************************
CONVERSION_BCD
	MOVWF 	AUXILIAR			; MOVEMOS EL VALOR QUE VIENE EN W AL REGISTRO AUXILIAR
	CLRF	AUX_UNIDADES		        ; LIMPIAMOS NUESTROS AUXILIARES	
	CLRF	AUX_DECENAS	    		; LIMPIAMOS NUESTROS AUXILIARES
	CLRF	AUX_CENTENAS			; LIMPIAMOS NUESTROS AUXILIARES
S_CENTENAS
	MOVLW 	.100				; CARGAMOS UN 100 A W
	SUBWF 	AUXILIAR,W			; LE RESTAMOS A NUESTRO VALOR PRINCIPAL 
	BTFSC 	STATUS,C			; PREGUNTAMOS SI ES MAYOR O MENOR
	GOTO 	SUMA_CENTENAS			; SI NO ES MAYOR PROCEDEMOS A SUMAR CENTENAS
	GOTO 	S_DECENAS			; SI ES MENOR VAMOS A SUMAR DECENAS
SUMA_CENTENAS
	MOVWF 	AUXILIAR			; EL RESULTADO LO ACTUALIZAMOS EN W
	INCF 	AUX_CENTENAS,F			; INCREMENTAMOS EL REGISTRO DE CENTENAS EN 1
	GOTO 	S_CENTENAS			; REGRESAMOS A LA ETIQUETA S_CENTENAS
S_DECENAS
	MOVLW 	.10				; CARGAMOS EL VALOR 10 A W
	SUBWF 	AUXILIAR,W			; PARA RESTARLO A NUESTRO VALOR PRINCIPAL
	BTFSC 	STATUS,C			; PREGUNTAMOS SI ES MAYOR O MENOR
	GOTO 	SUMA_DECENAS			; SI FUE MAYOR EL NUMERO VAMOS A SUMAR DECENAS
	GOTO 	SUMA_UNIDADES			; SI ES MENOR VAMOS A SUMAR UNIDADES
SUMA_DECENAS
	MOVWF 	AUXILIAR			; AUCTUALIZAMOS LA VARIABLE AUXILIAR
	INCF 	AUX_DECENAS,1			; INCREMENTAMOS EN 1 AL REGISTRO DECENAS
	GOTO 	S_DECENAS			; REGRESAMOS A ETIQUETA DE S_DECENAS
SUMA_UNIDADES	
	MOVF 	AUXILIAR,W			; EN UNIDADES EL RESIDUO DE LAS OPERACIONES ES CARGADO A AUX_UNIDADES
	MOVWF 	AUX_UNIDADES			; AUN SI ES CERO
	RETURN					; QUEDO LISTA LA CONVERSION DE BINARIO A BCD REGRESO CON VALORES EN REGISTROS AUXILIARES	
	
	
	#INCLUDE<RETARDOS.INC>	
	
	END	


