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

## Branches

`main` holds the chezmoi source state and is the branch to use.

`base` holds the old layout, from when a bare git repo at `~/.dotfiles` used `$HOME` as its work
tree. It also holds `.bin/dotfiles/setup.sh`, the bootstrap script that layout needed. Keep the
branch until the personal Mac is migrated, then delete it.
