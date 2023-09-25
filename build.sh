#!/bin/bash


#Select arch

if [ "$1" = "amd64" ]; then
	arch="amd64"
elif [ "$1" = "i386" ]; then
	arch="i386"
else
    echo "1. amd64"
    echo "2. i386"
    echo -n "Select your system architecture: "
    read -r answer
    case $answer in
        [1]* ) arch="amd64";;
        [2]* ) arch="i386";;
        * ) echo "Not arch selected !"; exit 1;;
    esac	
fi

if [ "$2" = "gnome" ]; then
	desktop="gnome"
elif [ "$2" = "mate" ]; then
	desktop="mate"
elif [ "$2" = "openbox" ]; then
	desktop="openbox"
else
    echo "1. Gnome"
    echo "2. Mate"
    echo "3. Openbox"
    echo -n "Select your Desktop : "
    read -r answer
    case $answer in
        [1]* ) desktop="gnome";;
        [2]* ) desktop="mate";;
        [3]* ) desktop="openbox";;
        * ) echo "Not Desktop selected !"; exit 1;;
    esac	
fi

NAME="Debian-live.$desktop-$arch"

mkdir auto &> /dev/null

if [ "$arch" = "amd64" ]; then

    cat <<'EOF' >auto/config
#!/bin/sh

lb config noauto \
	--clean \
	--architectures amd64 \
	--mode debian \
	--distribution  bookworm \
	--initramfs live-boot \
	--archive-areas "main contrib non-free non-free-firmware" \
	--linux-flavours "amd64" \
	--linux-packages "linux-image" \
	--source "false" \
	--iso-application "$NAME" \
    --iso-volume "$NAME" \
	--checksums md5 \
"${@}"   
EOF
    chmod +x auto/config


elif [ "$arch" = "i386" ]; then

    cat <<'EOF' >auto/config
#!/bin/sh

lb config noauto \
	--clean \
	--architectures i386 \
	--mode debian \
	--distribution  bookworm \
	--initramfs live-boot \
	--archive-areas "main contrib non-free non-free-firmware" \
	--linux-flavours "686 686-pae" \
	--linux-packages "linux-image" \
	--source "false" \
	--iso-application "$NAME" \
    --iso-volume "$NAME" \
	--checksums md5 \
"${@}"   
EOF

    chmod +x auto/config

fi

#Creat a list of package deleting whith calamares install

mkdir -p config/includes.chroot/etc/calamares/modules/
    
cat <<'EOF' >config/includes.chroot/etc/calamares/modules/packages.conf
backend: apt

operations:
  - remove:
EOF

for pkg in $(sed -e '/^[ ]*#/d' -e '/^$/d' config/package-lists/live.list.chroot_live)
do
    echo "      -   '$pkg'" >> config/includes.chroot/etc/calamares/modules/packages.conf
done
echo "      -   'localamares'" >> config/includes.chroot/etc/calamares/modules/packages.conf


echo "You are going to build Debian $desktop live sytem in $arch."
if [ "$3" != "noquestion" ]; then
    echo -n "Press [ENTER] to start ...."
    read -n1 KEY
    if [[ "$KEY" != "" ]]
    then
        exit 1;
    fi
fi


#Configure if is mate, xfce or gnome live system

if [ "$desktop" = "gnome" ]; then

#del mate packages list
    rm config/package-lists/mate.list.chroot
    rm config/package-lists/openbox.list.chroot
   
elif [ "$desktop" = "mate" ]; then
    rm config/package-lists/gnome.list.chroot
    rm config/package-lists/openbox.list.chroot
    rm config/includes.chroot/usr/share/firefox-esr/distribution/extensions/chrome-gnome-shell@gnome.org.xpi
    
elif [ "$desktop" = "openbox" ]; then
    rm config/package-lists/mate.list.chroot
    rm config/package-lists/gnome.list.chroot
fi

#Start Build System

echo "Installing dependencies to build system"
apt-get update
apt-get install -y live-build patch gnupg2 binutils zstd

echo "Clean directory"
lb clean


echo "Build System"
lb config 
lb build








