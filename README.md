# dev-setup

Public dev bootstrap, Vim config, and coding agent prompts.

## Layout
- prompts/AGENTS.md – coding agent prompts.
- Brewfile – current Homebrew state (pyenv included; no pinned Python).
- bootstrap.sh – fail-fast setup for macOS; runs brew bundle, installs vim-plug, asserts python3 on PATH, symlinks configs.
- vim/.vimrc and vim/colors/azimuth_night.vim – Vim config and theme.
- vim/coc-settings.json – CoC settings from this machine.
- nvim/init.vim – points Neovim at the Vim config.

## Usage
```sh
chmod +x bootstrap.sh
./bootstrap.sh
# then inside Vim/Neovim
:PlugInstall
```

If bootstrap fails on python3, install via pyenv (e.g., `pyenv install 3.11.9 && pyenv global 3.11.9`) or `brew install python`, then rerun.
