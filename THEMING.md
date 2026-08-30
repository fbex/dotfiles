# Theming

One switch: `theme:` at the top of `themes.yaml`, then `chezmoi apply`.

Covers ghostty, bat, eza, fzf, nvim, starship, yazi. Zed is deliberately
out (managed in its own UI); kitty and sketchybar are unused.

## Adding a theme

1. Copy a block under `themes:` and fill in each tool's own name for it —
   they all differ (`Catppuccin Mocha` / `catppuccin_mocha` /
   `catppuccin-mocha`). `fzf` has no named themes, so it holds the literal
   `--color` string.
2. Install the assets that don't ship with the tool:
   - **bat** — drop the `.tmTheme` in `dot_config/bat/themes/`, then
     `bat cache --build`
   - **eza** — drop the theme yml in `dot_config/eza/themes/<eza key>.yml`
     (filename must match the `eza:` key)
   - **yazi** — `ya pkg add <repo>:<flavor>`, or copy the `.yazi` dir into
     `dot_config/yazi/flavors/`
   - **nvim** — add the colorscheme plugin under `dot_config/nvim/lua/plugins/`
   - ghostty and starship need nothing: ghostty has 460+ built-ins,
     starship's palettes are defined inline in `starship.toml.tmpl`

Assets for all four catppuccin flavours are already vendored.
