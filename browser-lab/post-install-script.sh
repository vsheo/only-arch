#!/bin/bash
#===============================================
# Browser Test Lab — Post-install script
# Draai dit als root NA een handmatige Fedora installatie
# Gebruik: sudo bash post-install.sh
#===============================================
 
set -e
 
if [ "$EUID" -ne 0 ]; then
  echo "Draai dit script als root: sudo bash post-install.sh"
  exit 1
fi
 
USERNAME="user"
HOMEDIR="/home/$USERNAME"
 
echo "=== Browser Test Lab — Post-install gestart ==="
 
#-----------------------------------------------
# 1. Systeem updaten
#-----------------------------------------------
echo ">>> Systeem updaten..."
dnf upgrade -y
 
#-----------------------------------------------
# 2. Automatische updates uitzetten (Fedora 43)
#-----------------------------------------------
echo ">>> Automatische updates uitzetten..."
systemctl mask dnf-automatic-install.timer 2>/dev/null || true
systemctl disable packagekit 2>/dev/null || true
systemctl mask packagekit || true
 
# GNOME Software updates uitzetten
sudo -u "$USERNAME" gsettings set org.gnome.software download-updates false 2>/dev/null || true
sudo -u "$USERNAME" gsettings set org.gnome.software allow-updates false 2>/dev/null || true
 
mkdir -p /etc/dconf/db/local.d
cat > /etc/dconf/db/local.d/00-no-updates << 'DCONFEOF'
[org/gnome/software]
download-updates=false
allow-updates=false
DCONFEOF
dconf update || true
 
#-----------------------------------------------
# 3. Essentiële tools installeren
#-----------------------------------------------
echo ">>> Tools installeren..."
dnf install -y \
  git curl wget htop tmux vim net-tools \
  firewall-config \
  python3 python3-pip \
  nodejs npm
 
#-----------------------------------------------
# 4. Swap file aanmaken
#-----------------------------------------------
if [ ! -f /swapfile ]; then
  echo ">>> Swap file aanmaken..."
  fallocate -l 8G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
else
  echo ">>> Swap file bestaat al, overslaan."
fi
 
#-----------------------------------------------
# 5. Docker installeren (dnf5 syntax)
#-----------------------------------------------
echo ">>> Docker installeren..."
dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
 
systemctl enable --now docker
usermod -aG docker "$USERNAME"
 
#-----------------------------------------------
# 6. KVM/QEMU installeren
#-----------------------------------------------
echo ">>> KVM/QEMU installeren..."
dnf install -y \
  qemu-kvm libvirt virt-manager virt-install \
  bridge-utils edk2-ovmf swtpm swtpm-tools
 
systemctl enable --now libvirtd
usermod -aG libvirt "$USERNAME"
 
