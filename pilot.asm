    icl 'hardware.asm'
    icl 'sysfull.asm'
    org $600
dev
    dta c'S:',0
error
    sei
    mva #0 NMIEN
    mva #$30 COLBAK
    jmp *
copy
    ; disable OS
    sei
    mvx #0 NMIEN
    lda PORTB
    and #$FE
    sta PORTB
    ; copy 8K
    ldy #$20
copy_src
    lda $FFFF,x
copy_dst
    sta $FFFF,x
    inx
    bne copy_src
    inc copy_src+2
    inc copy_dst+2
    dey
    bne copy_src
    ; enable OS
    lda PORTB
    ora #1
    sta PORTB
    mva #$40 NMIEN
    cli
    rts
reserve_ram
    ; http://www.atariarchives.org/c2bag/page211.php
    ; RAMTOP=$A0
    mva #$A0 RAMTOP
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
    ; Disable BASIC
    lda PORTB
    ora #2
    sta PORTB
    rts
xexrun
    ; copy to high ram
    mwa #$A000 copy_src+1
    mwa #$D800 copy_dst+1
    jsr copy
    ; trap RESET
    ; http://www.atariarchives.org/dere/chapt08.php
    ift DOS
    mwa DOSINI call_old_dosini+1
    eif
    mwa #reset DOSINI
    ift DOS
    jmp call_old_dosini
    els
    jmp main
    eif
reset
    jsr reserve_ram
    ; copy from high ram
    mwa #$D800 copy_src+1
    mwa #$A000 copy_dst+1
    jsr copy
    ift DOS
call_old_dosini
    jsr $FFFF
    eif
main
    ; http://wiki.strotmann.de/wiki/Wiki.jsp?page=Cartridges
    ; CART INIT
    jsr init
    ; CART RUN
    jmp ($BFFA)
init
    jmp ($BFFE)

    ini reserve_ram

    org $A000
    ; http://atariage.com/forums/topic/217239-looking-for-an-xex-version-of-atari-pilot-language-for-xl/
    ins 'pilot.bin'

    run xexrun
