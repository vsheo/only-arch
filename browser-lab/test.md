```
cat > /etc/grub.d/40_custom << 'EOF'
#!/bin/sh
exec tail -n +3 $0
menuentry "Fedora Linux 43" {
    search --no-floppy --fs-uuid --set=root 07741f1c-1b0d-46fb-9d9b-4ad14206aae2
    linux /boot/vmlinuz root=UUID=07741f1c-1b0d-46fb-9d9b-4ad14206aae2 ro rhgb quiet
    initrd /boot/initramfs.img
}
EOF
grub-mkconfig -o /boot/grub/grub.cfg
```