#-----------------------------------------------
# 7. Docker Compose bestand klaarzetten
#-----------------------------------------------
echo ">>> Docker Compose aanmaken..."
mkdir -p "$HOMEDIR/browser-lab"
cat > "$HOMEDIR/browser-lab/docker-compose.yml" << 'COMPOSEEOF'
services:
 
  # ===================== CHROME =====================
 
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
    profiles: ["chrome", "2021", "all"]
 
  chrome-98:
    image: selenium/standalone-chrome:4.1.2-20220217
    container_name: chrome-98
    ports:
      - "4402:4444"
      - "7002:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["chrome", "2022", "all"]
 
  chrome-108:
    image: selenium/standalone-chrome:4.7.2-20221219
    container_name: chrome-108
    ports:
      - "4403:4444"
      - "7003:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["chrome", "2022", "all"]
 
  chrome-109:
    image: selenium/standalone-chrome:4.8.0-20230131
    container_name: chrome-109
    ports:
      - "4404:4444"
      - "7004:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["chrome", "2023", "all"]
 
  chrome-119:
    image: selenium/standalone-chrome:4.15.0-20231129
    container_name: chrome-119
    ports:
      - "4405:4444"
      - "7005:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["chrome", "2023", "all"]
 
  chrome-121:
    image: selenium/standalone-chrome:4.17.0-20240123
    container_name: chrome-121
    ports:
      - "4406:4444"
      - "7006:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["chrome", "2024", "all"]
 
  chrome-130:
    image: selenium/standalone-chrome:4.25.0-20241010
    container_name: chrome-130
    ports:
      - "4407:4444"
      - "7007:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["chrome", "2024", "all"]
 
  chrome-132:
    image: selenium/standalone-chrome:4.28.1-20250202
    container_name: chrome-132
    ports:
      - "4408:4444"
      - "7008:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["chrome", "2025", "all"]
 
  chrome-140:
    image: selenium/standalone-chrome:4.36.0-20251001
    container_name: chrome-140
    ports:
      - "4409:4444"
      - "7009:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["chrome", "2025", "all"]
 
  # ===================== FIREFOX =====================
 
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
    profiles: ["firefox", "2021", "all"]
 
  firefox-97:
    image: selenium/standalone-firefox:4.1.2-20220217
    container_name: firefox-97
    ports:
      - "4502:4444"
      - "7102:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["firefox", "2022", "all"]
 
  firefox-107:
    image: selenium/standalone-firefox:4.7.2-20221219
    container_name: firefox-107
    ports:
      - "4503:4444"
      - "7103:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["firefox", "2022", "all"]
 
  firefox-109:
    image: selenium/standalone-firefox:4.8.0-20230131
    container_name: firefox-109
    ports:
      - "4504:4444"
      - "7104:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["firefox", "2023", "all"]
 
  firefox-120:
    image: selenium/standalone-firefox:4.15.0-20231129
    container_name: firefox-120
    ports:
      - "4505:4444"
      - "7105:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["firefox", "2023", "all"]
 
  firefox-122:
    image: selenium/standalone-firefox:4.17.0-20240123
    container_name: firefox-122
    ports:
      - "4506:4444"
      - "7106:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["firefox", "2024", "all"]
 
  firefox-131:
    image: selenium/standalone-firefox:4.25.0-20241010
    container_name: firefox-131
    ports:
      - "4507:4444"
      - "7107:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["firefox", "2024", "all"]
 
  firefox-134:
    image: selenium/standalone-firefox:4.28.1-20250202
    container_name: firefox-134
    ports:
      - "4508:4444"
      - "7108:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["firefox", "2025", "all"]
 
  firefox-143:
    image: selenium/standalone-firefox:4.36.0-20251001
    container_name: firefox-143
    ports:
      - "4509:4444"
      - "7109:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["firefox", "2025", "all"]
 
  # ===================== EDGE =====================
 
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
    profiles: ["edge", "2021", "all"]
 
  edge-98:
    image: selenium/standalone-edge:4.1.2-20220217
    container_name: edge-98
    ports:
      - "4602:4444"
      - "7202:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["edge", "2022", "all"]
 
  edge-108:
    image: selenium/standalone-edge:4.7.2-20221219
    container_name: edge-108
    ports:
      - "4603:4444"
      - "7203:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["edge", "2022", "all"]
 
  edge-109:
    image: selenium/standalone-edge:4.8.0-20230131
    container_name: edge-109
    ports:
      - "4604:4444"
      - "7204:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["edge", "2023", "all"]
 
  edge-119:
    image: selenium/standalone-edge:4.15.0-20231129
    container_name: edge-119
    ports:
      - "4605:4444"
      - "7205:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["edge", "2023", "all"]
 
  edge-121:
    image: selenium/standalone-edge:4.17.0-20240123
    container_name: edge-121
    ports:
      - "4606:4444"
      - "7206:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["edge", "2024", "all"]
 
  edge-130:
    image: selenium/standalone-edge:4.25.0-20241010
    container_name: edge-130
    ports:
      - "4607:4444"
      - "7207:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["edge", "2024", "all"]
 
  edge-132:
    image: selenium/standalone-edge:4.28.1-20250202
    container_name: edge-132
    ports:
      - "4608:4444"
      - "7208:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["edge", "2025", "all"]
 
  edge-140:
    image: selenium/standalone-edge:4.36.0-20251001
    container_name: edge-140
    ports:
      - "4609:4444"
      - "7209:7900"
    environment:
      - SE_VNC_NO_PASSWORD=1
      - SE_SCREEN_WIDTH=1920
      - SE_SCREEN_HEIGHT=1080
    shm_size: "2g"
    restart: unless-stopped
    profiles: ["edge", "2025", "all"]
 
COMPOSEEOF
 
#-----------------------------------------------
# 8. Lab management script
#-----------------------------------------------
echo ">>> Lab script aanmaken..."
cat > "$HOMEDIR/browser-lab/lab.sh" << 'LABEOF'
#!/bin/bash
IP=$(hostname -I | awk '{print $1}')
LABDIR=~/browser-lab
 
