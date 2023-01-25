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
else
    echo "1. gnome"
    echo "2. mate"
    echo -n "Select your Desktop : "
    read -r answer
    case $answer in
        [1]* ) arch="gnome";;
        [2]* ) arch="mate";;
        * ) echo "Not Desktop selected !"; exit 1;;
    esac	
fi

mkdir auto &> /dev/null

if [ "$arch" = "amd64" ]; then

    cat <<'EOF' >auto/config
#!/bin/sh

lb config noauto \
	--clean \
	--architectures amd64 \
	--mode debian \
	--distribution  bullseye \
	--initramfs live-boot \
	--archive-areas "main contrib non-free" \
	--linux-flavours "amd64" \
	--linux-packages "linux-image" \
	--source "false" \
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
	--distribution  bullseye \
	--initramfs live-boot \
	--archive-areas "main contrib non-free" \
	--linux-flavours "686 686-pae" \
	--linux-packages "linux-image" \
	--source "false" \
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


#Configure if is mate or gnome live system

if [ "$desktop" = "gnome" ]; then

#Del include chroot
    rm -r config/includes.chroot/usr/share/applications
    rm -r config/includes.chroot/usr/share/backgrounds
    rm -r config/includes.chroot/usr/share/gtksourceview-2.0
    rm -r config/includes.chroot/usr/share/gtksourceview-3.0
    rm -r config/includes.chroot/usr/share/gtksourceview-4
    rm -r config/includes.chroot/usr/share/icons
    rm -r config/includes.chroot/usr/share/mate-panel
    rm -r config/includes.chroot/usr/share/plymouth
    rm -r config/includes.chroot/usr/share/themes
#del conf desktop mate
    rm config/hooks/normal/0003-install-dconf-theme-config.hook.chroot
#del mate packages list
    rm config/package-lists/mate.list.chroot
   
elif [ "$desktop" = "mate" ]; then
    rm config/package-lists/gnome.list.chroot
else
then
    exit 1;
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








