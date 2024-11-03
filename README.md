# .files

These are my dotfiles. Take anything you want, but at your own risk.

It mainly targets macOS systems (should install on e.g. Ubuntu as well for many tools, config and aliases etc).

# TODOs
- [ ] Monitor git diff and git merge tool behaviors adjust gitconfig if needed
- [x] Check if ps0 and related function can be removed without any break
- [x] add mackup instructions from driesvints
- [ ] add cheat from codfish/dotfiles
- [ ] consider https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/nodenv requires customization to omz theme

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
- Supports both Apple Silicon (M1) and Intel chips

## Packages Overview

- [Homebrew](https://brew.sh) (packages: [Brewfile](./install/Brewfile))
- [homebrew-cask](https://github.com/Homebrew/homebrew-cask) (packages: [Caskfile](./install/Caskfile))
- [Node.js + npm LTS](https://nodejs.org/en/download/) (packages: [npmfile](./install/npmfile))
- Latest Git, Bash, Python, GNU coreutils, curl, Ruby
- [Hammerspoon](https://www.hammerspoon.org) (config: [keybindings & window management](./config/hammerspoon))
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
bash -c "`curl -fsSL https://raw.githubusercontent.com/cantecim/dotfiles/master/remote-install.sh`"
```

This will clone or download this repo to `~/.dotfiles` (depending on the availability of `git`, `curl` or `wget`).

1. Alternatively, clone manually into the desired location:
   - first [create your ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) "ssh-keygen -t rsa -b 4096 -C "your_email@example.com""
   - add it into your [GitHub Account's SSH keys](https://github.com/settings/keys)

```bash
git clone https://github.com/cantecim/dotfiles.git ~/.dotfiles
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

1. Set your Git credentials:

   It is configured for me by default

```sh
git config --global user.name "your name"
git config --global user.email "your@email.com"
git config --global github.user "your-github-username"
```

2. Install zsh extra features, set macOS [Dock items](./macos/dock.sh) and [system defaults](./macos/defaults.sh):

```sh
dot zsh
dot dock
dot macos
```

1. Start Hammerspoon once and set "Launch Hammerspoon at login".

2. Populate this file with tokens (example: `export GITHUB_TOKEN=abc`):

```sh
nano ~/.dotfiles/system/.exports
```

5. Restore your application configurations

```sh
mackup restore
```

See [this section](#using-mackup) for more info

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
   test             Run tests
   update           Update packages and pkg managers (brew, casks, cargo, pip3, npm, gems, macOS)
```

### What is included in `dot zsh`?
Install extra zsh plugins

- zsh-syntax-highlighting

## Customize

To customize the dotfiles to your likings, fork it and [be the king of your castle!](https://www.webpro.nl/articles/getting-started-with-dotfiles)

## Credits

- This project is based on [webpro's dotfiles](https://github.com/webpro/dotfiles) repository (thanks webpro!)
- Inspired from driesvints/dotfiles esp. on mackup
- Also inspired from codfish/dotfiles esp. on zsh-autosuggestions plugin
- And many thanks to the [dotfiles community](https://dotfiles.github.io).
