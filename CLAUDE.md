# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

The chezmoi **source state** for macOS dotfiles. Files here are not live configs — `chezmoi apply`
copies/renders them into `$HOME`. This directory is itself `~/.local/share/chezmoi`, so editing a
file here is editing the source; the copy in `$HOME` is stale until applied.

## Commands

No build or test system. The verification loop is:

```
chezmoi diff                                   # what apply would change — run before every apply
chezmoi apply                                  # write source state to $HOME
chezmoi execute-template < dot_zshrc.tmpl      # render one template without applying
chezmoi managed                                # list everything chezmoi owns
chezmoi re-add                                 # pull edits made directly in $HOME back to source
```

After changing `dot_zshrc.tmpl` or `dot_zshenv`, check with `exec zsh` — a syntax error there
breaks every new shell.

Commits follow conventional-commit prefixes (`feat(zsh):`, `chore(nvim):`, `docs:`).

## Filename prefixes are metadata

chezmoi decodes the target path and attributes from the source filename. Never rename a file to
what you want in `$HOME`; encode it:

- `dot_` → leading `.` (`dot_zshrc.tmpl` → `~/.zshrc`)
- `.tmpl` → rendered as a Go template (suffix is stripped)
- `executable_`, `empty_`, `private_`, `symlink_` → mode/attribute (`empty_` matters:
  without it a zero-byte target is deleted; `symlink_theme.yml.tmpl` renders to a *link target path*)
- `.chezmoiignore` lists source files that are never applied (currently `README.md`)

## Theming architecture

One switch drives seven tools. `.chezmoidata/themes.yaml` is loaded into template data:

- `theme:` — the active key
- `themes.<key>.<tool>` — that tool's own spelling of the theme name (they all differ)

Every themed config is a `.tmpl` opening with `{{ $theme := index .themes .theme -}}`, then
interpolating one field: `dot_config/{ghostty,bat,yazi,eza,starship}/…`, `dot_zshrc.tmpl` (fzf),
`dot_config/nvim/lua/plugins/colorscheme.lua.tmpl`.

Two special cases: `fzf` has no named themes, so its value is the literal `--color=…` string;
`nvim_plugin` is optional and only present for colorschemes LazyVim doesn't ship (onedark needs it,
catppuccin/tokyonight don't). eza is a symlink template — the theme file must exist at
`dot_config/eza/themes/<eza key>.yml` or the link dangles.

Adding a theme means adding a catalog block **and** vendoring assets the tools don't ship (bat
`.tmTheme`, eza `.yml`, yazi `.yazi` flavor dir). bat and yazi are both syntect, so a flavor's
`tmtheme.xml` doubles as the bat theme — what ayu-dark does, at the cost of sparser scope
coverage. ayu's copy is patched (one added rule for JSON keys) and must stay byte-identical
across `dot_config/bat/themes/` and the flavor dir; upgrading the flavor reverts it. README.md
has the per-tool source table and the list of what limits theme choice (yazi flavors are the
bottleneck).

## zsh layout

`dot_zshenv` runs in **every** shell (including non-login GUI/IDE/launchd shells) and owns
`_toolchain_path`: it sets SDKMAN `*_HOME` vars and the default node bin dir on `PATH` directly,
without sourcing `sdkman-init.sh` or `nvm.sh` (~85ms of forks avoided). `dot_zprofile` calls
`_toolchain_path` again because `/etc/zprofile`'s `path_helper` runs after it and would otherwise
demote those entries. `dot_zshrc.tmpl` is interactive-only and lazy-loads `sdk`/`nvm`/`node`.

Both files source optional `~/.zshrc_work` / `~/.zshenv_work` (untracked, machine-local overrides).
In `.zshrc` the work file is sourced *before* the ZLE plugins — `zsh-syntax-highlighting` must stay
the last thing sourced.

## Other

- `dot_bin/dotfiles/Brewfile{Base,Personal,Work}` — Base on every machine plus one of the others.
- `dot_config/nvim` is a LazyVim install; only `lua/config/*` and `lua/plugins/*` are hand-edited.
- kitty, sketchybar and neofetch configs are present but unused; Zed is themed in its own UI,
  deliberately outside the template system.
- Branch `main` is the chezmoi source state. `base` holds the pre-chezmoi bare-repo layout and is
  kept only until the personal Mac is migrated.
