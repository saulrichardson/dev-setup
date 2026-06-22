#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${BASH_VERSION:-}" ]]; then
  printf 'ERROR: run this script with bash: ./bootstrap.sh\n' >&2
  return 1 2>/dev/null || exit 1
fi

SCRIPT_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_DIR="$(cd -- "$(dirname "${SCRIPT_PATH}")" && pwd)"

PYTHON_VERSION="${PYTHON_VERSION:-3.13}"
NODE_VERSION="${NODE_VERSION:-lts}"
RUBY_VERSION="${RUBY_VERSION:-latest}"
RUST_TOOLCHAIN="${RUST_TOOLCHAIN:-stable}"

log() {
  printf '\n==> %s\n' "$*"
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

ensure_macos() {
  [[ "$(uname -s)" == "Darwin" ]] || die "This bootstrap expects macOS."
}

load_brew_shellenv() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  command -v curl >/dev/null 2>&1 || die "curl is required to install Homebrew."
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew_shellenv
  command -v brew >/dev/null 2>&1 || die "Homebrew installed, but brew is still not on PATH."
}

ensure_xcode_tools() {
  if xcode-select -p >/dev/null 2>&1; then
    return
  fi

  log "Launching Xcode Command Line Tools installer"
  xcode-select --install || true
  die "Install Xcode Command Line Tools, then rerun bootstrap.sh."
}

install_homebrew_dependencies() {
  log "Installing Homebrew dependencies"
  brew bundle install --file="${SCRIPT_DIR}/Brewfile"
}

resolve_pyenv_version() {
  local requested="$1"

  if [[ "$requested" == "latest" ]]; then
    pyenv install --list |
      sed 's/^[[:space:]]*//' |
      grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' |
      tail -1
    return
  fi

  if [[ "$requested" =~ ^[0-9]+\.[0-9]+$ ]]; then
    pyenv install --list |
      sed 's/^[[:space:]]*//' |
      grep -E "^${requested//./\\.}\\.[0-9]+$" |
      tail -1
    return
  fi

  printf '%s\n' "$requested"
}

install_python() {
  command -v pyenv >/dev/null 2>&1 || die "pyenv was not installed by Homebrew."

  export PYENV_ROOT="${PYENV_ROOT:-${HOME}/.pyenv}"
  mkdir -p "${PYENV_ROOT}"
  export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"
  eval "$(pyenv init -)"

  local version
  version="$(resolve_pyenv_version "${PYTHON_VERSION}")"
  [[ -n "$version" ]] || die "Could not resolve PYTHON_VERSION=${PYTHON_VERSION}."

  log "Installing Python ${version} with pyenv"
  pyenv install --skip-existing "$version"
  pyenv global "$version"
  pyenv rehash
  python -m pip install --upgrade pip setuptools wheel
}

resolve_node_version() {
  local requested="$1"

  if [[ "$requested" == "lts" ]]; then
    fnm list-remote --lts --latest | awk '{print $1}'
    return
  fi

  printf '%s\n' "$requested"
}

install_node() {
  command -v fnm >/dev/null 2>&1 || die "fnm was not installed by Homebrew."

  eval "$(fnm env --shell bash --corepack-enabled)"

  local version
  version="$(resolve_node_version "${NODE_VERSION}")"
  [[ -n "$version" ]] || die "Could not resolve NODE_VERSION=${NODE_VERSION}."

  log "Installing Node ${version} with fnm"
  fnm install "$version" --corepack-enabled
  fnm default "$version"
  fnm use "$version"
  corepack enable
}

resolve_ruby_version() {
  local requested="$1"

  if [[ "$requested" == "latest" ]]; then
    rbenv install --list | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | tail -1
    return
  fi

  printf '%s\n' "$requested"
}

install_ruby() {
  command -v rbenv >/dev/null 2>&1 || die "rbenv was not installed by Homebrew."

  export RBENV_ROOT="${RBENV_ROOT:-${HOME}/.rbenv}"
  mkdir -p "${RBENV_ROOT}"
  export PATH="${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:${PATH}"
  eval "$(rbenv init - bash)"

  local version
  version="$(resolve_ruby_version "${RUBY_VERSION}")"
  [[ -n "$version" ]] || die "Could not resolve RUBY_VERSION=${RUBY_VERSION}."

  log "Installing Ruby ${version} with rbenv"
  rbenv install --skip-existing "$version"
  rbenv global "$version"
  rbenv rehash
}

