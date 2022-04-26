# Introduction

This is a system live debian mate. Included a themes of ubuntu artwork from https://github.com/VentGrey/debian-mate-themes, and add software to work nice for newbie user (vlc, simple-scan, gnome-software, thunderbird and firefox). There are non-free drivers for network connection.

For the moment this system is available only in i386 it was thought to compensate for the fact that ubuntu does not maintain i386. But it can easily be used to build an amd64 system.

# Build

To build this debian live system use docker:

```bash
$ docker run --privileged -i -v /proc:/proc     -v ${PWD}:/working_dir     -w /working_dir     debian:latest     /bin/bash build.sh
```
