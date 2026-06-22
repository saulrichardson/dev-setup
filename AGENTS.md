# Agent Notes

This repo is a public macOS dev bootstrap. Keep changes focused on core development setup: package dependencies, language runtime bootstrap, Vim/Neovim config, Codex config, and documentation that helps another agent run or maintain those pieces.

## Navigation

- `README.md` is the primary orientation document. Update it when behavior, defaults, or file ownership changes.
- `bootstrap.sh` is the setup entrypoint. It performs installs and writes symlinks into the user home directory.
- `Brewfile` is the source of truth for Homebrew formulae/casks.
- `.codex/config.toml` is a public-safe Codex config. Do not add secrets, API keys, private paths, app state, or local auth material.
- `vim/.vimrc`, `vim/coc-settings.json`, `vim/colors/azimuth_night.vim`, and `nvim/init.vim` define the editor setup.
- `prompts/AGENTS.md` is a portable coding-agent prompt file, not instructions for maintaining this repo.

## Editing Rules

- Do not run `./bootstrap.sh` for routine validation. It installs packages, language runtimes, Vim plugins, CoC extensions, and writes into `~/.zshrc`, `~/.vim`, `~/.config/nvim`, and `~/.codex`.
- Prefer idempotent bootstrap changes. Re-running the script should not duplicate shell blocks or destroy existing non-managed user config.
- Keep public files free of secrets. Use environment-variable references or documented manual auth steps instead of embedding credentials.
- Keep dependencies current. If a formula is deprecated or disabled upstream, replace it with the current stable equivalent when practical.
- Keep the repo lightweight. Do not add project cloning, SSH key generation, app login state, macOS defaults, or personal-machine automation unless explicitly requested.

## Validation

Run these checks before committing:

```sh
bash -n bootstrap.sh
git diff --check
python3 - <<'PY'
from pathlib import Path
import tomllib
tomllib.loads(Path(".codex/config.toml").read_text())
print("codex config parsed")
PY
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file=Brewfile --verbose
```

`brew bundle check` can report unmet dependencies on the current machine. That is acceptable. Treat parse errors, unknown formulae, or deprecation warnings as problems.
