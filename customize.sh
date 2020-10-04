#!/system/bin/sh
# Written by Draco (tytydraco @ GitHub)

set -e

ui_print ""
ui_print " --- ChArch Magisk Module ---"
ui_print ""

ui_print " * Fetching the latest module from GitHub..."
for bin in charch cparch lsarch mkarch rmarch unarch
do
	ui_print " * Fetching $bin..."
	curl -Lso "$MODPATH/system/bin/$bin" "https://raw.githubusercontent.com/tytydraco/ChArch/master/$bin"
done

ui_print " * Patching for use on Android..."
for bin in charch cparch lsarch mkarch rmarch unarch
do
	sed -i -e 's|!/usr/bin/env bash|!/system/bin/sh|g' "$MODPATH/system/bin/$bin"
	sed -i -e 's|\$HOME/charch|/data/unencrypted/charch|' "$MODPATH/system/bin/$bin"
	sed -i '3iexport PATH="/sbin/.magisk/busybox:\$PATH"' "$MODPATH/system/bin/$bin"
done
patch "$MODPATH/system/bin/charch" "$MODPATH/patch/0001-android-remount-root-suid-exec.patch"


ui_print " * Setting executable permissions..."
set_perm_recursive "$MODPATH/system/bin" root root 0777 0755
