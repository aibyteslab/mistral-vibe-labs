#!/usr/bin/env bash
# Check the Vibe security profile. Never prints key values.
set -uo pipefail

VIBE="${VIBE_HOME:-$HOME/.vibe}"
warn=0
ok()   { echo "ok    $*"; }
bad()  { echo "WARN  $*"; warn=1; }

for p in "$VIBE" "$VIBE"/*; do
  [[ -e "$p" ]] && echo "mode  $(stat -c '%a' "$p" 2>/dev/null || stat -f '%Lp' "$p")  $p"
done

if [[ -n "${MISTRAL_API_KEY+x}" ]]; then bad "MISTRAL_API_KEY is set in this shell"
else ok "MISTRAL_API_KEY not set in this shell"; fi

if grep -qs MISTRAL_API_KEY "$HOME/.bashrc" "$HOME/.profile" "$HOME/.zshrc"; then
  bad "MISTRAL_API_KEY appears in a shell profile"
else ok "not in shell profiles"; fi

if [[ -e "$VIBE/.env" ]]; then
  m="$(stat -c '%a' "$VIBE/.env" 2>/dev/null || stat -f '%Lp' "$VIBE/.env")"
  [[ "$m" == 600 ]] && ok "$VIBE/.env is 600" || bad "$VIBE/.env is $m, expected 600"
else ok "no $VIBE/.env"; fi

grep -qs '^default_agent' "$VIBE/config.toml" && ok "default_agent set" || bad "default_agent missing"
grep -qs '^\[tools.bash\]' "$VIBE/config.toml" && ok "[tools.bash] present" || bad "[tools.bash] missing"
grep -qs 'deny-secret-reads' "$VIBE/hooks.toml" && ok "hook entry present" || bad "hook entry missing"

exit $warn
