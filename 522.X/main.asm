	LIST p=16F18877
	#include<p16F18877.inc>
	
	__CONFIG _CONFIG1, _FEXTOSC_HS & _RSTOSC_EXT1X
	__CONFIG _CONFIG2, _BOREN_ON & _PPS1WAY_OFF
	__CONFIG _CONFIG3, _WDTE_OFF
	__CONFIG _CONFIG5, _CP_OFF & _CPD_OFF
	
D1	EQU	0x20
D2	EQU	0x21
D3	EQU	0x22
	
	ORG	00H
	MOVLB	.17
	MOVLW	0x70
	MOVWF	OSCCON1
	MOVLW	0x04
	MOVWF	OSCFRQ

	MOVLB	.0
	CLRF	TRISD
	BCF	TRISB,1
	BSF	LATB,1
	
START:	MOVLW	B'00111111' ;0
	MOVWF	LATD
	CALL	DELAY
	MOVLW	B'00000110' ;1
	MOVWF	LATD
	CALL	DELAY
	MOVLW	B'01011011' ;2
	MOVWF	LATD
	CALL	DELAY
	MOVLW	B'01001111' ;3
	MOVWF	LATD
	CALL	DELAY
	MOVLW	B'01100110' ;4
	MOVWF	LATD
	CALL	DELAY
	MOVLW	B'01101101' ;5
	MOVWF	LATD
	CALL	DELAY
	MOVLW	B'01111101' ;6
	MOVWF	LATD
	CALL	DELAY
	MOVLW	B'00000111' ;7
	MOVWF	LATD
	CALL	DELAY
	MOVLW	B'01111111' ;8
	MOVWF	LATD
	CALL	DELAY
	MOVLW	B'01101111' ;9
	MOVWF	LATD
	CALL	DELAY
	GOTO	START
	
DELAY:	MOVLW	.8
	MOVWF	D3
DLY1:	MOVLW	.244
	MOVWF	D2
DLY2:	DECFSZ	D1,F
	GOTO	DLY2
	DECFSZ	D2,F
	GOTO	DLY2
	DECFSZ	D3,F
	GOTO	DLY1
	RETURN
	END