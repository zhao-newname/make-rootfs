qemu-system-x86_64 -kernel ./vmlinuz-5.11.0-43-generic -boot c -m 2049M -hda rootfs-image.img -append "root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr" -serial stdio -display none
