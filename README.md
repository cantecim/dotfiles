# .files

These are my dotfiles. Take anything you want, but at your own risk.

It mainly targets macOS systems (should install on e.g. Ubuntu as well for many tools, config and aliases etc).

# TODOs
- [ ] empty for now

## Highlights

- Minimal efforts to install everything, using a [Makefile](./Makefile)
- Mostly based around Homebrew, Caskroom and Node.js, zsh + latest GNU Utils
- Oh my Zsh included
- Great [Window management](./config/hammerspoon/README.md) (using Hammerspoon)
- Fast and beautiful theme
- Updated macOS defaults
- Well-organized and easy to customize
- The installation and runcom setup is
  [tested weekly on real Ubuntu and macOS machines](https://github.com/cantecim/dotfiles/actions)
  (Monterey/12 and Ventura/13) using [a GitHub Action](./.github/workflows/dotfiles-installation.yml)
- Installs spoofdpi with homebrew, you can use with `unblock` alias (A local proxy server to bypass DPI procedures of your ISP)
- Incognito mode for zsh [thanks to Stephan Sokolow](https://blog.ssokolow.com/archives/2020/09/08/incognito-mode-for-zsh/)
- Supports both Apple Silicon (M1) and Intel chips
- `dot update` command to automate upgrades across all package managers
- **NEW**: Johnny.Decimal supports
  - jd_* prefixed functions to help your JD file system
- **EXTRA**: Lightweight command help via `tldr` CLI tool

<!-- this is a trick to prevent mark down link check action reporting false positive -->
<!-- id="packages-overview" -->
## Packages Overview

- [Homebrew](https://brew.sh) (packages: [Brewfile](./install/Brewfile))
- [homebrew-cask](https://github.com/Homebrew/homebrew-cask) (packages: [Caskfile](./install/Caskfile))
- [Node.js + npm LTS](https://nodejs.org/en/download/) (packages: [npmfile](./install/npmfile))
- Latest Git, Bash, Python, GNU coreutils, curl, Ruby
- [Hammerspoon](https://www.hammerspoon.org) (config: [keybindings & window management](./config/hammerspoon))
- [`tldr`](https://tldr.sh) - Simplified and community-driven man pages, installed via npmfile
- `$EDITOR` is [GNU nano](https://www.nano-editor.org) (`$VISUAL` is `code` and Git `core.editor` is `code --wait`)

## Installation

On a sparkling fresh installation of macOS:

```bash
sudo softwareupdate -i -a
xcode-select --install
```

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS). Now there are two options:

1. Install this repo with `curl` available:

```bash
curl -fsSL https://raw.githubusercontent.com/cantecim/dotfiles/main/remote-install.sh | bash
```

This will clone or download this repo to `~/.dotfiles` (depending on the availability of `git`, `curl` or `wget`).

1. Alternatively, clone manually into the desired location:
   - first [create your ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) `ssh-keygen -t ed25519 -C "your_email@example.com"`
   - add it into your [GitHub Account's SSH keys](https://github.com/settings/keys)

```bash
git clone git@github.com:cantecim/dotfiles.git ~/.dotfiles
```

1. Use the [Makefile](./Makefile) to install the [packages listed above](#packages-overview), and symlink
   [runcom](./runcom) and [config](./config) files (using [stow](https://www.gnu.org/software/stow/)):

```bash
cd ~/.dotfiles
make
```

Running `make` with the Makefile is idempotent. The installation process in the Makefile is tested on every push and every week in this
[GitHub Action](https://github.com/cantecim/dotfiles/actions). Please file an issue in this repo if there are errors.

## Post-Installation

1. Install Avast Security

   You can skip this step if you'd like to.

```sh
open "`brew list --cask -v avast-security | grep Security.pkg`"
```

2. Set your Git credentials:

   It is configured for me by default

```sh
git config --global user.name "your name"
git config --global user.email "your@email.com"
git config --global github.user "your-github-username"
```

3. Install zsh extra features, set macOS [Dock items](./macos/dock.sh) and [system defaults](./macos/defaults.sh):

```sh
dot zsh
dot mas
dot dock
dot macos
```

4. Start Hammerspoon once and set "Launch Hammerspoon at login".

5. Populate this file with tokens (example: `export GITHUB_TOKEN=abc`):

```sh
nano ~/.dotfiles/system/.exports
```

6. Restore your application configurations

```sh
mackup restore
```

See [this section](#using-mackup) for more info

<!-- id="using-mackup" -->
## Using `mackup`

You can use mackup to backup and restore your application settings with ease.

If you don't have any backup yet, after installing these dotfiles for the first time, you might want to run `mackup backup`

Or, if you'd like to backup from another mac, you can login to your iCloud account and run

```sh
echo "[storage]" >> .mackup.cfg
echo "engine = icloud" >> .mackup.cfg
echo "" >> .mackup.cfg
echo "[applications_to_ignore]" >> .mackup.cfg
echo "zsh" >> .mackup.cfg
brew install mackup
mackup backup
```

### Default settings
Mackup is configured to use iCloud as storage engine, this means it will backup to and restore from there.

### WARNING
> ⚠️ before switching to another device, make sure you backup your data!

### Backup your data

If you're migrating from an existing Mac, you should first make sure to backup all of your existing data. Go through the checklist below to make sure you didn't forget anything before you migrate.

- Did you commit and push any changes/branches to your git repositories?
- Did you remember to save all important documents from non-iCloud directories?
- Did you save all of your work from apps which aren't synced through iCloud?
- Did you remember to export important data from your local database?
- Did you update [mackup](https://github.com/lra/mackup) to the latest version and ran `mackup backup`?

## tldr CLI: simplified help for commands

`tldr` provides simplified and community-driven manual pages. It's helpful to learn and recall common usage patterns.

### Example:

```bash
tldr tar
```

### Install:

```bash
npm install -g tldr
```

Included in [`npmfile`](./install/npmfile) and installed during `make`.

---

## The `dot` command

```sh
$ dot help
Usage: dot <command>

Commands:
   clean            Clean up caches (brew, cargo, gem, pip)
   dock             Apply macOS Dock settings
   edit             Open dotfiles in IDE ($VISUAL) and Git GUI ($VISUAL_GIT)
   help             This help message
   macos            Apply macOS system defaults
   zsh              Install zsh extra stuff
   mas              Install macOS apps from App Store using mas CLI
   logioptions      Install Logi Options+ app for Logitech devices
   startuphook      Inject startup hook daemon
   rm-startuphook   Remove startup hook daemon
   test             Run tests
   update           Update packages and pkg managers (brew, casks, cargo, pip3, npm, gems, macOS)
```

### What is included in `dot update`?

Runs system-wide update routines across various environments. It ensures all developer tools are up-to-date in a single command.

- `brew upgrade` (packages and casks)
- `npm update -g` (npmfile)
- `pip3 install --upgrade` for global packages
- `gem update`
- `cargo install-update`
- Runs system update hooks like `dot macos`

Useful after long breaks or machine migrations to sync environments fast.

### What is included in `dot zsh`?
Install extra zsh plugins

- zsh-syntax-highlighting

### What is included in `dot mas`?
Install macOS apps defined in `install/Masfile` using mas CLI

- Microsoft To Do
- etc.

### What does `startup hook` daemon injection do?
It registers the startup daemon as launch agent under GUI of **current user** (user agents of **current user**, i.e. **login item** for **current user**) using launchctl, startup daemon basically runs the script `daemon/startuphook.sh` (see [plist file](daemon/com.cantecim.startuphook.plist))

##### What startuphook.sh do then?
When it started (so when computer runs) it executes `unblock-discord` command, and when shutting-down executes `unblock-quit`

Basically, runs unblocker automatically to use discord without any break

---

## The JD utilities
### jd_rename <target_id> <new_id>
If you would like to rename/shift/move your IDs use this function

### more TBImplemented

## How to use incognito mode
Type `anonsh` to go incognito in your current shell, but beware that you still need to run clean up commands before exiting

- Use `clear` to clear both the screen and scrollback buffer
- Use `fc -p` to clear command history without affecting your usual HISTFILE

## Customize

To customize the dotfiles to your likings, fork it and [be the king of your castle!](https://www.webpro.nl/articles/getting-started-with-dotfiles)

## Credits

- This project is based on [webpro's dotfiles](https://github.com/webpro/dotfiles) repository (thanks webpro!)
- Inspired from driesvints/dotfiles esp. on mackup
- Also inspired from codfish/dotfiles esp. on zsh-autosuggestions plugin
- And many thanks to the [dotfiles community](https://dotfiles.github.io).
