# Written by Draco (tytydraco @ GitHub)

HASH := $(shell git rev-parse --short master)
VERSION := $(shell cat module.prop | grep version= | sed "s/version=//")

zip:
	make clean || true
	mkdir -p system/bin/
	for bin in charch cparch lsarch mkarch rmarch unarch ; \
	do \
		curl -Ls https://raw.githubusercontent.com/tytydraco/ChArch/master/bin/$$bin > system/bin/$$bin ; \
		sed -i -e 's|!/usr/bin/env bash|!/system/bin/sh|g' system/bin/$$bin ; \
		sed -i -e 's|\$$HOME/charch|/data/unencrypted/charch|' system/bin/$$bin ; \
		sed -i '3iexport PATH="/sbin/.magisk/busybox:\$$PATH"' system/bin/$$bin ; \
	done
	patch system/bin/charch patch/0001-android-remount-root-suid-exec.patch
	zip -x .git\* patch\* Makefile README.md CONTRIBUTING.md -r9 charch-$(VERSION)_$(HASH).zip .

clean:
	rm *.zip || true