case "$1" in
  start)
    PROFILE="${2:-all}"
    echo "Starting containers (profile: $PROFILE)..."
    cd "$LABDIR" && docker compose --profile "$PROFILE" up -d
    echo ""
    docker ps --format "table {{.Names}}\t{{.Ports}}" | grep -v "NAMES" | sort
    echo ""
    echo "Vervang localhost door $IP voor netwerktoegang."
    ;;
  stop)
    if [ -n "$2" ]; then
      cd "$LABDIR" && docker compose stop "$2"
    else
      cd "$LABDIR" && docker compose --profile all stop
    fi
    ;;
  urls)
    echo "--- Chrome ---"
    echo "  chrome-96 (2021) http://$IP:7001"
    echo "  chrome-98 (2022) http://$IP:7002"
    echo "  chrome-108 (2022) http://$IP:7003"
    echo "  chrome-109 (2023) http://$IP:7004"
    echo "  chrome-119 (2023) http://$IP:7005"
    echo "  chrome-121 (2024) http://$IP:7006"
    echo "  chrome-130 (2024) http://$IP:7007"
    echo "  chrome-132 (2025) http://$IP:7008"
    echo "  chrome-140 (2025) http://$IP:7009"
    echo "--- Firefox ---"
    echo "  firefox-95 (2021) http://$IP:7101"
    echo "  firefox-97 (2022) http://$IP:7102"
    echo "  firefox-107 (2022) http://$IP:7103"
    echo "  firefox-109 (2023) http://$IP:7104"
    echo "  firefox-120 (2023) http://$IP:7105"
    echo "  firefox-122 (2024) http://$IP:7106"
    echo "  firefox-131 (2024) http://$IP:7107"
    echo "  firefox-134 (2025) http://$IP:7108"
    echo "  firefox-143 (2025) http://$IP:7109"
    echo "--- Edge ---"
    echo "  edge-96 (2021) http://$IP:7201"
    echo "  edge-98 (2022) http://$IP:7202"
    echo "  edge-108 (2022) http://$IP:7203"
    echo "  edge-109 (2023) http://$IP:7204"
    echo "  edge-119 (2023) http://$IP:7205"
    echo "  edge-121 (2024) http://$IP:7206"
    echo "  edge-130 (2024) http://$IP:7207"
    echo "  edge-132 (2025) http://$IP:7208"
    echo "  edge-140 (2025) http://$IP:7209"
    echo ""
    echo "Wachtwoord: secret"
    ;;
  status)
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null
    echo ""
    free -h
    ;;
  playwright)
    BROWSER="${2:-chromium}"
    URL="${3:-http://localhost:3000}"
    cd ~/playwright-lab && PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=1 \
      npx playwright open --browser "$BROWSER" "$URL"
    ;;
  *)
    echo "Browser Test Lab"
    echo ""
    echo "  lab start [profile]   profiles: all, chrome, firefox, edge, 2021-2025"
    echo "  lab stop [naam]       Stop alles of één container"
    echo "  lab urls              Toon alle noVNC URLs"
    echo "  lab status            Systeem status"
    echo "  lab playwright [browser] [url]  Playwright (chromium/firefox)"
    ;;
esac
LABEOF
 
chmod +x "$HOMEDIR/browser-lab/lab.sh"
 
#-----------------------------------------------
# 9. Bash alias toevoegen
#-----------------------------------------------
if ! grep -q 'alias lab=' "$HOMEDIR/.bashrc" 2>/dev/null; then
  echo 'alias lab="~/browser-lab/lab.sh"' >> "$HOMEDIR/.bashrc"
fi
 
#-----------------------------------------------
# 10. Firewall configureren
#-----------------------------------------------
echo ">>> Firewall configureren..."
firewall-cmd --permanent --add-port=7001-7009/tcp
firewall-cmd --permanent --add-port=7101-7109/tcp
firewall-cmd --permanent --add-port=7201-7209/tcp
firewall-cmd --permanent --add-port=4401-4409/tcp
firewall-cmd --permanent --add-port=4501-4509/tcp
firewall-cmd --permanent --add-port=4601-4609/tcp
firewall-cmd --reload
 
#-----------------------------------------------
# 11. Playwright installeren
#-----------------------------------------------
echo ">>> Playwright installeren..."
dnf install -y alsa-lib atk at-spi2-atk cups-libs libdrm mesa-libgbm \
  pango cairo libxkbcommon libXcomposite libXdamage libXfixes libXrandr \
  libwayland-client libwayland-server nss nspr gtk3 libXt \
  enchant2 libsecret hyphen harfbuzz-icu libmanette \
  gstreamer1-plugins-good gstreamer1-plugins-base woff2 \
  gstreamer1-libav gstreamer1-plugins-bad-free
 
mkdir -p "$HOMEDIR/playwright-lab"
cd "$HOMEDIR/playwright-lab"
sudo -u "$USERNAME" npm init -y
sudo -u "$USERNAME" npm install playwright
sudo -u "$USERNAME" npx playwright install chromium firefox webkit
 
#-----------------------------------------------
# 12. Docker images pullen (dit duurt 20-40 min)
#-----------------------------------------------
echo ">>> Docker images pullen per jaar..."
cd "$HOMEDIR/browser-lab"
docker compose --profile 2021 pull
docker compose --profile 2022 pull
docker compose --profile 2023 pull
docker compose --profile 2024 pull
docker compose --profile 2025 pull
 
#-----------------------------------------------
# 13. Bestands-eigenaarschap fixen
#-----------------------------------------------
chown -R "$USERNAME:$USERNAME" "$HOMEDIR/"
 
echo ""
echo "=== Browser Test Lab — Installatie voltooid! ==="
echo ""
echo "Log uit en weer in (of: newgrp docker)"
echo "Daarna: lab start 2024"
echo ""
