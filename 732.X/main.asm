  	LIST p=16F18877
	#include<p16F18877.inc>
	
	__CONFIG _CONFIG1, _FEXTOSC_HS & _RSTOSC_EXT1X
	__CONFIG _CONFIG2, _BOREN_ON & _PPS1WAY_OFF
	__CONFIG _CONFIG3, _WDTE_OFF
	__CONFIG _CONFIG5, _CP_OFF & _CPD_OFF
	
IDX	EQU	0x20
T1CNT	EQU	0x21
ONEIDX	EQU	0x22
TENIDX	EQU	0x23
	
	ORG	00H
	GOTO	START
	ORG	04H
	GOTO	INTSUB
	
START:	CLRF	IDX
	CLRF    ONEIDX
	CLRF	TENIDX
	
	MOVLB	.17
	MOVLW	0x70
	MOVWF	OSCCON1
	MOVLW	0x04
	MOVWF	OSCFRQ
	
	MOVLB	.11
	BSF	INTCON,GIE
	BSF	INTCON,PEIE
	
	MOVLB	.0
	MOVLW	0x80
	MOVWF	T0CON0
	MOVLW	0x47
	MOVWF	T0CON1
	MOVLW	0xE9
	MOVWF	TMR0H
	MOVLW	0x00
	MOVWF	TMR0L
	
	MOVLB	.4
	MOVLW	0x31
	MOVWF	T1CON
	MOVLW	0x01
	MOVWF	T1CLK
	MOVLW	0x6D
	MOVWF	TMR1H
	MOVLW	0x84
	MOVWF	TMR1L
	
	MOVLB	.0
	MOVLW	B'11111001'
	MOVWF	TRISB
	CLRF	TRISD
	MOVLW	B'11111111'
	MOVWF	LATD
	
	MOVLB	.14
	BCF	PIR0,TMR0IF
	BSF	PIE0,TMR0IE
	BCF	PIR4,TMR1IF
	BSF	PIE4,TMR1IE
	
WAIT:	NOP
	GOTO	WAIT
	
INTSUB:	MOVLB	.14
	BTFSS	PIR0,TMR0IF
	GOTO	T1A
T0A:
	MOVLB	.0
	BTFSC	IDX,0
	GOTO	TENTBL
ONETBL:
	MOVLB	.0
	BSF	LATB,1
	BCF	LATB,2
	MOVF	ONEIDX,W
	CALL	TABLE
	MOVWF	LATD
	COMF	IDX,F
T01:
	MOVLB	.14
	BCF	PIR0,TMR0IF
	MOVLB	.0
	MOVLW	0xE9
	MOVWF	TMR0H
	MOVLW	0x00
	MOVWF	TMR0L
	RETFIE
TENTBL:
	MOVLB	.0
	BCF	LATB,1
	BSF	LATB,2
	MOVF	TENIDX,W
	CALL	TABLE
	MOVWF	LATD
	CLRF	IDX
	GOTO	T01
T1A:
	MOVLB	.4
	DECFSZ	T1CNT,F
	GOTO	T18
T11:
	MOVLB	.4
	MOVLW	.5
	MOVWF	T1CNT
T12:
	MOVLB	.0
	INCF	ONEIDX,F
T13:
	MOVLB	.0
	MOVLW	.10
	SUBWF	ONEIDX,W
	BTFSS	STATUS,Z
	GOTO	T18
T14:
	MOVLB	.0
	CLRF	ONEIDX
T15:
	MOVLB	.0
	INCF	TENIDX,F
T16:
	MOVLB	.0
	MOVLW	.10
	SUBWF	TENIDX,W
	BTFSS	STATUS,Z
	GOTO	T18
T17:
	MOVLB	.0
	CLRF	TENIDX
T18:
	MOVLB	.14
	BCF	PIR4,TMR1IF
	MOVLB	.4
	MOVLW	0x6D
	MOVWF	TMR1H
	MOVLW	0x84
	MOVWF	TMR1L
	RETFIE
	
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