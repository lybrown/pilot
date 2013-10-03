# $Id: Makefile 36 2008-06-29 23:46:07Z lybrown $

pilot.run:

out = > $@~ && mv $@~ $@

atari = altirra

%.dfl: %
	gzip -c -9 $< | ./gzip2deflate $(out)

%.run: %.xex
	$(atari) $<

%.xex: %.obx
	cp $< $@

%.boot: %.atr
	$(atari) $<

%.atr: %.obx obx2atr
	./obx2atr $< $(out)

%.asm.pl: %.asm.pp
	echo 'sub interp {($$_=$$_[0])=~s/<<<(.*?)>>>/eval $$1/ge;print}' > $@
	perl -pe 's/^\s*>>>// or s/(.*)/interp <<'\''EOF'\'';\n$$1\nEOF/;' $< >> $@

%.asm: %.asm.pl
	perl $< $(out)
	
%.obx: %.asm
	#mads -t:$*.lst -l:$*.listing $<
	xasm /t:$*.lab /l:$*.lst $<
	perl -pi -e 's/^n /  /' $*.lab

clean:
	rm -f *.{obx,atr,lst,listing,dfl,xex,asm.pl} *~ shoot.asm

.PRECIOUS: %.obx %.lis %.atr %.xex %.ppm %.apac %.asm
