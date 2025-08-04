#!/bin/sh
#
# Update script for the **gi** CLI.
# It can be executed directly via `curl`:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/martinusso/gi/main/update.sh)"
# or via `wget`:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/martinusso/gi/main/update.sh)"
#
# You can also run it locally if the repository is already cloned:
#   ./update.sh
#
# -----------------------------------------------------------------------------
# Configuration ----------------------------------------------------------------
# -----------------------------------------------------------------------------

REPO=${REPO:-martinusso/gi}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-main}

# -----------------------------------------------------------------------------
# Helpers ----------------------------------------------------------------------
# -----------------------------------------------------------------------------

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

setup_color() {
  # Only use colors if stdout is a TTY
  if [ -t 1 ]; then
    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    BLUE=$(printf '\033[34m')
    BOLD=$(printf '\033[1m')
    RESET=$(printf '\033[m')
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    RESET=""
  fi
}

error() {
  echo ${RED}"Error: $*"${RESET} >&2
}

# -----------------------------------------------------------------------------
# Update -----------------------------------------------------------------------
# -----------------------------------------------------------------------------

update_gi() {
  command_exists cargo || {
    error "cargo is not installed (Rust toolchain missing)"
    exit 1
  }

  echo "${BLUE}Updating gi from ${BOLD}${REMOTE}${RESET} (branch ${BRANCH})"

  cargo install --git "$REMOTE" --branch "$BRANCH" --locked --force || {
    error "Failed to update via cargo install"
    exit 1
  }

  echo "${GREEN}gi updated successfully!${RESET}"
  echo
  gi --version
}

# -----------------------------------------------------------------------------
# Entry point ------------------------------------------------------------------
# -----------------------------------------------------------------------------

main() {
  setup_color
  update_gi
}

main "$@"
