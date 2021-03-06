sudo lb config \
--mode "ubuntu" \
--architecture amd64 \
--distribution focal \
--archive-areas "main universe multiverse" \
--binary-images iso-hybrid \
--linux-flavours "generic" \
--linux-packages "linux" \
--parent-distribution "focal" \
--parent-debian-installer-distribution focal \
--parent-archive-areas "main universe multiverse" \
--apt-options "--yes --allow-remove-essential" \
--apt-recommends "true" \
--bootappend-live "boot=casper hostname=ubuntu username=ubuntu debian-installer/language=de keyboard-configuration/layoutcode=de fsck.mode=skip" \
--bootappend-live-failsafe "boot=casper hostname=ubuntu username=ubuntu debian-installer/language=de keyboard-configuration/layoutcode=de fsck.mode=skip nomodeset" \
--iso-application "Ubuntu live" \
--initramfs-compression "lz4" \
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
--keyring-packages "ubuntu-keyring" \
--zsync="false"

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


## Ubuntu Desktop mit NetworkManager
cat <<END > config/hooks/live/01-network-manager.chroot
#!/bin/sh
cat << EOF > /etc/netplan/01-network-manager-all.yaml
network:
  version: 2
  renderer: NetworkManager
EOF
END
chmod 755 config/hooks/live/01-network-manager.chroot

# Deutsche Sprachpakete
cat <<EOF > config/hooks/live/language-packs.chroot
#!/bin/sh
apt install -y \$(check-language-support -l de)
apt -y remove gdm3
dpkg-reconfigure lightdm

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

# Session einstellen
cat <<END > config/hooks/live/fix-xsession.chroot
#!/bin/sh
set -e
cat << EOF > /var/lib/AccountsService/users/ubuntu
[User]
#XSession=plasma
XSession=cinnamon
#XSession=mate
#XSession=xfce
#XSession=Lubuntu.desktop
Icon=/home/ubuntu/.face
SystemAccount=false

[InputSource0]
xkb=de
EOF
END
chmod 755 config/hooks/live/fix-xsession.chroot
# Paketlist Ubuntu casper boot scripts & Midnight Commander & Ubuntu-Desktop
# durch --apt-recommends "true"
# werden fast alle erforderlichen Pakete automatisch installiert
# inklusive LibreOffice, Thunderbird und Firefox
cat <<EOF > config/package-lists/extra.list.chroot
liblz4-tool
mc
cinnamon-desktop-environment
lightdm
EOF
