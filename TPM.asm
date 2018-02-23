;*******************************************************************
; EE465: Microcontroller Applications
; Montana State University, Bozeman
; by Aaron Jense
;
; Set up a 1 second timer interrupt for LED pattern timing                                          *
;*******************************************************************
            INCLUDE 'derivative.inc'
            
            XDEF SETUP_TPM
            
MY_ZEROPAGE: SECTION  SHORT
ROM_VAR: SECTION

MyCode:     SECTION
main:
SETUP_TPM:
; --------- Timer Status and Control Register ---------
; Bit 6 is TOIE and allows for interrupt when TOF is 1
; bit 4:3 is CLKSB:CLKSA set to 0:1 for BUSCLK
; Bit 2:1:0 is PS2:PS1:PS0 set to 1:1:1 for prescaler 128
; -----------------------------------------------------
		     MOV #%01001111, TPMSC
; --------- Timer Counter Modulo Register ------------
; Ftof = Fsource / (Prescaler * (TPMMOD+1))
; -----------------------------------------------------
			LDHX #$7A12	; 31250 decimal, used for 1 sec delay when TPMSC prescaler is 111
			STHX TPMMOD
			RTS
