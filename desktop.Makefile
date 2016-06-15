all:
	echo "Nothing to do."

install:
	mkdir -p /usr/lib/qmleteroid
	cp *.qml /usr/lib/qmleteroid
	cp lib.py /usr/lib/qmleteroid
	cp qmleteroid.desktop /usr/share/applications

uninstall:
	rm -rfv /usr/lib/qmleteroid
	rm /usr/share/applications/qmleteroid.desktop
