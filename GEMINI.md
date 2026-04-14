# GEMINI.md - Instructional Context for .dotfiles

This repository contains personal dotfiles and system configurations, primarily targeting macOS but with support for Linux (Ubuntu).

## Project Overview

- **Purpose:** Automate the setup and maintenance of a development environment on macOS/Ubuntu.
- **Main Technologies:**
  - **Shell:** Zsh with Oh My Zsh.
  - **Package Management:** Homebrew (Brewfile, Caskfile), npm (npmfile), mas (Masfile), Cargo.
  - **Configuration Management:** GNU Stow (for symlinking files in `config/` and `runcom/`).
  - **Automation:** Makefile and a custom `dot` CLI tool.
  - **Window Management:** Hammerspoon.

## Directory Structure

- `bin/`: Custom executable scripts, including the main `dot` utility.
- `config/`: Application-specific configuration files (Hammerspoon, Git, Prettier, etc.) linked via `stow` to `~/.config`.
- `daemon/`: LaunchAgent configurations for background tasks (e.g., `startuphook`).
- `install/`: Lists of packages to be installed by various package managers.
- `macos/`: Scripts to configure macOS system defaults (`defaults.sh`) and the Dock (`dock.sh`).
- `runcom/`: Shell startup files (.zshrc, .zprofile, .zshenv, .inputrc, .mackup.cfg) linked via `stow` to `$HOME`.
- `system/`: Modular shell snippets (.alias, .env, .function, .path, etc.) sourced by `.zprofile`.
- `zsh/`: Zsh-specific functions and plugins.
- `test/`: BATS (Bash Automated Testing System) tests to verify installation and functionality.

## Key Commands & Workflows

### Installation

The project uses a `Makefile` for idempotent installation.

```bash
make          # Install core components, packages, and link configuration
make test     # Run validation tests
```

### Management via `dot` CLI

The `dot` utility (located in `bin/dot`) is the primary way to interact with the dotfiles after installation.

- `dot update`: Updates all packages (Brew, npm, Cargo, etc.) and macOS defaults.
- `dot macos`: Applies macOS system defaults.
- `dot dock`: Resets and configures the macOS Dock.
- `dot zsh`: Installs extra Zsh plugins.
- `dot edit`: Opens the dotfiles directory in the configured IDE and Git GUI.

## Development Conventions

- **Modular Configuration:** Shell configurations are broken down by type in the `system/` directory (e.g., `.alias`, `.env`, `.function`).
- **macOS Specifics:** Files ending in `.macos` in the `system/` directory are only sourced on macOS systems.
- **Idempotency:** Installation scripts and the `Makefile` are designed to be run multiple times without side effects.
- **Stow-based Linking:** Use `stow` to manage symlinks. The `Makefile` handles this automatically during installation.
- **Environment Variables:** Sensitive or machine-specific exports should be placed in `system/.exports`.

## External Tools Integrated

- **mackup:** Used for backing up and restoring application settings via iCloud.
- **autoenv:** Automatically activates environments when entering directories.
- **tldr:** Simplified man pages for quick command reference.
- **Hammerspoon:** Advanced macOS automation and window management.
