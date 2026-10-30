#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Configuring devkitPro environment..."

# Export in current session
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=/opt/devkitpro/devkitARM
export DEVKITA64=/opt/devkitpro/devkitA64
export PATH="$DEVKITPRO/tools/bin:$DEVKITA64/bin:$PATH"

# Ensure repo keys & pacman.conf are active
if ! grep -q '\[dkp-libs\]' /etc/pacman.conf 2>/dev/null; then
  echo "==> devkitPro pacman repo missing. Adding repository..."
  sudo pacman-key --recv-keys BC26F752D25B92CE272E0F44F7FD5492264BB9D0 --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key BC26F752D25B92CE272E0F44F7FD5492264BB9D0
  sudo pacman -U --noconfirm https://pkg.devkitpro.org/devkitpro-keyring.pkg.tar.xz
  sudo bash -c 'cat >> /etc/pacman.conf << "EOF"

[dkp-libs]
Server = https://pkg.devkitpro.org/packages

[dkp-linux]
Server = https://pkg.devkitpro.org/packages/linux/$arch/
EOF'
  sudo pacman -Sy
fi

echo "==> Ensuring required Switch development packages are installed..."
sudo pacman -S --needed --noconfirm switch-dev switch-portlibs
paru -S --needed --noconfirm hactool switch-tools

echo "==> Verifying toolchain binaries..."
for bin in aarch64-none-elf-gcc nxlink hactool elf2nro; do
  if command -v "$bin" >/dev/null 2>&1; then
    echo "  [OK] $bin -> $(command -v "$bin")"
  else
    echo "  [FAIL] $bin not found in PATH"
  fi
done

echo "==> Nintendo Switch homebrew environment ready."
