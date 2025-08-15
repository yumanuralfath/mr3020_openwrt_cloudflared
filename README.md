# Build & Deploy `cloudflared` untuk TP-Link MR3020 (MIPS little-endian softfloat)

## Deskripsi
Skrip ini digunakan untuk:
1. Memeriksa apakah **Go** sudah terpasang di Arch Linux.
2. Mengunduh source code `cloudflared` dari GitHub.
3. Melakukan build untuk arsitektur **MIPS little-endian softfloat** (cocok untuk TP-Link MR3020 dan router OpenWrt sejenis).
4. Mengirim hasil build langsung ke router menggunakan `scp`.

---

## Persyaratan
- Arch Linux / Manjaro
- Koneksi SSH ke router
- Paket `git` dan `scp` sudah terpasang
- Port **22** router terbuka

---

## Instalasi & Penggunaan

### 1. Clone atau salin skrip
```bash
wget https://example.com/build_and_send_cloudflared.sh
chmod +x build_and_send_cloudflared.sh
```

2. Edit konfigurasi router di skrip
```
Ubah variabel di awal skrip sesuai router:

ROUTER_IP="192.168.1.1"
ROUTER_USER="root"
ROUTER_PATH="/usr/bin/cloudflared"
````
3. Jalankan skrip
```bash
./build_and_send_cloudflared.sh
```
4. Cek di router
```
ssh root@192.168.1.1 cloudflared --version
```
Catatan

Jika router tidak mendukung algoritma SSH baru, skrip sudah diatur untuk menggunakan opsi:
```
    -oHostKeyAlgorithms=+ssh-rsa
    -oPubkeyAcceptedAlgorithms=+ssh-rsa
```
Pastikan storage router cukup untuk menyimpan binary cloudflared.

