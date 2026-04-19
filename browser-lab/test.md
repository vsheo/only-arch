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

```
#!/bin/sh
exec tail -n +3 $0
menuentry "Fedora Linux 43" {
    search --no-floppy --fs-uuid --set=root f2f5bb96-0cb0-40cc-b152-6e0d2c10d387
    linux /vmlinuz-6.19.12-200.fc43.x86_64 root=UUID=07741f1c-1b0d-46fb-9d9b-4ad14206aae2 ro rootflags=subvol=root rhgb quiet
    initrd /initramfs-6.19.12-200.fc43.x86_64.img
}
```
```
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-43.noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-43.noarch.rpm
sudo dnf install -y broadcom-wl
sudo reboot
```
