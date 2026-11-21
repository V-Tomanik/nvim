# neovim

Meu setup e configurações do melhor editor de textos de todos os tempos!

A full "code station" for Python, web (JS/TS/HTML/CSS) and Lua on macOS:
**Ghostty** → **tmux** → **zsh** → **Neovim**, one Catppuccin Mocha theme across all of them.

## Install on a new Mac

```bash
xcode-select --install                       # if you don't have it yet
# Homebrew: https://brew.sh
git clone https://github.com/V-Tomanik/nvim ~/.config/nvim
bash ~/.config/nvim/station/install.sh
```

The installer is safe to re-run. It never deletes files: existing Ghostty/tmux configs are moved
to `~/.config/station-backup-<date>/`.

First `nvim` start downloads plugins (confirm the prompt), then Mason installs the language
servers in the background — watch with `:Mason`.

## Layout

```
init.lua            options, keymaps, loads the modules below
lua/plugins.lua     UI, search, git, file explorer, tmux navigation
lua/completion.lua  blink.cmp autocomplete + snippets
lua/lsp.lua         language servers, formatting
lua/treesitter.lua  syntax parsers
station/            everything outside Neovim (Brewfile, Ghostty, tmux, zsh, installer)
```

| Language | Language server | Formatter (on save) |
|---|---|---|
| Python | basedpyright (types) + ruff (lint) | ruff (imports + format) |
| JS / TS | vtsls + eslint | prettierd |
| HTML / CSS / JSON | html, cssls, jsonls | prettierd |
| Lua | lua_ls | stylua |

Python projects: create them with `uv init` / `uv add numpy` — basedpyright finds the `.venv` automatically.

## Keymaps cheat sheet

Leader is `Space`. Press it and wait: which-key shows everything available.

**Moving around**

| Keys | Action |
|---|---|
| `Ctrl+h/j/k/l` | move between nvim splits **and** tmux panes |
| `-` | file explorer (oil): edit the listing like text, `:w` to apply |
| `Space Space` | open buffers |
| `Space sf` / `Space sg` | search files / grep text |
| `Space s.` | recent files |
| `Space sn` | search this nvim config |

**Code**

| Keys | Action |
|---|---|
| `grd` / `grr` | go to definition / references |
| `grn` / `gra` | rename / code action |
| `K` | hover docs |
| `[d` / `]d` | previous / next diagnostic |
| `Space f` | format now |
| `Space tf` | toggle format on save |
| `Space th` | toggle inlay hints |
| `Ctrl+Space` | open completion; `Ctrl+y` accepts, `Ctrl+n/p` move |

**Git**

| Keys | Action |
|---|---|
| `Space gg` | lazygit (float) |
| `]c` / `[c` | next / previous change |
| `Space hs` / `Space hr` | stage / reset hunk |
| `Space hp` / `Space hb` | preview hunk / blame line |

**tmux** (prefix = `Ctrl+a`)

| Keys | Action |
|---|---|
| `tm` / `tm <name>` (shell) | open the tmux session for this folder / for a zoxide match |
| `prefix \|` / `prefix -` | split side by side / stacked |
| `prefix c` | new window |
| `prefix s` | switch session |
| `prefix g` | lazygit popup |
| `prefix d` | detach (everything keeps running) |
| `prefix [` | scroll/copy mode (`v` select, `y` copy) |
| `prefix r` | reload tmux config |

**Shell**

| Command | Action |
|---|---|
| `z <part of folder name>` | jump to a folder you've visited |
| `v` / `lg` | nvim / lazygit |

## Updating

- Plugins: `:lua vim.pack.update()` (review, then `:write` to apply). Versions are pinned in `nvim-pack-lock.json`.
- Language servers: `:Mason`, then `U`.
- CLI tools: `brew upgrade`.
