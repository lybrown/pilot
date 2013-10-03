    icl 'hardware.asm'
    icl 'sysfull.asm'
    org $600
    ; disable BASIC
    lda PORTB
    ora #2
    sta PORTB
    ; http://www.atariarchives.org/c2bag/page211.php
    ; RAMTOP=$9E
    mva #$9E RAMTOP
    sta RAMSIZ
    ; http://atariage.com/forums/topic/127483-atari-os-and-hardware-manuals-get-them-here/
    ; GRAPHICS 0
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
    org $A000
    ; http://atariage.com/forums/topic/217239-looking-for-an-xex-version-of-atari-pilot-language-for-xl/
    ins 'pilot.bin'
    org $600
    ; http://wiki.strotmann.de/wiki/Wiki.jsp?page=Cartridges
    ; CART INIT
    jsr init
    ; CART RUN
    jmp ($BFFA)
init
    jmp ($BFFE)
    run $600
