#! /usr/bin/env bash

if ! id | grep sudo > /dev/null
then
    printf "Error: you do not have sudo privileges.\n" 1>&2
    exit 1
fi

# Turn off blinking wifi light.
# https://askubuntu.com/questions/12069/how-to-stop-constantly-blinking-wifi-led/

if ! test -d '/etc/modprobe.d/'
then
    if ! sudo mkdir -p '/etc/modprobe.d/'
    then
        printf "Error: could not create directory /etc/modprobe.d/\n" 1>&2
        exit 1
    fi
fi

config_file='/etc/modprobe.d/iwled.conf'

if test -f "$config_file"
then
    printf "Error: ‘$config_file’ already exists.\n" 1>&2
    exit 1
fi

for i in {0..9} # it's not always wlan0
do
    if test -e "/sys/class/net/wlan$i/device/driver"
    then
        module="$(basename $(readlink /sys/class/net/wlan$i/device/driver))"
        break
    fi
done


if test -z $module
then
    printf "Error: Could not detect wifi driver name.\n" 1>&2
    exit 1
fi

if ! test -f "/sys/module/$module/parameters/led_mode"
then
    printf "Error: driver ‘$module’ does not have ‘led_mode’ parameter.\n" 1>&2
    exit 1
fi
# TODO: make it work with these as well:
# options ipw2200 led=0
# options ath9k blink=0


# led_mode:
# 0=system default
# 1=On(RF On)/Off(RF Off)
# 2=blinking
# 3=Off
if test '1' -eq $(cat /sys/module/$module/parameters/led_mode)
then
    printf "Warning: led_mode is already 1 for driver ‘$module’.\n" 1>&2
fi

if sudo cp 'iwled.conf' "$config_file"
then
    if sudo modprobe --remove "$module"
    then
        if sudo modprobe "$module"
        then
            exit 0
        else
            printf "Could not add module $module. Try rebooting to make changes.\n" 1>&2
        fi
    else
        printf "Could not remove module $module. Try rebooting to make changes.\n" 1>&2
        exit 0
    fi
else
    printf "Error: could not write to $config_file\n" 1>&2
    exit 1
fi
