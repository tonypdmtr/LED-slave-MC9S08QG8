;**********************************************************************
; EE465: Microcontroller Applications
; Montana State University, Bozeman
; by Aaron Jense
;
; Slave HCS08 receives keypress through I2C and flashes LED bar pattern                                          *
;**********************************************************************		
			INCLUDE 'derivative.inc'
      
            XDEF _Startup, main
            XREF __SEG_END_SSTACK
            XREF SETUP_TPM, SETUP_IIC_SLAVE
            XREF FLASH_LED_ARRAY
			XREF _VIIC, _VTPMOVF		
MY_ZEROPAGE: SECTION  SHORT
ROM_VAR: SECTION	

MyCode:     SECTION
main:
_Startup:
            LDHX #__SEG_END_SSTACK ; initialize the stack pointer
            TXS
			CLI	; enable interrupts
			JSR	SETUP_SOPT1
			JSR	SETUP_IO
			JSR SETUP_IIC_SLAVE
			JSR SETUP_TPM
			BRA mainLoop
mainLoop:
			JSR FLASH_LED_ARRAY
            BRA	mainLoop                 	
SETUP_SOPT1:
			LDA SOPT1 ; disable watchdog
			AND #%01111111
			STA SOPT1		
			RTS
SETUP_IO:
			LDA	#%11111111 ; PTBD set to output for LED BAR
			STA PTBDD
			LDA #%00000000 
			STA PTADD
			RTS
