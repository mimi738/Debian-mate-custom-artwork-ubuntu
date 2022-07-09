# Introduction

This is a system live debian mate. Included a themes of ubuntu artwork from https://github.com/VentGrey/debian-mate-themes, and add software to work nice for newbie user (vlc, simple-scan, gnome-software, thunderbird and firefox-ESR, chromium, elisa). There are non-free drivers for network connection.

![screenshot](https://ricochets-figeac.fr/iso/capture.png)

This project was born from a fed up with the politics of all snap and flatpack led by canonical. but I wanted a system that was simple for a new linux user.

# Download

You can download the curent build here:
- [i386](https://ricochets-figeac.fr/iso/i386/live-image-i386.hybrid.iso)
- [amd64](https://ricochets-figeac.fr/iso/amd64/live-image-amd64.hybrid.iso)

# Install

To install it easily, download the iso image that corresponds to your hardware architecture (amd64 or i386). And the best thing is to make a bootable USB key to do this I recommend you use [Ventoy](https://www.ventoy.net/en/index.html)  or if you already have a computer with this system installed you can use the program included in it.

![screenshot](https://ricochets-figeac.fr/iso/multiboot.png)

After you can launch your system from this key and install it easily like all live debian systems.

For more information you can look at the [debian documentation](https://www.debian.org/releases/bullseye/installmanual).

# Build

To build this debian live system use docker:

```bash
git clone https://github.com/mimi738/Debian-mate-custom-artwork-ubuntu/
cd Debian-mate-custom-artwork-ubuntu
docker run --privileged -i -v /proc:/proc     -v ${PWD}:/working_dir     -w /working_dir     debian:latest     /bin/bash build.sh
```
 If all goes well you should have an iso image in the current directory.

