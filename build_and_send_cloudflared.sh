#!/bin/bash
set -e

# Konfigurasi
ROUTER_IP="192.168.1.1"
ROUTER_USER="root"
ROUTER_PATH="/usr/bin/cloudflared"

# --- Cek apakah Go terpasang ---
if ! command -v go &>/dev/null; then
  echo "❌ Go belum terpasang. Menginstall Go..."
  sudo pacman -S --needed go
fi

# --- Cek versi minimal Go 1.22 ---
GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
GO_MAJOR=$(echo "$GO_VERSION" | cut -d. -f1)
GO_MINOR=$(echo "$GO_VERSION" | cut -d. -f2)

if [ "$GO_MAJOR" -lt 1 ] || { [ "$GO_MAJOR" -eq 1 ] && [ "$GO_MINOR" -lt 22 ]; }; then
  echo "❌ Versi Go minimal 1.22 diperlukan. Versi terdeteksi: $GO_VERSION"
  exit 1
fi

echo "✅ Versi Go memenuhi syarat: $GO_VERSION"

# --- Clone repo cloudflared ---
if [ ! -d cloudflared ]; then
  echo "📥 Mengunduh source cloudflared..."
  git clone https://github.com/cloudflare/cloudflared.git
fi

cd cloudflared

# --- Build untuk MIPS little-endian softfloat ---
echo "🔨 Building cloudflared untuk MIPS little-endian softfloat..."
GOOS=linux GOARCH=mipsle GOMIPS=softfloat go build -v -mod=vendor github.com/cloudflare/cloudflared/cmd/cloudflared

# --- Kirim binary ke router ---
echo "📤 Mengirim binary ke router..."
scp -O -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedAlgorithms=+ssh-rsa cloudflared "$ROUTER_USER@$ROUTER_IP:$ROUTER_PATH"

echo "✅ Selesai! Cek di router dengan perintah:"
echo "   ssh $ROUTER_USER@$ROUTER_IP cloudflared --version"