install_rust() {
  if ! command -v rustup >/dev/null 2>&1; then
    local rustup_prefix
    rustup_prefix="$(brew --prefix rustup 2>/dev/null || true)"
    if [[ -n "$rustup_prefix" && -x "${rustup_prefix}/bin/rustup" ]]; then
      export PATH="${rustup_prefix}/bin:${PATH}"
    fi
  fi

  command -v rustup >/dev/null 2>&1 || die "rustup was not installed by Homebrew."

  export PATH="${HOME}/.cargo/bin:${PATH}"

  log "Installing Rust ${RUST_TOOLCHAIN} toolchain"
  rustup default "$RUST_TOOLCHAIN"
}

install_vim_plug() {
  command -v curl >/dev/null 2>&1 || die "curl is required for vim-plug install."

  mkdir -p "${HOME}/.vim/autoload" "${HOME}/.vim/colors" "${HOME}/.config/nvim"

  if [[ ! -f "${HOME}/.vim/autoload/plug.vim" ]]; then
    log "Installing vim-plug"
    curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
}

link_configs() {
  log "Linking editor and Codex configs"

  mkdir -p "${HOME}/.vim/colors" "${HOME}/.config/nvim" "${HOME}/.codex"

  ln -sf "${SCRIPT_DIR}/vim/.vimrc" "${HOME}/.vimrc"
  ln -sf "${SCRIPT_DIR}/vim/colors/azimuth_night.vim" "${HOME}/.vim/colors/azimuth_night.vim"
  ln -sf "${SCRIPT_DIR}/vim/coc-settings.json" "${HOME}/.vim/coc-settings.json"
  ln -sf "${SCRIPT_DIR}/vim/coc-settings.json" "${HOME}/.config/nvim/coc-settings.json"
  ln -sf "${SCRIPT_DIR}/nvim/init.vim" "${HOME}/.config/nvim/init.vim"

  if [[ -e "${HOME}/.codex/config.toml" && ! -L "${HOME}/.codex/config.toml" ]]; then
    cp "${HOME}/.codex/config.toml" "${HOME}/.codex/config.toml.bak-$(date +%Y%m%d%H%M%S)"
  fi
  ln -sf "${SCRIPT_DIR}/.codex/config.toml" "${HOME}/.codex/config.toml"
}

install_vim_plugins() {
  command -v nvim >/dev/null 2>&1 || die "neovim was not installed by Homebrew."

  log "Installing Vim/Neovim plugins"
  nvim -es -u "${HOME}/.config/nvim/init.vim" -i NONE -c "PlugInstall --sync" -c "qa"

  log "Installing CoC extensions"
  nvim --headless -u "${HOME}/.config/nvim/init.vim" \
    "+CocInstall -sync coc-snippets coc-pairs coc-json coc-tsserver coc-python" \
    +qa
}

install_shell_profile_block() {
  local zshrc="${HOME}/.zshrc"
  local begin="# >>> dev-setup >>>"
  local end="# <<< dev-setup <<<"
  local tmp

  log "Installing managed shell initialization block"
  touch "$zshrc"

  tmp="$(mktemp)"
  awk -v begin="$begin" -v end="$end" '
    $0 == begin { skip = 1; next }
    $0 == end { skip = 0; next }
    skip != 1 { print }
  ' "$zshrc" >"$tmp"
  mv "$tmp" "$zshrc"

  cat >>"$zshrc" <<'EOF'

# >>> dev-setup >>>
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

command -v fnm >/dev/null 2>&1 && eval "$(fnm env --use-on-cd --shell zsh --corepack-enabled)"

export RBENV_ROOT="${RBENV_ROOT:-$HOME/.rbenv}"
[[ -d "$RBENV_ROOT/bin" ]] && export PATH="$RBENV_ROOT/bin:$PATH"
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init - zsh)"

if command -v brew >/dev/null 2>&1; then
  postgres_prefix="$(brew --prefix postgresql@18 2>/dev/null || true)"
  [[ -n "$postgres_prefix" && -d "$postgres_prefix/bin" ]] && export PATH="$postgres_prefix/bin:$PATH"

  rustup_prefix="$(brew --prefix rustup 2>/dev/null || true)"
  [[ -n "$rustup_prefix" && -d "$rustup_prefix/bin" ]] && export PATH="$rustup_prefix/bin:$PATH"
fi
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
# <<< dev-setup <<<
EOF
}

main() {
  ensure_macos
  load_brew_shellenv
  ensure_homebrew
  ensure_xcode_tools
  install_homebrew_dependencies
  install_python
  install_node
  install_ruby
  install_rust
  install_vim_plug
  link_configs
  install_vim_plugins
  install_shell_profile_block

  log "Done"
}

main "$@"
