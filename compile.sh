#!/bin/sh -e
if [ ! -f collapseos/README ]; then
	git submodule init
	git submodule update
fi
cd collapseos
if [ ! -f tools/blkpack ]; then
	git stash push --all
	cd tools
	make blkpack
	cd ../cvm
	make stage
	cd ..
fi
cd ..
collapseos/tools/blkpack < collapseos/blk.fs > blkfs
collapseos/cvm/stage blkfs <xcomp.fs >collapseos.bin
uxnasm collapseos.tal collapseos.rom
uxnasm cos-lite.tal cos-lite.rom
cat common.tal cos-lite.tal >cos-lite-old.tal
patch <cos-lite-old.patch
uxnasm-old cos-lite-old.tal cos-lite-old.rom
cat collapseos.bin >>cos-lite.rom
cat collapseos.bin >>cos-lite-old.rom