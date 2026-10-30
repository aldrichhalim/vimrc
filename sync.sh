#!/usr/bin/env bash
# Usage: ./sync.sh init    link ~/.vimrc to this repo, install vim-plug and plugins
#        ./sync.sh update  pull remote changes, commit and push local ones
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
SRC="$REPO/vimrc"
DEST="$HOME/.vimrc"
PLUG="$HOME/.vim/autoload/plug.vim"
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

warn() { echo "Warning: $*" >&2; }
has() { command -v "$1" >/dev/null 2>&1; }

link() {
  if [ -L "$DEST" ] && [ "$(readlink "$DEST")" = "$SRC" ]; then return; fi
  if [ -e "$DEST" ] || [ -L "$DEST" ]; then
    if [ ! -e "$SRC" ] && [ ! -L "$DEST" ]; then
      mv "$DEST" "$SRC"
      echo "Moved $DEST -> $SRC"
    else
      mv "$DEST" "$DEST.bak.$(date +%s)"
      echo "Backed up existing $DEST"
    fi
  fi
  ln -s "$SRC" "$DEST"
  echo "Linked $DEST -> $SRC"
}

# Warn about programs vim-plug can't provide; never installs them.
check_deps() {
  local pkg="sudo apt install"
  case "$(uname -s)" in
    Darwin) pkg="brew install" ;;
  esac
  has git  || warn "git not found; run: $pkg git"
  has curl || warn "curl not found; run: $pkg curl"
  has rg   || warn "rg not found (needed by :Rg); run: $pkg ripgrep"
  has node || warn "node not found (needed by coc); install Node.js 16.18+, e.g. via https://github.com/nvm-sh/nvm"
  if ! has vim; then
    warn "vim not found; run: $pkg vim"
  elif ! vim -es -u NONE -c 'if !has("patch-9.0.0438") | cquit | endif' -c 'qa!'; then
    warn "vim is older than 9.0.0438, which coc.nvim requires; upgrade it (newer distro, PPA or Homebrew)"
  fi
}

plugins() {
  if ! has vim; then warn "vim not found; skipping plugin install"; return; fi
  if [ ! -f "$PLUG" ]; then
    if ! curl -fsSLo "$PLUG" --create-dirs "$PLUG_URL"; then
      warn "could not download vim-plug; skipping plugin install"
      return
    fi
    echo "Installed vim-plug"
  fi
  # Errors here are usually plugins not yet loaded on first run; don't abort.
  vim -Nes -u "$SRC" -i NONE -c 'PlugInstall' -c 'qa!' || warn "PlugInstall reported errors; run :PlugInstall in vim to see them"
  echo "Plugins installed"
}

case "${1:-}" in
  init)
    link
    check_deps
    plugins
    ;;
  update)
    cd "$REPO"
    git pull --rebase --autostash
    if ! git diff --quiet HEAD -- vimrc; then
      git add vimrc
      git commit -m "Update vimrc"
    fi
    git push
    link
    plugins
    ;;
  *)
    echo "Usage: $0 {init|update}" >&2
    exit 1
    ;;
esac
