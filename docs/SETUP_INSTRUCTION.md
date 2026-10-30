# Arch Linux: Nintendo Switch Homebrew Setup Guide

Reference instructions and guide for configuring the Nintendo Switch homebrew toolchain on Arch Linux.

## Purpose

- Install the standard Nintendo Switch homebrew toolchain using native Arch pacman and devkitPro repositories.
- Install debugging and file inspection tools:
  - `nxlink`: stream logs and run/debug homebrew on real Switch hardware over network.
  - `hactool`: inspect Nintendo Switch package/file formats (`.nsp`, `.xci`, `.nro`).
- Provide a standard libnx project template.
- Build a `.nro` homebrew binary.
- Explain execution in Ryujinx or on real hardware.

---

## 1) Pacman & devkitPro Setup

devkitPro packages (`switch-dev`, `switch-portlibs`, `devkitA64`) are hosted on devkitPro's pacman repository.

### Add devkitPro Keyring and Repositories

```bash
sudo pacman-key --recv-keys BC26F752D25B92CE272E0F44F7FD5492264BB9D0 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key BC26F752D25B92CE272E0F44F7FD5492264BB9D0
sudo pacman -U https://pkg.devkitpro.org/devkitpro-keyring.pkg.tar.xz
```

Append the following blocks to `/etc/pacman.conf`:

```ini
[dkp-libs]
Server = https://pkg.devkitpro.org/packages

[dkp-linux]
Server = https://pkg.devkitpro.org/packages/linux/$arch/
```

Synchronize pacman databases:
```bash
sudo pacman -Syu
```

---

## 2) Install Toolchain & Tools

Install the devkitPro Switch SDK and portlibs via pacman:
```bash
sudo pacman -S --needed switch-dev switch-portlibs
```

Install AUR tools via paru:
```bash
paru -S --needed hactool switch-tools
```

---

## 3) Configure Environment Variables

devkitPro installs into `/opt/devkitpro`. Set environment variables in your shell configuration.

### Bash (`~/.bashrc`) / Zsh (`~/.zshrc`)
```bash
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=/opt/devkitpro/devkitARM
export DEVKITA64=/opt/devkitpro/devkitA64
export PATH=$DEVKITPRO/tools/bin:$DEVKITA64/bin:$PATH
```

### Fish (`~/.config/fish/config.fish`)
```fish
set -gx DEVKITPRO /opt/devkitpro
set -gx DEVKITARM /opt/devkitpro/devkitARM
set -gx DEVKITA64 /opt/devkitpro/devkitA64
fish_add_path /opt/devkitpro/tools/bin /opt/devkitpro/devkitA64/bin
```

### Verify Toolchain
```bash
which aarch64-none-elf-gcc
which nxlink
which hactool
which elf2nro
aarch64-none-elf-gcc --version
```

---

## 4) Tool Explanations

### `nxlink`
Runs and debugs homebrew on a physical Nintendo Switch over the local network. When Homebrew Menu with NetLoader (`Y` button) is active on the console:
```bash
nxlink -a <switch_ip> <app.nro>
```

### `hactool`
Inspects, decrypts, and unpacks Nintendo Switch file formats (`.nsp`, `.xci`, `.nro`, `.nca`).
```bash
hactool -t nro app.nro
hactool -k keys.dat -t nsp package.nsp
```

---

## 5) Creating & Building Projects

Copy the `template/` directory into `projects/<your-app-name>`:

```bash
cp -r template projects/my_project
cd projects/my_project
make
```

Output:
- `my_project.nro`: Nintendo Homebrew executable
- `my_project.nacp`: Nintendo Application Control Package metadata

---

## 6) Running Your Homebrew

- **Ryujinx**: Launch Ryujinx, select `File -> Load Application` or open the generated `.nro`.
- **Physical Hardware (SD Card)**: Copy `.nro` into `sdmc:/switch/` and launch via Homebrew Menu.
- **Physical Hardware (Network / nxlink)**: In hbmenu, press `Y` (NetLoader) and execute `nxlink -a <SWITCH_IP> build.nro`.
