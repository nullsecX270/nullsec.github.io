#!/usr/bin/env bash
#
# Scan files for URI protocols and print unique protocol names.
#
# Usage:
#   bash tools/scan-protocols.sh [path]

set -euo pipefail

target="${1:-.}"

if [[ ! -e "$target" ]]; then
  echo "Path not found: $target" >&2
  exit 1
fi

matches="$(
  grep -RhoE --binary-files=without-match "[[:alpha:]][[:alnum:]+.-]*://" "$target" 2>/dev/null || true
)"

if [[ -z "$matches" ]]; then
  echo "No protocols found."
  exit 0
fi

printf "%s\n" "$matches" \
  | sed -E 's#://$##' \
  | tr '[:upper:]' '[:lower:]' \
  | sort -u
