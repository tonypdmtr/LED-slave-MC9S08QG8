;*******************************************************************
; EE465: Microcontroller Applications
; Montana State University, Bozeman
; by Aaron Jense
;
; I2C using IICC module for receiving keypress from master HCS08.                                         *
;*******************************************************************
            INCLUDE 'derivative.inc'
            XDEF _VICC, SETUP_IIC_SLAVE, IIC_MSG_RX
            XREF main
			XREF _VTPMOVF
MY_ZEROPAGE: SECTION  SHORT
	IIC_MSG_TX:			DS.B 1
	IIC_MSG_RX:			DS.B 1
	TX_CNT:				DS.B 1
	RX_CNT:				DS.B 1
	BAUDRATE:			EQU %10111111 ; (BUSCLK / M*ICR)
ROM_VAR: SECTION
	IIC_SLAVE_ADDR:		DC.B 'B'
MyCode:     SECTION
SETUP_IIC_SLAVE:
			BSET IICC_IICEN, IICC ; enable IIC interface
			MOV #BAUDRATE, IICF	 	; write IICF, sets IIC baud rate
			LDA	IIC_SLAVE_ADDR
			STA	IICA
			BCLR IICC_TX,IICC ; receive mode
			BSET IICC_IICIE, IICC ; interrupt enabled
			RTS		
_VICC:		
			BSET IICS_IICIF, IICS  ; clear the interrupt
			; Slave mode? ; yes
			; Arbitration Lost?
			 BRSET IICS_ARBL, IICS, _VICC_ARB_LOST ; yes
			; no
			; No,Addressed as slave?
			BRSET IICS_IAAS,IICS, _VICC_CHECK_RW ; yes, address transfer
			; no
			BRA	_VICC_GET_MSG ; receive data byte
			RTI
_VICC_CHECK_RW:
			; Slave transmit, master reading from slave?
			BRSET	IICS_SRW,IICS, _VICC_TX_NEXT ; yes
			; no, slave receiving
			BRA _VICC_RX
			RTI
_VICC_RX:
			BCLR IICC_TX, IICC ; Set RX mode
			LDA	IICD ; Dummy read to initiate receiving
			RTI		
_VICC_GET_MSG:
			BCLR IICC_TX, IICC ; Set RX mode
			LDA	IICD
			STA	IIC_MSG_RX
			RTI
_VICC_ARB_LOST:
			BSET IICS_ARBL, IICS ; Clear arbitration flag
			; Addressed as slave?
			BRSET IICS_IAAS,IICS, _VICC_CHECK_RW ; yes
			; no
			RTI
_VICC_TX:
			BSET IICC_TX, IICC; Set TX mode
			; Write data to IICD
			RTI
_VICC_TX_NEXT:
			; ACK from Receiver?
			BRSET IICS_RXAK,IICS, _VICC_RX	; no, switch to RX
			; yes
			BSET IICC_TX, IICC; Set TX mode
			; Write data to IICD
			RTI
