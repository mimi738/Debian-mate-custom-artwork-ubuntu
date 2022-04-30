#!/bin/bash


#Select arch

if [ "$1" = "amd64" ]; then
	arch="amd64"
elif [ "$1" = "i386" ]; then
	arch="i386"
else
    echo "1. amd64"
    echo "2. i386"
    read -r -p "Select your system architecture: " answer
    case $answer in
        [1]* ) arch="amd64";;
        [2]* ) arch="i386";;
        * ) echo "Not arch selected !"; exit 1;;
    esac	
fi


mkdir auto &> /dev/null

if [ "$arch" = "amd64" ]; then
    sed -i -e "s/linux64/linux/g" config/hooks/normal/0001-firefox-latest-install.hook.chroot
    sed -i -e "s/linux/linux64/g" config/hooks/normal/0001-firefox-latest-install.hook.chroot
    cat <<'EOF' >auto/config
#!/bin/sh

lb config noauto \
	--clean \
	--architectures amd64 \
	--mode debian \
	--distribution  bullseye \
	--initramfs live-boot \
	--archive-areas "main contrib non-free" \
	--debian-installer live \
	--linux-flavours "amd64" \
	--linux-packages "linux-image" \
	--source "false" \
"${@}"   
EOF


elif [ "$arch" = "i386" ]; then
    sed -i -e "s/linux64/linux/g" config/hooks/normal/0001-firefox-latest-install.hook.chroot

    cat <<'EOF' >auto/config
#!/bin/sh

lb config noauto \
	--clean \
	--architectures i386 \
	--mode debian \
	--distribution  bullseye \
	--initramfs live-boot \
	--archive-areas "main contrib non-free" \
	--debian-installer live \
	--linux-flavours "686 686-pae" \
	--linux-packages "linux-image" \
	--source "false" \
"${@}"   
EOF

fi


echo "You are going to build Debian mate live sytem in $arch."
if [ "$2" != "noquestion" ]; then
    read -n1 -p "Press [ENTER] to start ...." KEY
    if [[ "$KEY" != "" ]]
    then
        exit 1;
    fi
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








