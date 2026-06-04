#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

need() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'missing required command: %s\n' "$1" >&2
    exit 127
  fi
}

need vhs
need asciinema

mkdir -p static/img/terminal static/casts generated/terminal

for tape in examples/terminal/*.tape; do
  printf 'rendering VHS tape: %s\n' "$tape"
  vhs "$tape"
done

for scenario in examples/terminal/*.sh; do
  name="$(basename "$scenario" .sh)"
  cast="static/casts/${name}.cast"
  text="generated/terminal/${name}.txt"

  printf 'recording asciinema cast: %s\n' "$cast"
  asciinema rec --overwrite --command "bash $scenario" "$cast"

  printf 'rendering text transcript: %s\n' "$text"
  asciinema cat "$cast" > "$text"
done
