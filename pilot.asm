    icl 'hardware.asm'
    icl 'sysfull.asm'
    org $600
    mva #$9E RAMTOP
    sta RAMSIZ
    ldx #$60
    mwa #dev ICBAL,X
    mva #OPEN ICCOM,X
    mva #%00001100 ICAX1,x
    mva #0 ICAX2,x
    jsr CIOV
    bmi error
    rts
error
    sei
    mva #0 NMIEN
    mva #$30 COLBAK
    jmp *
dev
    dta c'S:',0
    ini $600
    rts
    org $A000
    ins 'pilot.bin'
    org $600
    jsr init
    jmp ($BFFA)
init
    jmp ($BFFE)
    run $600
