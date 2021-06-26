	LIST p=16F18877
	#include<p16F18877.inc>
	
	__CONFIG _CONFIG1, _FEXTOSC_HS & _RSTOSC_EXT1X
	__CONFIG _CONFIG2, _BOREN_ON & _PPS1WAY_OFF
	__CONFIG _CONFIG3, _WDTE_OFF
	__CONFIG _CONFIG5, _CP_OFF & _CPD_OFF
	
D1	EQU	0x20
D2	EQU	0x21
D3	EQU	0x22
ONEIDX	EQU	0x23
	
	ORG	00H
	CLRF	D1
	CLRF	ONEIDX
	
	MOVLB	.17
	MOVLW	0x70
	MOVWF	OSCCON1
	MOVLW	0x04
	MOVWF	OSCFRQ

	MOVLB	.0
	CLRF	TRISD
	BCF	TRISB,1
	BSF	LATB,1
	
START:	MOVF	ONEIDX,W
	CALL	TABLE
	MOVWF	LATD
	CALL	DELAY
	INCF	ONEIDX,F
	MOVLW	.10
	SUBWF	ONEIDX,W
	BTFSS	STATUS,Z
	GOTO	START
	CLRF	ONEIDX
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
	
TABLE:	ADDWF	PCL,F
	RETLW	B'00111111' ;0
	RETLW	B'00000110' ;1
	RETLW	B'01011011' ;2
	RETLW	B'01001111' ;3
	RETLW	B'01100110' ;4
	RETLW	B'01101101' ;5
	RETLW	B'01111101' ;6
	RETLW	B'00000111' ;7
	RETLW	B'01111111' ;8
	RETLW	B'01101111' ;9
	END