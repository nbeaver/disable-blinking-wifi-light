#! /usr/bin/env bash

if ! id | grep sudo > /dev/null
then
    printf "Warning: you do not have sudo privileges.\n" 1>&2
fi

# Turn off blinking wifi light.
# https://askubuntu.com/questions/12069/how-to-stop-constantly-blinking-wifi-led/

# TODO: make it work with these as well:
# options ipw2200 led=0
# options ath9k blink=0

# led_mode:
# 0=system default
# 1=On(RF On)/Off(RF Off)
# 2=blinking
# 3=Off

wifi_modules=( iwlwifi iwlegacy iwl-legacy iwlagn iwlcore )
for module in "${wifi_modules[@]}"
do
    if ! test -d "/sys/module/$module"
    then
        # Module not loaded, so skip it.
        continue
    fi
    printf "Found module '%s'\n" "$module" >&2
    if test '1' -eq "$(cat /sys/module/$module/parameters/led_mode)"
    then
        printf 'Warning: led_mode is already 1 for driver "%s".\n' "${module}" 1>&2
    fi
    # Work with the first module we find.
    break
done

if ! test -d '/etc/modprobe.d/'
then
    if ! sudo mkdir -p '/etc/modprobe.d/'
    then
        printf "Error: could not create directory /etc/modprobe.d/\n" 1>&2
        exit 1
    fi
fi

TARGET='/etc/modprobe.d/iwled.conf'
SOURCE='iwled.conf'

if ! test -f "$SOURCE"
then
    printf 'Error: cannot find "%s"\n' "${SOURCE}" 1>&2
    exit 1
fi

if test -f "$TARGET"
then
    printf 'Error: target "%s" already exists.\n' "${TARGET}" 1>&2
    exit 1
fi

if ! sudo cp -- "$SOURCE" "$TARGET"
then
    printf "Error: could not copy'%s' to '%s'\n" "$SOURCE" "${TARGET}" >&2
    exit 1
fi

if ! sudo modprobe --remove --verbose "$module"
then
    printf 'Warning: Could not remove module "%s". Try rebooting to make changes.\n' "${module}" 1>&2
    exit 0
fi

if ! sudo modprobe "$module"
then
    printf 'Warning: Could not add module "%s". Try rebooting to make changes.\n' "${module}" 1>&2
fi
