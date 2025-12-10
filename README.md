# dev-setup

Public dev bootstrap, Vim config, and coding agent prompts.

## Layout
- prompts/AGENTS.md – coding agent prompts.
- Brewfile – current Homebrew state.
- bootstrap.sh – fail-fast setup for macOS; runs brew bundle, installs vim-plug, symlinks configs.
- vim/.vimrc and vim/colors/azimuth_night.vim – Vim config and theme.
- nvim/init.vim – points Neovim at the Vim config.

## Usage
```sh
chmod +x bootstrap.sh
./bootstrap.sh
# then inside Vim/Neovim
:PlugInstall
```
