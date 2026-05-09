DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
HOMEBREW_PREFIX := $(shell bin/is-supported bin/is-macos $(shell bin/is-supported bin/is-arm64 /opt/homebrew /usr/local) /home/linuxbrew/.linuxbrew)
export N_PREFIX = $(HOME)/.n
PATH := $(N_PREFIX)/bin:$(HOMEBREW_PREFIX)/bin:$(DOTFILES_DIR)/bin:$(PATH)
export PATH
SHELL := env /bin/zsh
SHELLS := /private/etc/shells
BIN := $(HOMEBREW_PREFIX)/bin
export XDG_CONFIG_HOME = $(HOME)/.config
export ZSH_HOME = $(HOME)/.zsh
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y
CONFIG_FILES := $(shell if git -C "$(DOTFILES_DIR)" rev-parse --is-inside-work-tree >/dev/null 2>&1; then git -C "$(DOTFILES_DIR)" ls-files config; else cd "$(DOTFILES_DIR)" && find config -type f | sort; fi)

.PHONY: test config-link config-unlink config-apply superpowers

all: $(OS)

macos: sudo core-macos packages link duti superpowers

linux: core-linux link superpowers

core-macos: omz brew bash git npm

core-linux:
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -f

stow-macos: brew
	is-executable stow || brew install stow

stow-linux: core-linux
	is-executable stow || apt-get -y install stow

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

# rust-package is no more installed by default
# you can use make rust-packages to install it later.
# however rust is included by default in Brewfile
packages: brew-packages cask-apps node-packages

link: stow-$(OS)
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p "$(ZSH_HOME)"
	mkdir -p "$(XDG_CONFIG_HOME)"
	stow --no-folding -t "$(ZSH_HOME)" zsh
	$(MAKE) config-link
	mkdir -p $(HOME)/.local/runtime
	chmod 700 $(HOME)/.local/runtime
	stow -t "$(HOME)" runcom

unlink: stow-$(OS)
	stow --delete -t "$(HOME)" runcom
	$(MAKE) config-unlink
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

config-link:
	$(MAKE) config-apply ACTION=link

config-unlink:
	$(MAKE) config-apply ACTION=unlink

config-apply:
	@set -e; \
	config_destination() { \
		case "$$1" in \
			config/codex/*) echo "$(HOME)/.codex/$${1#config/codex/}" ;; \
			config/gemini/*) echo "$(HOME)/.gemini/$${1#config/gemini/}" ;; \
			config/claude/*) echo "$(HOME)/.claude/$${1#config/claude/}" ;; \
			*) echo "$(XDG_CONFIG_HOME)/$${1#config/}" ;; \
		esac; \
	}; \
	canonical_path() { \
		echo "$$(cd "$$(dirname "$$1")" && pwd -P)/$$(basename "$$1")"; \
	}; \
	symlink_target_path() { \
		LINK="$$1"; \
		TARGET="$$(readlink "$$LINK")"; \
		case "$$TARGET" in \
			/*) canonical_path "$$TARGET" ;; \
			*) canonical_path "$$(dirname "$$LINK")/$$TARGET" ;; \
		esac; \
	}; \
	is_expected_symlink() { \
		[ "$$(symlink_target_path "$$1")" = "$$(canonical_path "$$2")" ]; \
	}; \
	for FILE in $(CONFIG_FILES); do \
		SRC="$(DOTFILES_DIR)/$$FILE"; \
		DST="$$(config_destination "$$FILE")"; \
		if [ "$(ACTION)" = "link" ]; then \
			mkdir -p "$$(dirname "$$DST")"; \
			if [ -L "$$DST" ]; then \
				if is_expected_symlink "$$DST" "$$SRC"; then \
					continue; \
				fi; \
				echo "Refusing to replace existing symlink: $$DST -> $$(readlink "$$DST")" >&2; \
				exit 1; \
			elif [ -e "$$DST" ]; then \
				echo "Refusing to replace existing file: $$DST" >&2; \
				exit 1; \
			fi; \
			ln -s "$$SRC" "$$DST"; \
		elif [ "$(ACTION)" = "unlink" ]; then \
			if [ -L "$$DST" ]; then \
				if ! is_expected_symlink "$$DST" "$$SRC"; then \
					echo "Refusing to detach unexpected symlink: $$DST -> $$(readlink "$$DST")" >&2; \
					exit 1; \
				fi; \
				TMP="$$(mktemp "$${DST}.tmp.XXXXXX")"; \
				cp "$$SRC" "$$TMP"; \
				mv "$$TMP" "$$DST"; \
			fi; \
		else \
			echo "Unsupported config action: $(ACTION)" >&2; \
			exit 1; \
		fi; \
	done

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

omz:
	is-folder "$(HOME)/.oh-my-zsh" || curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

bash: brew
ifdef GITHUB_ACTION
	if ! grep -q bash $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		sudo append $(shell which bash) $(SHELLS) && \
		sudo chsh -s $(shell which bash); \
	fi
else
	if ! grep -q bash $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		sudo append $(shell which bash) $(SHELLS) && \
		chsh -s $(shell which bash); \
	fi
endif

git: brew
	brew install git git-extras

npm: brew-packages
	n install lts

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile || true

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true
	defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

vscode-extensions: cask-apps
	for EXT in $$(cat install/Codefile); do code --install-extension $$EXT; done

node-packages: npm
	$(N_PREFIX)/bin/npm install --force --location global $(shell cat install/npmfile)

rust-packages: brew-packages
	cargo install $(shell cat install/Rustfile)

duti:
	duti -v $(DOTFILES_DIR)/install/duti

superpowers:
	dot superpowers

test:
	bats test
