#!/usr/bin/env bats

setup() {
	ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
	HOME_DIR="$BATS_TEST_TMPDIR/home"
	INSTALL_DIR="$HOME_DIR/.local/share/dotfiles/superpowers"
	SKILLS_LINK="$HOME_DIR/.agents/skills/superpowers"
	FAKE_BIN="$BATS_TEST_TMPDIR/bin"
	GIT_LOG="$BATS_TEST_TMPDIR/git.log"

	mkdir -p "$HOME_DIR" "$FAKE_BIN"
	cat > "$FAKE_BIN/git" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$GIT_LOG"

if [[ "$1" == "clone" ]]; then
	mkdir -p "$3/.git" "$3/skills"
	exit 0
fi

if [[ "$1" == "-C" && "$3" == "pull" && "$4" == "--ff-only" ]]; then
	exit 0
fi

exit 1
EOF
	chmod +x "$FAKE_BIN/git"
}

run_superpowers() {
	run env \
		HOME="$HOME_DIR" \
		PATH="$FAKE_BIN:$PATH" \
		GIT_LOG="$GIT_LOG" \
		SUPERPOWERS_REPO_URL="https://example.test/superpowers.git" \
		SUPERPOWERS_INSTALL_DIR="$INSTALL_DIR" \
		SUPERPOWERS_SKILLS_LINK="$SKILLS_LINK" \
		"$ROOT/bin/dot" superpowers
}

@test "superpowers clones repo and links skills" {
	run_superpowers
	[ "$status" -eq 0 ]

	[ -d "$INSTALL_DIR/.git" ]
	[ -d "$INSTALL_DIR/skills" ]
	[ -L "$SKILLS_LINK" ]
	[ "$(readlink "$SKILLS_LINK")" = "$INSTALL_DIR/skills" ]
	grep -F -- "clone https://example.test/superpowers.git $INSTALL_DIR" "$GIT_LOG"
}

@test "superpowers updates existing git repo" {
	mkdir -p "$INSTALL_DIR/.git" "$INSTALL_DIR/skills"

	run_superpowers
	[ "$status" -eq 0 ]

	[ -L "$SKILLS_LINK" ]
	grep -F -- "-C $INSTALL_DIR pull --ff-only" "$GIT_LOG"
}

@test "superpowers is idempotent when link is already correct" {
	run_superpowers
	[ "$status" -eq 0 ]

	run_superpowers
	[ "$status" -eq 0 ]

	[ "$(readlink "$SKILLS_LINK")" = "$INSTALL_DIR/skills" ]
	[[ "$output" == *"Superpowers skills already linked."* ]]
}

@test "superpowers fails closed when install path is not a git repo" {
	mkdir -p "$INSTALL_DIR"

	run_superpowers
	[ "$status" -ne 0 ]

	[ ! -e "$SKILLS_LINK" ]
	[[ "$output" == *"Refusing to use existing non-git path"* ]]
}

@test "superpowers fails closed when skills link path is a real directory" {
	mkdir -p "$INSTALL_DIR/.git" "$INSTALL_DIR/skills" "$SKILLS_LINK"

	run_superpowers
	[ "$status" -ne 0 ]

	[ -d "$SKILLS_LINK" ]
	[[ "$output" == *"Refusing to replace existing path"* ]]
}

@test "superpowers fails closed when skills link points elsewhere" {
	mkdir -p "$INSTALL_DIR/.git" "$INSTALL_DIR/skills" "$BATS_TEST_TMPDIR/other"
	mkdir -p "$(dirname "$SKILLS_LINK")"
	ln -s "$BATS_TEST_TMPDIR/other" "$SKILLS_LINK"

	run_superpowers
	[ "$status" -ne 0 ]

	[ "$(readlink "$SKILLS_LINK")" = "$BATS_TEST_TMPDIR/other" ]
	[[ "$output" == *"Refusing to replace existing symlink"* ]]
}
