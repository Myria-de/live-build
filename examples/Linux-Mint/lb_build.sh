sudo lb config \
--mode "ubuntu" \
--architecture "amd64" \
--apt-options "--yes --allow-remove-essential" \
--apt-recommends "false"
--distribution "focal" \
--archive-areas "main restricted universe multiverse" \
--initramfs-compression "lz4" \
--parent-distribution "focal" \
--parent-debian-installer-distribution "focal" \
--parent-archive-areas "main restricted universe multiverse" \
--binary-images "iso-hybrid" \
--bootappend-live "boot=casper hostname=ubuntu username=ubuntu debian-installer/language=de keyboard-configuration/layoutcode=de fsck.mode=skip" \
--bootappend-live-failsafe="boot=casper memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal" \
--bootloaders "syslinux,grub-efi" \
--iso-application "Linux Mint Live" \
--keyring-packages "ubuntu-keyring" \
--linux-flavours "generic" \
--linux-packages "linux" \
--parent-mirror-bootstrap "http://archive.ubuntu.com/ubuntu/" \
--parent-mirror-chroot "http://archive.ubuntu.com/ubuntu/" \
--parent-mirror-chroot-security "http://security.ubuntu.com/ubuntu/" \
--parent-mirror-binary "http://archive.ubuntu.com/ubuntu/" \
--parent-mirror-binary-security "http://security.ubuntu.com/ubuntu/" \
--parent-mirror-debian-installer "http://archive.ubuntu.com/ubuntu/" \
--mirror-bootstrap "http://archive.ubuntu.com/ubuntu/" \
--mirror-chroot "http://archive.ubuntu.com/ubuntu/" \
--mirror-chroot-security "http://security.ubuntu.com/ubuntu/" \
--mirror-binary "http://archive.ubuntu.com/ubuntu/" \
--mirror-binary-security "http://security.ubuntu.com/ubuntu/" \
--mirror-debian-installer "http://archive.ubuntu.com/ubuntu/" \
--union-file-system="aufs" \
--zsync "false"

# LinuxMint GPG-Key kopieren
cp linuxmint.key.chroot config/archives/linuxmint.key.chroot

## netplan dhcp ##
## Namen der Netzwerkschnittstelle bitt anpassen ###
#cat <<END > config/hooks/live/01-network-dhcp.chroot
##!/bin/sh
#cat <<EOF > /etc/netplan/01-network-dhcp.yaml
#network:
# ethernets:
#  enp0s3:
#   dhcp4: true
# version: 2
#EOF
#END
#chmod 755 config/hooks/live/01-network-dhcp.chroot

## Desktop mit NetworkManager
cat <<END > config/hooks/live/01-network-manager.chroot
#!/bin/sh
cat << EOF > /etc/netplan/01-network-manager-all.yaml
network:
  version: 2
  renderer: NetworkManager
EOF
END
chmod 755 config/hooks/live/01-network-manager.chroot

# Deutsche Sprachpakete / Display Manager
# Wird das Paket gdm3 entfernt, verwendet das System
# automatisch den passenden Display Manager 
# lightdm (xubuntu) oder kwin (KDE)
cat <<EOF > config/hooks/live/language-packs.chroot
#!/bin/sh
apt install -y \$(check-language-support -l de)
apt -y remove gdm3
EOF
chmod 755 config/hooks/live/language-packs.chroot

# evtl. vorhandene Kopie von Kernel und Initrd entfernen
cat <<EOF > config/hooks/live/fix-binary.binary
#!/bin/sh
set -e
 if [ -e binary/casper/vmlinuz-* ]
 then
  rm casper/vmlinuz-*
 fi
 if [ -e binary/casper/initrd.img-* ]
 then
  rm casper/initrd.img-*
 fi 
EOF
chmod 755 config/hooks/live/fix-binary.binary


# Repositorien für Linux Mint
cat <<EOF > config/archives/linuxmint.list.chroot
deb http://packages.linuxmint.com uma main upstream import backport
deb http://mirror.stw-aachen.de/ubuntu focal-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
deb http://archive.canonical.com/ubuntu/ focal partner
EOF

# Paketliste Midnight Commander & Linux Mint Cinnamon
# durch --apt-recommends "false"
# werden nur die für die Pakete 
# erforderlichen aber nicht die empfohlenen Pakete installiert
# Was man zusätzlich benötigt, muss man daher in die Liste eintragen.
cat <<EOF > config/package-lists/extra.list.chroot
linuxmint-keyring
liblz4-tool
mc
cinnamon
cinnamon-common
cinnamon-control-center
cinnamon-control-center-data
cinnamon-control-center-dbg
cinnamon-dbg
cinnamon-desktop-data
cinnamon-l10n
cinnamon-screensaver
cinnamon-session
cinnamon-session-common
cinnamon-settings-daemon
lightdm
lightdm-settings
slick-greeter
netplan.io
xorg
xorg-docs-core
xserver-common
xserver-xephyr
xserver-xorg
xserver-xorg-core
xserver-xorg-input-all
xserver-xorg-input-libinput
xserver-xorg-input-wacom
xserver-xorg-legacy
xserver-xorg-video-all
xserver-xorg-video-amdgpu
xserver-xorg-video-ati
xserver-xorg-video-fbdev
xserver-xorg-video-intel
xserver-xorg-video-nouveau
xserver-xorg-video-qxl
xserver-xorg-video-radeon
xserver-xorg-video-vesa
xserver-xorg-video-vmware
mint-artwork
mint-backgrounds-ulyana
mint-common
mint-info-cinnamon
mint-live-session
mint-meta-cinnamon
mint-meta-core
mint-mirrors
mint-themes
mint-translations
mint-upgrade-info
mint-x-icons
mint-y-icons
mintbackup
mintdrivers
mintinstall
mintlocale
mintmenu
mintreport
mintsources
mintstick
mintsystem
mintupdate
mintwelcome
xed
xed-common
xed-dbg
plymouth
plymouth-label
plymouth-theme-ubuntu-text
network-manager
network-manager-config-connectivity-ubuntu
network-manager-gnome
network-manager-openvpn
network-manager-openvpn-gnome
network-manager-pptp
network-manager-pptp-gnome
firefox
language-selector-common
EOF

