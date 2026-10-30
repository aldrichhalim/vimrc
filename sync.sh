#!/usr/bin/env bash
# Usage: ./sync.sh init    move ~/.vimrc into this repo and symlink it back
#        ./sync.sh update  pull remote changes, commit and push local ones
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
SRC="$REPO/vimrc"
DEST="$HOME/.vimrc"

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

case "${1:-}" in
  init)
    link
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
    ;;
  *)
    echo "Usage: $0 {init|update}" >&2
    exit 1
    ;;
esac
