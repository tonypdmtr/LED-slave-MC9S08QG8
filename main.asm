;*******************************************************************************
; EE465: Microcontroller Applications
; Montana State University, Bozeman
; by Aaron Jense
;
; Slave HCS08 receives keypress through I2C and flashes LED bar pattern
;*******************************************************************************
                    #Uses     qg8.inc
                    #Uses     iic.sub
                    #Uses     led_bar.sub
                    #Uses     tpm.sub
                    #Uses     util.sub
;*******************************************************************************

_Startup            proc
                    ldhx      #STACKTOP           ; initialize the stack pointer
                    txs
                    cli                           ; enable interrupts
                    bsr       Setup_SOPT1
                    bsr       Setup_IO
                    jsr       Setup_IIC_SLAVE
                    bsr       Setup_TPM
MainLoop@@          jsr       FLASH_LED_ARRAY
                    bra       MainLoop@@

;*******************************************************************************

Setup_SOPT1         proc
                    lda       SOPT1               ; disable watchdog
                    and       #%01111111
                    sta       SOPT1
                    rts

;*******************************************************************************

Setup_IO            proc
                    lda       #%11111111          ; PTBD set to output for LED BAR
                    sta       PTBDD
                    lda       #%00000000
                    sta       PTADD
                    rts
