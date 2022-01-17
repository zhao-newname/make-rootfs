## http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.3-base-amd64.tar.gz
FILE_NAME="ubuntu-base-20.04.1-base-amd64.tar.gz"
if [ ! -f $FILE_NAME ]; then
	wget http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/$FILE_NAME
fi

mkdir amd64
tar -xvf $FILE_NAME -C amd64
cd amd64
mount --bind /dev ./dev
mount --bind /proc ./proc
mount --bind /proc ./proc
 
 
cp /etc/resolv.conf ./etc/resolv.conf
sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' ./etc/apt/sources.list
 
cd ..

cat <<EOF > amd64/stuff.sh
chmod 0777 /tmp
apt update
#apt upgrade
sync
DEBIAN_FRONTEND=noninteractive apt-get install  -y iproute2 net-tools gcc make git vim file sysstat libssl-dev tree pciutils util-linux iputils-ping
DEBIAN_FRONTEND=noninteractive apt-get install  -y sudo systemd systemd-sysv gdisk parted u-boot-tools linux-base initramfs-tools 
EOF

chmod +x amd64/stuff.sh

sudo chroot amd64 /stuff.sh

cd amd64
umount ./dev
umount ./proc
umount ./sys
 
sudo tar -cjvf ../amd64-rootfs.tar.bz2 *