# $Id: Makefile 36 2008-06-29 23:46:07Z lybrown $

pilot.run: all
all: pilot.xex pilot-nodos.xex
	mkdir -p bin
	cp $^ bin

pilot.obx: DOS=1
pilot-nodos.obx: DOS=0

boot: disk
	altirra pilot.atr
disk: pilot.atr
pilot.atr: all
	dir2atr -b Dos25 pilot.atr bin

out = > $@~ && mv $@~ $@

atari = altirra

%.run: %.xex
	$(atari) $<

%.xex: %.obx
	cp $< $@

%.obx: %.asm
	xasm /t:$*.lab /l:$*.lst /d:DOS=$(DOS) $<
	perl -pi -e 's/^n /  /' $*.lab

clean:
	rm -f *.{obx,lab,lst,xex} *~

.PRECIOUS: %.obx %.xex %.asm
