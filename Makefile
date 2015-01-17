# -----------------------------------------------------------------------------
# makefile for the ergoDOX project
#
# This should produce a single file (probably in an archive format) for
# distribution, containing everything people will need to use the software.
#
# DEPENDENCIES:  This is unabashedly dependant on (the GNU implementation of)
# various Unix commands, and therefore probably won't work in a Windows
# environment (besides maybe cygwin).  Sorry...  I don't know a good portable
# way to write it.
#
# TODO:
# - include doc files (and maybe render them in html)
# - include the UI stuff (once it's done)
# -----------------------------------------------------------------------------
# Copyright (c) 2012 Ben Blazak <benblazak.dev@gmail.com>
# Released under The MIT License (MIT) (see "license.md")
# Project located at <https://github.com/benblazak/ergodox-firmware>
# -----------------------------------------------------------------------------

# which layouts to compile (will override the variable in src/makefile-options)
# --- default
LAYOUT := qwerty-kinesis-mod
# --- all
LAYOUTS := qwerty-kinesis-mod dvorak-kinesis-mod colemak-symbol-mod workman-p-kinesis-mod

# name to use for the final distribution file or package
TARGET := ergodox-firmware--$(LAYOUT)

# directories
BUILD := build
ROOT := $(BUILD)/$(TARGET)
SCRIPTS := build-scripts

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

.PHONY: all clean checkin build-dir firmware dist zip zip-all

all: dist

clean:
	cd src; $(MAKE) clean
	-rm -rf '$(BUILD)'

build-dir:
	-rm -r '$(BUILD)/$(TARGET)'*
	-mkdir -p '$(BUILD)/$(TARGET)'

firmware:
	cd src; $(MAKE) LAYOUT=$(LAYOUT) all

$(ROOT)/firmware.%: firmware
	cp 'src/firmware.$*' '$@'

dist: \
	checkin \
	build-dir \
	$(ROOT)/firmware.hex \
	$(ROOT)/firmware.eep \
	$(ROOT)/firmware.map \

zip: dist
	( cd '$(BUILD)/$(TARGET)'; \
	  zip '../$(TARGET).zip' \
	      -r * .* \
	      -x '..*' )

zip-all:
	for layout in $(LAYOUTS); do \
		make LAYOUT=$$layout zip; \
	done

