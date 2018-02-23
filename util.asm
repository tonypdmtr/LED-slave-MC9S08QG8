;*******************************************************************
; EE465: Microcontroll Applications
; Montana State University, Bozeman
; by Aaron Jense
;
; Simple utility subroutines
;*******************************************************************
            INCLUDE 'derivative.inc'

            XDEF DEBOUNCE_50ms, DELAY
MY_ZEROPAGE: SECTION  SHORT
ROM_VAR: SECTION

MyCode:     SECTION
main:
DELAY:
			JSR DEBOUNCE_50ms
			JSR DEBOUNCE_50ms
			JSR DEBOUNCE_50ms
			JSR DEBOUNCE_50ms
			RTS
DEBOUNCE_50ms:
			LDHX #0
			BRA	DELAY_LOOP
			RTS
DELAY_LOOP:
			AIX	#1
			CPHX #$3013
			BNE	DELAY_LOOP
			RTS
