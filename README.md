# dev-setup

Public dev bootstrap, Vim config, and coding agent prompts.

## Layout
- prompts/AGENTS.md – coding agent prompts.
- Brewfile – current Homebrew state (includes python@3.14 for Vim/Neovim host).
- bootstrap.sh – fail-fast setup for macOS; runs brew bundle, installs vim-plug, checks python host path, symlinks configs.
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
