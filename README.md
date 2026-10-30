# switch-homebrew

Nintendo Switch homebrew development workspace and scaffolding on Arch Linux using devkitPro (`devkitA64`), `libnx`, `hactool`, and `switch-tools`.

## Project Structure

```
switch-homebrew/
├── install.sh             # Automated installer for toolchain & environment
├── template/              # Ready-to-build libnx project template
│   ├── Makefile           # devkitPro libnx Makefile
│   ├── include/           # Header files
│   └── source/main.cpp    # Modern libnx PadState input & console loop
├── projects/              # Dedicated directory for individual homebrew projects (gitignored)
├── docs/
│   └── SETUP_INSTRUCTION.md # Full reference setup instructions
├── AGENTS.md              # Project guidelines & conventions
├── README.md
└── LICENSE                # MIT License
```

## Setup & Toolchain Installation

Run the provided installation script or follow manual instructions:

```bash
./install.sh
```

### Manual Installation

1. Add the devkitPro keyring:
   ```bash
   sudo pacman-key --recv-keys BC26F752D25B92CE272E0F44F7FD5492264BB9D0 --keyserver keyserver.ubuntu.com
   sudo pacman-key --lsign-key BC26F752D25B92CE272E0F44F7FD5492264BB9D0
   sudo pacman -U https://pkg.devkitpro.org/devkitpro-keyring.pkg.tar.xz
   ```

2. Add devkitPro repositories to `/etc/pacman.conf`:
   ```ini
   [dkp-libs]
   Server = https://pkg.devkitpro.org/packages

   [dkp-linux]
   Server = https://pkg.devkitpro.org/packages/linux/$arch/
   ```

3. Install packages:
   ```bash
   sudo pacman -Sy --needed switch-dev switch-portlibs
   paru -S --needed hactool switch-tools
   ```

4. Set environment variables in your shell profile (`~/.bashrc`, `~/.zshrc`, or `~/.config/fish/config.fish`):
   ```bash
   export DEVKITPRO=/opt/devkitpro
   export DEVKITARM=/opt/devkitpro/devkitARM
   export DEVKITA64=/opt/devkitpro/devkitA64
   export PATH=$DEVKITPRO/tools/bin:$DEVKITA64/bin:$PATH
   ```

## Creating a New Project

1. Copy the starter template into the gitignored `projects/` directory:
   ```bash
   cp -r template projects/my_app
   cd projects/my_app
   ```
2. Build the project:
   ```bash
   make
   ```
   This generates `my_app.nro` and `my_app.nacp`.

## Testing & Deployment

- **Emulator (Ryujinx)**: Open Ryujinx and load `my_app.nro`.
- **Physical Switch (SD Card)**: Transfer `my_app.nro` to `/switch/` on your SD card.
- **Physical Switch (nxlink)**: Launch Homebrew Menu on the Switch, press `Y` (NetLoader), and run:
  ```bash
  nxlink -a <SWITCH_IP> my_app.nro
  ```
- **Inspect Formats (hactool)**:
  ```bash
  hactool -t nro my_app.nro
  ```

## Reference Documentation

- Complete setup guide: [docs/SETUP_INSTRUCTION.md](file:///home/v/switch-homebrew/docs/SETUP_INSTRUCTION.md)
- [devkitPro Wiki](https://devkitpro.org/wiki/Main_Page)
- [libnx Documentation](https://switchbrew.github.io/libnx/)
- [Switchbrew Wiki](https://switchbrew.org/)
