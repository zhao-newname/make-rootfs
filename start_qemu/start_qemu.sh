qemu-system-x86_64 -s \
-kernel /home/jeff/workstation/kernel_src/linux-hwe-5.11-5.11.0/arch/x86_64/boot/bzImage \
-boot c -m 2049M \
-device e1000,netdev=brdev0 \
-netdev bridge,id=brdev0,br=virbr0 \
-hda /home/jeff/workstaging/qemu-gdb/make_rootfs/rootfs.ext4 \
-append "root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr" \
-serial mon:stdio -display none 
