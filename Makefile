# Written by Draco (tytydraco @ GitHub)

zip:
	make clean || true
	zip -x .git\* Makefile -r9 charch-magisk-module.zip .

clean:
	rm *.zip || true
