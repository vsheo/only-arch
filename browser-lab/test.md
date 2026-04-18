```
cat >> /etc/grub.d/40_custom << 'EOF'
menuentry "Fedora Linux 43" {
    search --no-floppy --fs-uuid --set=root $(blkid -s UUID -o value /dev/nvme0n1p4)
    linux /boot/vmlinuz root=UUID=$(blkid -s UUID -o value /dev/nvme0n1p4) ro rhgb quiet
    initrd /boot/initramfs.img
}
EOF
grub-mkconfig -o /boot/grub/grub.cfg
```
