# dev-setup

Core macOS development bootstrap: Homebrew dependencies, language runtimes, Vim/Neovim config, and a full-access Codex config.

This repo is meant to be easy for a coding agent to inspect and modify. It is not a full Mac personalization script: it does not manage SSH keys, GitHub auth, app logins, macOS defaults, project cloning, or private secrets. It does install the core pieces needed for coding work.

## Agent Orientation

Start with these files:

- `README.md` - usage, repo map, bootstrap flow, and validation commands.
- `bootstrap.sh` - the executable setup flow.
- `Brewfile` - Homebrew formulae and casks.
- `.codex/config.toml` - sanitized full-access Codex config.
- `vim/.vimrc` - Vim/Neovim plugins and editor behavior.

Do not run `./bootstrap.sh` casually while validating changes. It installs packages, language runtimes, Vim plugins, CoC extensions, and writes symlinks into the user home directory. Prefer the validation commands below unless you intentionally want to perform setup.

## Usage

```sh
git clone git@github.com:saulrichardson/dev-setup.git ~/projects/dev-setup
cd ~/projects/dev-setup
chmod +x bootstrap.sh
./bootstrap.sh
```

The script is intended to be idempotent and rerunnable. Run it as an executable script, not by sourcing it into the current shell.

## Shell Model

Modern macOS uses `zsh` as the default interactive shell. This repo keeps that model.

- `bootstrap.sh` is a Bash script because Bash is predictable for installer logic and is available on macOS.
- Running `./bootstrap.sh` does not change the login shell and does not switch the machine back to Bash.
- Future interactive terminal setup is written to `~/.zshrc`, because that is where the day-to-day zsh dev environment should be initialized.
- The managed `~/.zshrc` block configures Homebrew, `pyenv`, `fnm`, `rbenv`, `postgresql@18`, `rustup`, `direnv`, and `starship`.

In short: Bash runs the bootstrap; zsh remains the normal shell.

## Bootstrap Flow

`bootstrap.sh` runs in this order:

1. Verify macOS.
2. Load Homebrew shell environment if Homebrew already exists.
3. Install Homebrew if missing.
4. Check Xcode Command Line Tools. If missing, open the installer and exit.
5. Install all Homebrew dependencies from `Brewfile`.
6. Install Python through `pyenv`.
7. Install Node.js through `fnm`, with Corepack enabled.
8. Install Ruby through `rbenv`.
9. Install Rust through `rustup`.
10. Install `vim-plug`.
11. Link Vim, Neovim, CoC, and Codex config files.
12. Install Vim/Neovim plugins.
13. Install CoC extensions.
14. Write a managed `~/.zshrc` block for Homebrew, `pyenv`, `fnm`, `rbenv`, `postgresql@18`, `rustup`, `direnv`, and `starship`.

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

## Repo Map

- `.codex/config.toml` - sanitized Codex config. Keep it safe for a public repo; do not add tokens, private paths, or local app state.
- `.gitignore` - ignores local machine artifacts such as `.DS_Store`.
- `Brewfile` - declarative Homebrew dependencies.
- `README.md` - this orientation document.
- `bootstrap.sh` - macOS setup script.
- `nvim/init.vim` - Neovim entrypoint that reuses `~/.vimrc`.
- `vim/.vimrc` - Vim/Neovim plugin list, mappings, CoC extensions, and editor behavior.
- `vim/coc-settings.json` - CoC settings linked into Vim and Neovim config locations.
- `vim/colors/azimuth_night.vim` - custom colorscheme.

## Common Edits

- Add or remove command-line tools: edit `Brewfile`.
- Change install order, runtime setup, symlink targets, or shell initialization: edit `bootstrap.sh`.
- Change default Python/Node/Ruby/Rust versions: edit the defaults near the top of `bootstrap.sh` and update the Version Overrides section above.
- Change Vim plugins or editor behavior: edit `vim/.vimrc`.
- Change CoC settings: edit `vim/coc-settings.json`.
- Change Codex defaults: edit `.codex/config.toml`, keeping it public-safe.
- Change repo navigation or maintenance guidance: edit `README.md`.

## Validation

Run these before committing documentation or script changes:

```sh
bash -n bootstrap.sh
git diff --check
python3 - <<'PY'
from pathlib import Path
import tomllib
tomllib.loads(Path(".codex/config.toml").read_text())
print("codex config parsed")
PY
```

Check that Homebrew can parse the Brewfile without installing:

```sh
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file=Brewfile --verbose
```

`brew bundle check` may report unmet or outdated dependencies on the current machine. That is expected if the machine has not been synced to the Brewfile. Treat parser errors, missing formula names, or deprecated formula warnings as problems.

Check resolver behavior without running the full bootstrap:

```sh
tmp="$(mktemp)"
awk '/^main "\$@"/ {exit} {print}' bootstrap.sh > "$tmp"
bash -lc "source '$tmp'; resolve_pyenv_version \"\$PYTHON_VERSION\"; resolve_node_version \"\$NODE_VERSION\"; resolve_ruby_version \"\$RUBY_VERSION\""
rm -f "$tmp"
```

## After Bootstrap

Authenticate tools that require personal credentials:

```sh
gh auth login
codex login
```

## Boundaries

Keep this repo focused on core development setup. Avoid adding private credentials, machine-specific secrets, project clones, macOS preference automation, or personal app login state. If a dependency is useful for normal coding work, it belongs in `Brewfile`; if it is a one-off project dependency, leave it to that project.
