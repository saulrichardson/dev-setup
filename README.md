# dev-setup

Core macOS development bootstrap: Homebrew dependencies, language runtimes, Vim/Neovim config, and a full-access Codex config.

This is intentionally not a full Mac personalization script. It does not manage SSH keys, GitHub auth, app logins, macOS defaults, project cloning, or private secrets. It does download and install the core pieces needed for coding work.

## Usage

```sh
git clone git@github.com:saulrichardson/dev-setup.git ~/projects/dev-setup
cd ~/projects/dev-setup
chmod +x bootstrap.sh
./bootstrap.sh
```

The script is idempotent and can be rerun.

## What Bootstrap Installs

- Homebrew, if missing.
- Xcode Command Line Tools check. If missing, it opens the installer and exits so you can rerun afterward.
- All formulae/casks in `Brewfile`.
- Python through `pyenv`.
- Node.js through `fnm`, with Corepack enabled.
- Ruby through `rbenv`.
- Rust through `rustup`.
- `vim-plug`, Vim/Neovim plugins, and CoC extensions.
- Vim, Neovim, CoC, and Codex config symlinks.
- A managed `.zshrc` block for Homebrew, `pyenv`, `fnm`, `rbenv`, `direnv`, and `starship`.

## Version Overrides

Defaults:

```sh
PYTHON_VERSION=3.13
NODE_VERSION=lts
RUBY_VERSION=latest
RUST_TOOLCHAIN=stable
```

`PYTHON_VERSION=3.13` means the latest available 3.13 patch release from `pyenv`. `NODE_VERSION=lts` means the latest LTS from `fnm`. `RUBY_VERSION=latest` means the latest stable Ruby shown by `rbenv install --list`.

Override versions when running bootstrap:

```sh
PYTHON_VERSION=3.14 NODE_VERSION=24 RUBY_VERSION=3.4.7 ./bootstrap.sh
```

## Layout

- `.codex/config.toml` - sanitized full-access Codex config.
- `Brewfile` - core Homebrew dependencies.
- `bootstrap.sh` - macOS bootstrap.
- `prompts/AGENTS.md` - coding-agent instructions.
- `vim/.vimrc` - Vim/Neovim plugin and editor config.
- `vim/coc-settings.json` - CoC settings, linked for Vim and Neovim.
- `vim/colors/azimuth_night.vim` - custom colorscheme.
- `nvim/init.vim` - Neovim entrypoint that reuses the Vim config.

## After Bootstrap

Authenticate tools that require personal credentials:

```sh
gh auth login
codex login
```
