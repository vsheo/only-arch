// MacOS for qemu kvm Virtual Machine
// Call this file OpenCore-Boot.sh
// inside the /OSX-KVM folder


```bash
#!/usr/bin/env bash

# Special thanks to:
# https://github.com/Leoyzen/KVM-Opencore
# https://github.com/thenickdude/KVM-Opencore/
# https://github.com/qemu/qemu/blob/master/docs/usb2.txt
#
# qemu-img create -f qcow2 mac_hdd_ng.img 128G
#
# echo 1 > /sys/module/kvm/parameters/ignore_msrs (this is required)

###############################################################################
# NOTE: Tweak the "MY_OPTIONS" line in case you are having booting problems!
###############################################################################

MY_OPTIONS="+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

ALLOCATED_RAM="4096" # MiB
CPU_SOCKETS="1"
CPU_CORES="2"
CPU_THREADS="4"

# Altijd absoluut pad — werkt ongeacht vanwaar je het script aanroept
REPO_PATH="$(cd "$(dirname "$0")" && pwd)"
OVMF_DIR="."

# Controleer kritieke bestanden vóór start
for f in \
  "$REPO_PATH/$OVMF_DIR/OVMF_CODE_4M.fd" \
  "$REPO_PATH/$OVMF_DIR/OVMF_VARS-1920x1080.fd" \
  "$REPO_PATH/OpenCore/OpenCore.qcow2" \
  "$REPO_PATH/mac_hdd_ng.img"; do
  if [[ ! -f "$f" ]]; then
    echo "FOUT: Bestand niet gevonden: $f"
    exit 1
  fi
done

# shellcheck disable=SC2054
args=(
  -enable-kvm -m "$ALLOCATED_RAM"
  -cpu Skylake-Client,-hle,-rtm,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,"$MY_OPTIONS"
  -machine q35

  # --- USB / Input ---
  # xhci voor keyboard
  -device nec-usb-xhci,id=xhci
  -device usb-kbd,bus=xhci.0

  # ehci voor muis + keyboard (macOS Catalina pikt HID beter op via ehci)
  -device usb-ehci,id=ehci
  -device usb-kbd,bus=ehci.0
  -device usb-tablet,bus=ehci.0

  -smp "$CPU_THREADS",cores="$CPU_CORES",sockets="$CPU_SOCKETS"

  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"

  # --- OVMF / UEFI ---
  -drive if=pflash,format=raw,readonly=on,file="$REPO_PATH/$OVMF_DIR/OVMF_CODE_4M.fd"
  -drive if=pflash,format=raw,file="$REPO_PATH/$OVMF_DIR/OVMF_VARS-1920x1080.fd"

  -smbios type=2

  # --- Audio ---
  -device ich9-intel-hda
  -device hda-duplex

  # --- SATA controller + schijven ---
  -device ich9-ahci,id=sata

  # OpenCore op bus 0 — eerste bootprioriteit
  -drive id=OpenCoreBoot,if=none,snapshot=on,format=qcow2,file="$REPO_PATH/OpenCore/OpenCore.qcow2"
  -device ide-hd,bus=sata.0,drive=OpenCoreBoot

  # macOS HDD op bus 1
  -drive id=MacHDD,if=none,file="$REPO_PATH/mac_hdd_ng.img",format=qcow2
  -device ide-hd,bus=sata.1,drive=MacHDD

  # Installatiemedia — uitgecomment want Catalina is al geïnstalleerd
  # Zet aan als je opnieuw wilt installeren:
  # -drive id=InstallMedia,if=none,file="$REPO_PATH/BaseSystem.img",format=raw
  # -device ide-hd,bus=sata.2,drive=InstallMedia
  # -drive id=InstallESD,if=none,file="$REPO_PATH/InstallESD.img",format=raw
  # -device ide-hd,bus=sata.3,drive=InstallESD

  # --- Netwerk ---
  -netdev user,id=net0
  -device vmxnet3,netdev=net0,id=net0,mac=52:54:00:c9:18:27

  # --- Monitor (debug via: telnet 127.0.0.1 55555) ---
  -monitor telnet:127.0.0.1:55555,server,nowait

  # --- Display ---
  # zoom-to-fit=on  → fullscreen schaalt correct mee
  # grab-on-hover=off → geen automatische muisgrab bij hoveren
  # full-screen=on  → start direct in fullscreen
  # Klik in venster om muis te grijpen, Ctrl+Alt+G om te bevrijden
  -display gtk,zoom-to-fit=on,grab-on-hover=off,full-screen=on
)

# GDK_BACKEND=x11 forceert GTK via XWayland → muisgrab werkt correct op Wayland/Hyprland
GDK_BACKEND=x11 qemu-system-x86_64 "${args[@]}"
```
