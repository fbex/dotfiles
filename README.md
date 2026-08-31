# Dotfiles

My dotfiles, editor and terminal configs, and the Homebrew package lists that go with them.

[chezmoi](https://www.chezmoi.io) manages them. This repository is the source state: `dot_zshrc`
here becomes `~/.zshrc` on the machine, and `chezmoi apply` does the writing. Filename prefixes
carry file metadata, so `executable_launchKitty.sh` lands as an executable and
`empty_dot_hushlogin` stays empty instead of being deleted.

## Set up a new machine

1. Install [Homebrew](https://brew.sh):

    ```
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

2. Install chezmoi and apply these dotfiles:

    ```
    brew install chezmoi
    chezmoi init --apply --ssh fbex/dotfiles
    ```

    `--apply` writes the files straight away. To read them before anything touches `$HOME`, drop
    the flag, then run `chezmoi diff` and `chezmoi apply` yourself.

    `--ssh` clones over SSH (`git@github.com:fbex/dotfiles.git`) so pushes work without a further
    step. Without it chezmoi clones over HTTPS, and the remote has to be switched afterwards with
    `chezmoi git -- remote set-url origin git@github.com:fbex/dotfiles.git`.

3. Install the software sets. `BrewfileBase` goes on every machine. Add one of the other two:

    ```
    brew bundle --file ~/.bin/dotfiles/BrewfileBase
    brew bundle --file ~/.bin/dotfiles/BrewfilePersonal
    ```

4. Install [SDKMAN](https://sdkman.io/install) by hand. `~/.zshenv` puts every installed candidate
   on `PATH` and exports its `*_HOME` variable, so no further setup is needed.

5. Restart the shell with `exec zsh`.

## Change a dotfile

The source state and `$HOME` are separate copies, so an edit has to travel between them.

To edit a file through chezmoi, run `chezmoi edit ~/.zshrc`. This opens the source file. Then run
`chezmoi diff` and `chezmoi apply`.

If you edited `~/.zshrc` directly instead, run `chezmoi re-add` to copy the change back into the
source state.

Either way, commit and push from the source directory. The alias `d` opens lazygit there.

| Command | What it does |
| --- | --- |
| `chezmoi diff` | Shows what `apply` would change. Worth running first, every time. |
| `chezmoi apply` | Writes the source state to `$HOME`. |
| `chezmoi edit <target>` | Edits the source file for a target. |
| `chezmoi re-add` | Copies edits made directly in `$HOME` back into the source state. |
| `chezmoi add <target>` | Starts managing a new file. |
| `chezmoi update` | Pulls from this repository, then applies. |
| `chezmoi cd` | Opens a subshell in the source directory. |
| `chezmoi managed` | Lists every file and directory chezmoi manages. |
| `chezmoi doctor` | Checks the installation and reports problems. |

## Theming

Ghostty, bat, eza, fzf, Neovim, starship and yazi all follow one setting: `theme:` at the top of
`.chezmoidata/themes.yaml`. Change it, run `chezmoi apply`, and the seven configs are rewritten
together. Zed is deliberately outside this and is themed in its own UI; kitty and sketchybar are
unused.

The rest of that file is the catalog: one block per theme, one key per tool holding *that tool's*
name for it, because they all spell it differently.

```yaml
theme: onedark          # the only switch

themes:
  onedark:
    ghostty: Atom One Dark
    bat: TwoDark
    nvim: onedark
    nvim_plugin: navarasu/onedark.nvim   # optional, see below
    yazi: onedark
    starship: onedark
    eza: onedark
    fzf: >-
      --color=bg+:#2C313C,bg:#21252B,...
```

The configs that consume it are templates, each opening with
`{{ $theme := index .themes .theme -}}`. `fzf` has no named themes anywhere, so its key holds the
literal `--color` string. `nvim_plugin` is optional and only needed for colorschemes LazyVim
doesn't already ship — catppuccin and tokyonight it does, onedark it doesn't.

### Adding a theme

Copy a block, fill in each tool's name for the theme, then install whatever assets don't ship with
the tool:

| Tool | Where themes come from |
| --- | --- |
| ghostty | Built in, 460+ of them. `ghostty +list-themes`. Nothing to install. |
| bat | Built in. `bat --list-themes`. Otherwise drop a `.tmTheme` in `dot_config/bat/themes/` and run `bat cache --build`. |
| eza | [eza-community/eza-themes](https://github.com/eza-community/eza-themes) or [catppuccin/eza](https://github.com/catppuccin/eza). Save as `dot_config/eza/themes/<eza key>.yml` — the filename must match the key, since `theme.yml` is a symlink to it. |
| yazi | [yazi-rs/flavors](https://github.com/yazi-rs/flavors), then its `themes.md` community list. `ya pkg add <repo>:<flavor>`, or copy the `.yazi` directory into `dot_config/yazi/flavors/`. |
| nvim | The colorscheme's own plugin. Check the names it registers with `:colorscheme <Tab>`. |
| starship | No catalog exists. Hand-write a `[palettes.<name>]` block in `starship.toml.tmpl`. |
| fzf | No catalog exists. Hand-write the `--color` string. |

For the two hand-written ones, Ghostty's theme files are the palette source. They are plain text at
`~/Applications/Ghostty.app/Contents/Resources/ghostty/themes/<Theme Name>` and carry the 16 ANSI
colors plus background, foreground, cursor and selection.

Assets for the four Catppuccin flavours and One Dark are already vendored.

### What limits the choice

yazi is the bottleneck, with five official flavours and roughly six community ones. Catppuccin and
Dracula are the only themes with first-party ports for all seven tools. Anything else needs a
community yazi flavour, as One Dark does, or a compromise elsewhere — One Dark borrows bat's
`TwoDark`, the closest built-in, and its ~10 colors are mapped onto starship's 26 Catppuccin-named
palette slots, so some names reuse hues.

### Gotcha

Environment variables beat config files. `BAT_THEME` was exported in `.zprofile` and silently
overrode `bat/config`, pinning bat to Catppuccin whatever the theme said. It has been removed. If a
tool ignores its themed config, look for an env var override first.

## Branches

`main` holds the chezmoi source state and is the branch to use.

`base` holds the old layout, from when a bare git repo at `~/.dotfiles` used `$HOME` as its work
tree. It also holds `.bin/dotfiles/setup.sh`, the bootstrap script that layout needed. Keep the
branch until the personal Mac is migrated, then delete it.
