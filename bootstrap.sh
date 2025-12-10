#!/usr/bin/env bash
set -euo pipefail
set -x

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This bootstrap expects macOS. Exiting." >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required. Install with:" >&2
  echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required (for vim-plug install). Install via Homebrew (brew install curl) and re-run." >&2
  exit 1
fi

brew bundle --file="${SCRIPT_DIR}/Brewfile"

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found on PATH. Install via pyenv (e.g., pyenv install 3.11.9 && pyenv global 3.11.9) or brew install python, then re-run." >&2
  exit 1
fi

mkdir -p "${HOME}/.vim/autoload" "${HOME}/.vim/colors" "${HOME}/.config/nvim"

if [[ ! -f "${HOME}/.vim/autoload/plug.vim" ]]; then
  curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

ln -sf "${SCRIPT_DIR}/vim/.vimrc" "${HOME}/.vimrc"
ln -sf "${SCRIPT_DIR}/vim/colors/azimuth_night.vim" "${HOME}/.vim/colors/azimuth_night.vim"
ln -sf "${SCRIPT_DIR}/nvim/init.vim" "${HOME}/.config/nvim/init.vim"
