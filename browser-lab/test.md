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
```
services:

  chrome-96:
    image: selenium/standalone-chrome:4.1.0-20211209
    container_name: chrome-96
    ports:
      - "4401:4444"
      - "7001:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped

  firefox-95:
    image: selenium/standalone-firefox:4.1.0-20211209
    container_name: firefox-95
    ports:
      - "4501:4444"
      - "7101:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped

  edge-96:
    image: selenium/standalone-edge:4.1.0-20211209
    container_name: edge-96
    ports:
      - "4601:4444"
      - "7201:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
```
