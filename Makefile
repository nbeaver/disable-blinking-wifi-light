/etc/modprobe.d/iwled.conf : Makefile disable-blinking-wifi-light.sh iwled.conf
	bash disable-blinking-wifi-light.sh

clean :
	sudo rm --force /etc/modprobe.d/iwled.conf
