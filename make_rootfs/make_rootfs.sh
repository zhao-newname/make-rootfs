## http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.3-base-$ARCH.tar.gz
#!/bin/bash
set -x

ARCH=$1

FILE_NAME=$2

build_rootfs()
{
#	FILE_NAME="ubuntu-base-20.04.1-base-$ARCH.tar.gz"
	if [ ! -f $FILE_NAME ]; then
		wget http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/$FILE_NAME
	fi
	
	mkdir $ARCH
	tar -xvf $FILE_NAME -C $ARCH
	cd $ARCH
	mount --bind /dev ./dev
	mount --bind /proc ./proc
	mount --bind /sys ./sys
	 
	cp /etc/resolv.conf ./etc/resolv.conf
	sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' ./etc/apt/sources.list
	 
	cd ..
	cat <<EOF > $ARCH/stuff.sh
	chmod 0777 /tmp
	apt update
	#apt upgrade
	sync
	DEBIAN_FRONTEND=noninteractive apt-get install  -y iproute2 net-tools gcc \
	make git vim file sysstat libssl-dev tree pciutils util-linux iputils-ping \
	sudo systemd systemd-sysv gdisk parted u-boot-tools linux-base initramfs-tools 
	passwd root
EOF

	chmod +x $ARCH/stuff.sh
	
	sudo chroot $ARCH /stuff.sh
	
	 cd $ARCH
	 rm -rf stuff.sh
	 umount ./dev
	 umount ./proc
	 umount ./sys
	  
	sudo tar -cjvf ../$ARCH-rootfs.tar.bz2 *
}

pack_img()
{
#	cd ..
	qemu-img create $ARCH-rootfs.ext4 10G
	mkfs.ext4 $ARCH-rootfs.ext4
	
	mkdir rootfs
  sudo mount $ARCH-rootfs.ext4 rootfs
  
	sudo tar -xvf ./$ARCH-rootfs.tar.bz2 -C rootfs

	sudo umount rootfs
}

#build_rootfs
pack_img
