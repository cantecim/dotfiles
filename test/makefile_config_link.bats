#!/usr/bin/env bats

setup() {
	ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
	REPO="$BATS_TEST_TMPDIR/repo"
	XDG="$BATS_TEST_TMPDIR/xdg"
	HOME_DIR="$BATS_TEST_TMPDIR/home"

	mkdir -p "$REPO/config/codex/skills/fix-the-class-not-the-case/agents"
	mkdir -p "$REPO/config/gemini" "$REPO/config/claude" "$REPO/config/git" "$XDG" "$HOME_DIR"

	printf 'codex config\n' > "$REPO/config/codex/config.toml"
	printf 'codex agents\n' > "$REPO/config/codex/AGENTS.md"
	printf 'skill\n' > "$REPO/config/codex/skills/fix-the-class-not-the-case/SKILL.md"
	printf 'agent\n' > "$REPO/config/codex/skills/fix-the-class-not-the-case/agents/openai.yaml"
	printf 'gemini\n' > "$REPO/config/gemini/settings.json"
	printf 'claude\n' > "$REPO/config/claude/settings.json"
	printf 'git\n' > "$REPO/config/git/config"
	printf 'runtime\n' > "$REPO/config/codex/auth.json"

	git -C "$REPO" init --quiet
	git -C "$REPO" add config/codex/config.toml \
		config/codex/AGENTS.md \
		config/codex/skills/fix-the-class-not-the-case/SKILL.md \
		config/codex/skills/fix-the-class-not-the-case/agents/openai.yaml \
		config/gemini/settings.json \
		config/claude/settings.json \
		config/git/config
}

make_config() {
	make -s -f "$ROOT/Makefile" DOTFILES_DIR="$REPO" HOME="$HOME_DIR" XDG_CONFIG_HOME="$XDG" "$@"
}

make_config_from() {
	make -s -f "$ROOT/Makefile" DOTFILES_DIR="$1" HOME="$HOME_DIR" XDG_CONFIG_HOME="$XDG" "$2"
}

@test "config-link links agent configs into home dotdirs and xdg configs into xdg" {
	mkdir -p "$HOME_DIR/.codex" "$HOME_DIR/.gemini" "$HOME_DIR/.claude" "$XDG/git"

	run make_config config-link
	[ "$status" -eq 0 ]

	[ -L "$HOME_DIR/.codex/config.toml" ]
	[ "$(readlink "$HOME_DIR/.codex/config.toml")" = "$REPO/config/codex/config.toml" ]
	[ -L "$HOME_DIR/.gemini/settings.json" ]
	[ -L "$HOME_DIR/.claude/settings.json" ]
	[ -L "$XDG/git/config" ]
	[ ! -e "$HOME_DIR/.codex/auth.json" ]
	[ ! -e "$XDG/codex/config.toml" ]
}

@test "config-link is idempotent for links it already manages" {
	run make_config config-link
	[ "$status" -eq 0 ]

	run make_config config-link
	[ "$status" -eq 0 ]
}

@test "config-link accepts relative symlinks to managed files" {
	mkdir -p "$HOME_DIR/.codex"
	ln -s "../../repo/config/codex/config.toml" "$HOME_DIR/.codex/config.toml"

	run make_config config-link
	[ "$status" -eq 0 ]
	[ "$(readlink "$HOME_DIR/.codex/config.toml")" = "../../repo/config/codex/config.toml" ]
}

@test "config-link falls back to present config files outside a git checkout" {
	ARCHIVE="$BATS_TEST_TMPDIR/archive"
	mkdir -p "$ARCHIVE/config/claude"
	printf 'claude\n' > "$ARCHIVE/config/claude/settings.json"

	run make_config_from "$ARCHIVE" config-link
	[ "$status" -eq 0 ]
	[ -L "$HOME_DIR/.claude/settings.json" ]
	[ "$(readlink "$HOME_DIR/.claude/settings.json")" = "$ARCHIVE/config/claude/settings.json" ]
}

@test "config-link fails closed when destination file already exists" {
	mkdir -p "$HOME_DIR/.codex"
	printf 'local\n' > "$HOME_DIR/.codex/config.toml"

	run make_config config-link
	[ "$status" -ne 0 ]
	[[ "$output" == *"Refusing to replace existing file"* ]]
	[ "$(cat "$HOME_DIR/.codex/config.toml")" = "local" ]
}

@test "config-link fails closed when destination symlink points elsewhere" {
	mkdir -p "$HOME_DIR/.codex"
	printf 'other\n' > "$BATS_TEST_TMPDIR/other"
	ln -s "$BATS_TEST_TMPDIR/other" "$HOME_DIR/.codex/config.toml"

	run make_config config-link
	[ "$status" -ne 0 ]
	[[ "$output" == *"Refusing to replace existing symlink"* ]]
	[ "$(readlink "$HOME_DIR/.codex/config.toml")" = "$BATS_TEST_TMPDIR/other" ]
}

@test "config-unlink detaches managed symlinks into regular files" {
	run make_config config-link
	[ "$status" -eq 0 ]

	run make_config config-unlink
	[ "$status" -eq 0 ]

	[ -f "$HOME_DIR/.codex/config.toml" ]
	[ ! -L "$HOME_DIR/.codex/config.toml" ]
	[ "$(cat "$HOME_DIR/.codex/config.toml")" = "codex config" ]
	[ -f "$HOME_DIR/.claude/settings.json" ]
	[ ! -L "$HOME_DIR/.claude/settings.json" ]
	[ -f "$XDG/git/config" ]
	[ ! -L "$XDG/git/config" ]
}

@test "config-unlink detaches relative symlinks to managed files" {
	mkdir -p "$HOME_DIR/.codex"
	ln -s "../../repo/config/codex/config.toml" "$HOME_DIR/.codex/config.toml"

	run make_config config-unlink
	[ "$status" -eq 0 ]
	[ -f "$HOME_DIR/.codex/config.toml" ]
	[ ! -L "$HOME_DIR/.codex/config.toml" ]
	[ "$(cat "$HOME_DIR/.codex/config.toml")" = "codex config" ]
}

@test "config-unlink preserves unrelated files in home dotdirs" {
	mkdir -p "$HOME_DIR/.codex"
	printf 'keep\n' > "$HOME_DIR/.codex/local.json"

	run make_config config-link
	[ "$status" -eq 0 ]

	run make_config config-unlink
	[ "$status" -eq 0 ]
	[ "$(cat "$HOME_DIR/.codex/local.json")" = "keep" ]
}

@test "config-unlink fails closed on unexpected symlink" {
	mkdir -p "$HOME_DIR/.codex"
	printf 'other\n' > "$BATS_TEST_TMPDIR/other"
	ln -s "$BATS_TEST_TMPDIR/other" "$HOME_DIR/.codex/config.toml"

	run make_config config-unlink
	[ "$status" -ne 0 ]
	[[ "$output" == *"Refusing to detach unexpected symlink"* ]]
	[ "$(readlink "$HOME_DIR/.codex/config.toml")" = "$BATS_TEST_TMPDIR/other" ]
}
