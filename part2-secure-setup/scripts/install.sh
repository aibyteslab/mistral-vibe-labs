#!/usr/bin/env bash
# Install the AI Bytes Lab Vibe security profile into ~/.vibe.
# Usage: scripts/install.sh [--lab]   (--lab also creates ~/vibe-lab)
set -euo pipefail

SRC="$(cd "$(dirname "$0")/.." && pwd)"
VIBE="${VIBE_HOME:-$HOME/.vibe}"
STAMP="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$VIBE/hooks"
chmod 700 "$VIBE" "$VIBE/hooks"

for f in config.toml AGENTS.md hooks.toml; do
  if [[ -e "$VIBE/$f" ]]; then
    cp -p "$VIBE/$f" "$VIBE/$f.bak-$STAMP"
    echo "backup: $VIBE/$f.bak-$STAMP"
  fi
done

install -m 600 "$SRC/user/config.toml" "$VIBE/config.toml"
install -m 600 "$SRC/user/AGENTS.md" "$VIBE/AGENTS.md"
install -m 700 "$SRC/user/hooks/deny-secret-reads.py" "$VIBE/hooks/deny-secret-reads.py"
# hooks run without a shell, so write the absolute path of this user's hook
sed "s|/home/aibyteslab/.vibe|$VIBE|" "$SRC/user/hooks.toml" > "$VIBE/hooks.toml"
chmod 600 "$VIBE/hooks.toml"
echo "installed into $VIBE"

if [[ "${1:-}" == "--lab" ]]; then
  LAB="$HOME/vibe-lab"
  if git -C "$HOME" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "refusing: $HOME is inside a git repository (the trust demo needs a non-git lab)" >&2
    exit 1
  fi
  mkdir -p "$LAB"
  cp -R "$SRC/lab/demo-api" "$SRC/lab/untrusted-repo" "$LAB/"
  mv "$LAB/untrusted-repo/dot-vibe" "$LAB/untrusted-repo/.vibe"
  cp "$LAB/demo-api/.env.example" "$LAB/demo-api/.env"
  echo "lab created in $LAB (fake values only)"
fi
