;***************************************************************************
; EE465: Microcontroller Applications
; Montana State University, Bozeman
; by Aaron Jense
;
; Compares IIC_MSG_RX for keypress of A,B,C,D
; If match found, display pattern by setting PTBD for each index in PATTERN_
; 1 sec delay between each index tracked by PCOUNT and _VTPMOVF interrupt
;****************************************************************************
            INCLUDE 'derivative.inc'

            XDEF FLASH_LED_ARRAY, _VTPMOVF
            XREF _VICC
            XREF IIC_MSG_RX
MY_ZEROPAGE: SECTION  SHORT
			PCOUNT:		DS.B 1
			LENGTH_A:	EQU 1
			LENGTH_B:	EQU	9
			LENGTH_C:	EQU	7
			LENGTH_D:	EQU	11
ROM_VAR: SECTION
			PATTERN_A:	DC.B %10101010

			PATTERN_B:	DC.B %01111111
						DC.B %10111111
						DC.B %11011111
						DC.B %11101111
						DC.B %11110111
						DC.B %11111011
						DC.B %11111101
						DC.B %11111110
									
			PATTERN_C:	DC.B %00011000
						DC.B %00100100
						DC.B %01000010
						DC.B %10000001
						DC.B %01000010
						DC.B %00100100
						DC.B %00011000
								
			PATTERN_D:	DC.B %00111100
						DC.B %00011110
						DC.B %00001111
						DC.B %00000111
						DC.B %00000011
						DC.B %00000001
						DC.B %00000011
						DC.B %00000111
						DC.B %00001111
						DC.B %00011110
						DC.B %00111100
MyCode:     SECTION
main:
FLASH_LED_ARRAY:
		LDHX #0	;inits
		LDX  #0
		LDA  #0
		STA PCOUNT
		STA PTBD
		LDA IIC_MSG_RX ; compare
		CBEQA #'A',LED_A
		CBEQA #'B',LED_B
		CBEQA #'C',LED_C
		CBEQA #'D',LED_D
		RTS	
LED_A:
		LDA PATTERN_A
		STA PTBD
		LDA PCOUNT
		CMP #LENGTH_A
		BNE LED_A
		LDA #0
		STA IIC_MSG_RX
		STA PTBD
		RTS
LED_B:
		LDX	PCOUNT
		LDA PATTERN_B,X
		STA PTBD
		LDA PCOUNT
		CMP #LENGTH_B
		BNE LED_B
		LDA #0
		STA IIC_MSG_RX
		STA PTBD
		RTS
LED_C:
		LDX	PCOUNT
		LDA PATTERN_C,X
		STA PTBD
		LDA PCOUNT
		CMP #LENGTH_C
		BNE LED_C
		LDA #0
		STA IIC_MSG_RX
		STA PTBD
		RTS
LED_D:
		LDX	PCOUNT
		LDA PATTERN_D,X
		STA PTBD
		LDA PCOUNT
		CMP #LENGTH_D
		BNE LED_D
		LDA #0
		STA IIC_MSG_RX
		STA PTBD
		RTS
_VTPMOVF:
		BCLR 7, TPMSC ; must clear TOF flag
		LDA	PCOUNT
		INCA
		STA PCOUNT
		RTI
