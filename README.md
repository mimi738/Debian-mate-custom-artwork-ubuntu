# Introduction

This is a system live debian mate. Included a themes of ubuntu artwork from https://github.com/VentGrey/debian-mate-themes, and add software to work nice for newbie user (vlc, simple-scan, gnome-software, thunderbird and firefox-ESR, chromium). There are non-free drivers for network connection.

This project was born from a fed up with the politics of all snap and flatpack led by canonical. but I wanted a system that was simple for a new linux user.
# Download

You can download the curent build here:
- [i386](https://ricochets-figeac.fr/iso/i386/live-image-i386.hybrid.iso)
- [amd64](https://ricochets-figeac.fr/iso/amd64/live-image-amd64.hybrid.iso)

# Build

To build this debian live system use docker:

```bash
$ docker run --privileged -i -v /proc:/proc     -v ${PWD}:/working_dir     -w /working_dir     debian:latest     /bin/bash build.sh
```
