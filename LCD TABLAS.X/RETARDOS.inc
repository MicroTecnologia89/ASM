CBLOCK
    VAR_X
ENDC

RET_SERVO
	MOVLW	B'00000011'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFF
	MOVWF	TMR0H
	MOVLW	0XFA
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO		

RET_1s
	MOVLW	B'00000111'		; TIMER 0 16 BITS
	MOVWF	T0CON			; PREESCALER 256
	BCF	INTCON,TMR0IF
	MOVLW	0X0B
	MOVWF	TMR0H
	MOVLW	0XDB
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
	
RET_500ms
	MOVLW	B'00000111'		; TIMER 0 16 BITS
	MOVWF	T0CON			; PREESCALER 256
	BCF	INTCON,TMR0IF
	MOVLW	0X85
	MOVWF	TMR0H
	MOVLW	0XED
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_100ms
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0X3C
	MOVWF	TMR0H
	MOVLW	0XAF
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_50ms
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0X9E
	MOVWF	TMR0H
	MOVLW	0X57
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_33ms
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XBF
	MOVWF	TMR0H
	MOVLW	0X8B
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_16ms
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XE0
	MOVWF	TMR0H
	MOVLW	0XBF
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_18ms
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XDC
	MOVWF	TMR0H
	MOVLW	0XD7
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_10ms
	MOVLW	B'00000011'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XD8
	MOVWF	TMR0H
	MOVLW	0XF0
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_5ms
	MOVLW	B'00000000'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	.99
	MOVWF	TMR0H
	MOVLW	.82
	MOVWF	TMR0L	
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO
RET_500us
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFF
	MOVWF	TMR0H
	MOVLW	0X05
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO
RET_250us
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFF
	MOVWF	TMR0H
	MOVLW	0X82
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO
RET_100us
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFF
	MOVWF	TMR0H
	MOVLW	0XC2
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_1ms
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFE
	MOVWF	TMR0H
	MOVLW	0X0D
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO
CICLO_RETARDO	
	BTFSS	INTCON,TMR0IF
	GOTO	CICLO_RETARDO
	BCF	INTCON,TMR0IF
	BCF	T0CON,TMR0ON
	RETURN



















