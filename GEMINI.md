# Workspace Rules — switch-homebrew

## Context

Nintendo Switch homebrew development workspace. Arch Linux + devkitPro + libnx.

## Structure Conventions

- `template/` — canonical minimal libnx project starter. Keep it clean and buildable.
- `projects/` — individual projects, **gitignored**, stays local only.
- `docs/` — reference notes, links, research.

## Build Environment

- Toolchain: `devkitPro` at `/opt/devkitpro`
- Required env: `DEVKITPRO`, `DEVKITA64`, `PATH` (see SETUP.md)
- Cross-compiler: `aarch64-none-elf-gcc`
- SDK: libnx

## Key packages (paru)

- `switch-dev` — core toolchain + libnx
- `switch-portlibs` — portlib extras
- `hactool` — file format inspector
- `switch-tools` — nxlink, elf2nro, etc.

## Dev Workflow

1. Copy `template/` into `projects/<name>/`
2. Edit `Makefile` TARGET and `src/main.cpp`
3. `make` → produces `build/<name>.nro`
4. Test in Ryujinx or copy to SD card
5. Debug on hardware with `nxlink -a <ip> build/<name>.nro`

## Legal

Personal legal homebrew only. Not for piracy or unauthorized distribution.
