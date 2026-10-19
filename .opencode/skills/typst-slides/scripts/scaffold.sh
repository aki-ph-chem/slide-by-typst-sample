#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scaffold.sh <target-dir> [--build]

Create a new Typst/Touying slide project from the bundled template.

Options:
  --build    Run the first PDF build after scaffolding
  -h, --help Show this help
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 2
fi

target="$1"
shift

build=false

for arg in "$@"; do
  case "$arg" in
    --build)
      build=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      usage
      exit 2
      ;;
  esac
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
template_dir="$script_dir/../templates"

if [[ ! -d "$template_dir" ]]; then
  echo "Template directory not found: $template_dir" >&2
  exit 1
fi

if [[ -e "$target" ]] && [[ -n "$(ls -A "$target")" ]]; then
  echo "Target directory is not empty: $target" >&2
  exit 1
fi

mkdir -p "$target"
cp -R "$template_dir"/. "$target"/

if [[ ! -d "$target/.git" ]]; then
  git -C "$target" init -q
fi

git -C "$target" add .

if [[ "$build" == true ]]; then
  (
    cd "$target"
    nix develop -c typst compile slides.typ slides.pdf
  )
  if [[ -f "$target/flake.lock" ]]; then
    git -C "$target" add flake.lock
  fi
fi

echo "Created: $target"
echo
echo "Next:"
echo "  cd $target"
echo "  nix develop"
echo "  typst compile slides.typ slides.pdf"
