#!/bin/bash
# https://m0aws.co.uk/?p=2201 (GO: 2023-11-08)
devName="/dev/input/by-id/usb-Griffin_Technology__Inc._Griffin_PowerMate-event-if00"
sudo /usr/bin/evtest ${devName} | while read LINE
do
    case $LINE in
        *"(REL_DIAL), value 1") echo "wheel -1" | dotoolc ;;
        *"(REL_DIAL), value -1") echo "wheel 1" | dotoolc ;;
        *"(BTN_0), value 1") echo "click" ;;
    esac
done
