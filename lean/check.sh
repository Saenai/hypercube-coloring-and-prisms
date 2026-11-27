#!/usr/bin/env bash
set -euo pipefail

# Use the toolchain selected by the lean-toolchain file beside this script.
cd -- "$(dirname -- "$0")"
lean_bin="$(lean --print-prefix)/bin"
work_dir="$(mktemp -d)"
trap 'rm -rf -- "$work_dir"' EXIT

lean -DwarningAsError=true -o "$work_dir/Prism.olean" Prism.lean
export LEAN_PATH="$work_dir"

# Nanoda checks the exported proof terms with an independent type checker.
cat > "$work_dir/nanoda.json" <<'JSON'
{
  "use_stdin": true,
  "permitted_axioms": ["propext", "Classical.choice", "Quot.sound"],
  "unpermitted_axiom_hard_error": true,
  "nat_extension": true,
  "string_extension": true,
  "pp_to_stdout": true,
  "print_success_message": true
}
JSON

"$lean_bin/leanexport" Prism -- Prism.prism_minimum Prism.bipartite_prism_minimum |
  "$lean_bin/nanoda_bin" "$work_dir/nanoda.json"
