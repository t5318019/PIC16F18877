  	LIST p=16F18877
	#include<p16F18877.inc>
	
	__CONFIG _CONFIG1, _FEXTOSC_HS & _RSTOSC_EXT1X
	__CONFIG _CONFIG2, _BOREN_ON & _PPS1WAY_OFF
	__CONFIG _CONFIG3, _WDTE_OFF
	__CONFIG _CONFIG5, _CP_OFF & _CPD_OFF
	
	ORG	00H
	GOTO	START
	ORG	04H
	GOTO	INTSUB
	
START:	MOVLB	.17
	MOVLW	0x70
	MOVWF	OSCCON1
	MOVLW	0x04
	MOVWF	OSCFRQ
	
	MOVLB	.11
	BSF	INTCON,GIE
	BSF	INTCON,PEIE
	
	MOVLB	.4
	MOVLW	0x31
	MOVWF	T1CON
	MOVLW	0x01
	MOVWF	T1CLK
	MOVLW	0x00
	MOVWF	TMR1H
	MOVLW	0x00
	MOVWF	TMR1L
	
	MOVLB	.0
	CLRF	TRISD
	MOVLW	B'11111111'
	MOVWF	LATD
	
	MOVLB	.14
	BCF	PIR4,TMR1IF
	BSF	PIE4,TMR1IE
	
WAIT:	NOP
	GOTO	WAIT
	
INTSUB:	MOVLB	.14
	BCF	PIR4,TMR1IF
	MOVLB	.0
	COMF	LATD,F
	RETFIE
	
	END