The core of this solution is thanks to: https://www.gilesorr.com/blog/powermate-on-linux.html

# Griffin Powermate on Linux

The Griffin Powermate is a USB knob that can be used for various purposes. Originally marketed as a volume knob, you can map it to any function you like. (I use it as a mouse scroll wheel for my non-mouse hand.)

## Overview

This solution uses the `evtest` program to read the input from the Powermate and then uses `dotool` to simulate keyboard/mouse events.

This repo contains:
* `powermate.sh` - a script that reads the Powermate input using `evtest` and sends mouse/keyboard events via `dotoolc`
* `dotoold.service` - starts the `dotoold` daemon that listens for commands from the `dotoolc` client program.
* `powermate.service` - starts the `powermate.sh` script as a user service.
* `99-powermate.rules` - a udev rule that starts the `powermate.service` when the Powermate is plugged in.

I developed and tested this on Arch Linux with the Wayland display server.

### What if I'm not using Wayland?

If you're using Xorg, you can use xdotool instead of dotool.

### What if I'm not using systemd?

Yeah. I don't love it either. You can do all of this from `udev`.

If you write a script that kills the `powermate.sh` process when the Powermate is unplugged, you can specify that in your udev rule instead.

## Installation

Install `evtest` and `dotool` (or `xdotool`) for your distro.

Create the systemd user directory:
```sh
mkdir -p ~/.config/systemd/user
```

Copy the services to the systemd user directory:
```sh
cp *.service ~/.config/systemd/user/
```

Copy the powermate.sh script to `~/bin/` (or `/usr/local/bin` or wherever you prefer):
```sh
cp powermate.sh ~/bin/
```

Copy the udev rule to `/etc/udev/rules.d/`:
```sh
sudo cp 99-powermate.rules /etc/udev/rules.d/
```

## Configure

Double check the `idProduct` and `idVendor` in the udev rule to make sure they match your Powermate. Use the following command to find the `idProduct` and `idVendor`:

```sh
udevadm info -a -p $(udevadm info -q path -n /dev/input/by-id/usb-Griffin_Technology__Inc._Griffin_PowerMate-event-if00)
```

Edit the `.service` files to point to the correct paths for `powermate.sh` and `dotoold`.

Edit the udev rule and put your username in place of `<your-username>`.

## Enable and start the udev rule and systemd services

Reload the udev rules:
```sh
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Enable and start the systemd services:
```sh
systemctl --user daemon-reload
systemctl --user enable dotoold.service
systemctl --user enable powermate.service
```

## Usage

At this point, you can either:
* Manually start the services with `systemctl --user start dotoold.service` and `systemctl --user start powermate.service`
* Log out and back in to start the services automatically

## Debugging

To see what's going on with the `powermate.sh` script, you can run `journalctl --user -u powermate.service -f`.

And to see what's going on with the udev rule, you can run `sudo journalctl -f -u systemd-udevd`.
