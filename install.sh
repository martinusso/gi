#!/bin/sh
#
# This script installs the **gi** CLI from source.
# It can be executed directly via `curl`:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/martinusso/gi/main/install.sh)"
# or `wget`:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/martinusso/gi/main/install.sh)"

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

error() {
  echo ${RED}"Error: $*"${RESET} >&2
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

# -----------------------------------------------------------------------------
# Installation -----------------------------------------------------------------
# -----------------------------------------------------------------------------

setup_gi() {
  # Restrict write permissions for group and others to prevent accidental edits.
  umask g-w,o-w

  echo "${BLUE}Cloning gi${RESET}"

  command_exists git || {
    error "git is not installed"
    exit 1
  }

  # Windows/MSYS Git on Cygwin is not supported
  if [ "$OSTYPE" = cygwin ] && git --version | grep -q msysgit; then
    error "Windows/MSYS Git is not supported on Cygwin"
    error "Ensure the Cygwin git package is installed and comes first in the PATH"
    exit 1
  fi

  git clone -c core.eol=lf -c core.autocrlf=false \
    --depth=1 --branch "$BRANCH" "$REMOTE" || {
    error "git clone of gi repo failed"
    exit 1
  }

  cd gi

  # Build & install using Cargo ------------------------------------------------
  command_exists cargo || {
    error "cargo is not installed (Rust toolchain missing)"
    exit 1
  }

  echo "${BLUE}Building gi (this might take a while)${RESET}"
  cargo install --path . --locked || {
    error "cargo install failed"
    exit 1
  }

  echo
}

# -----------------------------------------------------------------------------
# Entry Point ------------------------------------------------------------------
# -----------------------------------------------------------------------------

main() {
  setup_color

  if command_exists gi; then
    cat <<-EOF
      ${YELLOW}You already have gi installed.${RESET}
      Remove the existing installation if you want to reinstall.
EOF
    exit 1
  fi

  setup_gi

  printf "$GREEN"
  cat <<-'EOF'
           _ 
      __ _(_)
     / _` | |
    | (_| | |
     \__, |_|
     |___/   

          ... is now installed!
EOF
  printf "$RESET"

  # Show basic info
  exec gi --help
}

main "$@"

