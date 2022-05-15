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


mkdir auto &> /dev/null

if [ "$arch" = "amd64" ]; then
    sed -i -e "s/linux64/linux/g" config/hooks/normal/0001-firefox-latest-install.hook.chroot
    sed -i -e "s/linux/linux64/g" config/hooks/normal/0001-firefox-latest-install.hook.chroot
    
    sed -i -e "s/linux64/linux/g" config/includes.chroot/usr/sbin/update-firefox
    sed -i -e "s/linux/linux64/g" config/includes.chroot/usr/sbin/update-firefox
    
    
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
    chmod +x auto/config


elif [ "$arch" = "i386" ]; then
    sed -i -e "s/linux64/linux/g" config/hooks/normal/0001-firefox-latest-install.hook.chroot
    
    sed -i -e "s/linux64/linux/g" config/includes.chroot/usr/sbin/update-firefox

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


echo "You are going to build Debian mate live sytem in $arch."
if [ "$2" != "noquestion" ]; then
    echo -n "Press [ENTER] to start ...."
    read -n1 KEY
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








