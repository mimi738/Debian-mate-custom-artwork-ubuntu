# Introduction

This is a system live debian. Add software to work nice for newbie user (vlc, simple-scan, gnome-software, thunderbird and firefox-ESR, chromium, elisa). There are non-free drivers for network connection.

For this moment there are two system desktop mate and gnome.

![screenshot](https://ricochets-figeac.fr/iso/capture.png)

![screenshot](https://ricochets-figeac.fr/iso/capture-gnome.png)

This project was born from a fed up with the politics of all snap and flatpack led by canonical. but I wanted a system that was simple for a new linux user.

# Download

You can download the curent build here:
- [Mate] [i386](https://ricochets-figeac.fr/iso/files/Debian-12-mate-i386.hybrid.iso)
- [Mate] [amd64](https://ricochets-figeac.fr/iso/files/Debian-12-mate-amd64.hybrid.iso)

You can download the curent build here:
- [Gnome] [i386](https://ricochets-figeac.fr/iso/files/Debian-12-gnome-i386.hybrid.iso)
- [Gnome] [amd64](https://ricochets-figeac.fr/iso/files/Debian-12-gnome-amd64.hybrid.iso)

# Install

To install it easily, download the iso image that corresponds to your hardware architecture (amd64 or i386). And the best thing is to make a bootable USB key to do this I recommend you use [Ventoy](https://www.ventoy.net/en/index.html).

![screenshot](https://ricochets-figeac.fr/iso/multiboot.png)

![screenshot](https://ricochets-figeac.fr/iso/multiboot-gnome.png)

After you can launch your system from this key and install it easily like all live debian systems.

For more information you can look at the [debian documentation](https://www.debian.org/releases/bullseye/installmanual).

# Build

To build this debian live system use docker:

```bash
git clone https://github.com/mimi738/Debian-mate-custom-artwork-ubuntu/
cd Debian-mate-custom-artwork-ubuntu
docker run --privileged -i -v /proc:/proc     -v ${PWD}:/working_dir     --name live-build-iso -w /working_dir     debian:latest     /bin/bash build.sh
```
 If all goes well you should have an iso image in the current directory.

