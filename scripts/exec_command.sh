#!/usr/bin/env bash
# exec_command.sh
# Wrapper that prefers the Python exec_command (if present), otherwise does a simple bash fallback expansion.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PY_SCRIPT="$SCRIPT_DIR/exec_command"

# Prefer Python implementation if available
if command -v python3 >/dev/null 2>&1 && [ -f "$PY_SCRIPT" ]; then
  exec python3 "$PY_SCRIPT" "$@"
elif command -v python >/dev/null 2>&1 && [ -f "$PY_SCRIPT" ]; then
  exec python "$PY_SCRIPT" "$@"
fi

# Fallback: naive bash expansion (best-effort)
if [ $# -lt 1 ]; then
  echo "usage: exec_command.sh <command> [args...]" >&2
  exit 2
fi

cmd="$1"
shift

expanded_args=()
for a in "$@"; do
  # Use eval to expand env vars, ~, and command substitutions like $(...)
  # Note: this will evaluate potentially arbitrary content; prefer the Python script when possible.
  expanded=$(eval "printf '%s' $a")
  expanded_args+=("$expanded")
done

exec "$cmd" "${expanded_args[@]}"
