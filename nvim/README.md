# Neovim Config

Leader: `Space` — Local leader: `,`

Press `Space` and pause to see available bindings (which-key).

## Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move between windows |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<C-d>` / `<C-u>` | Scroll down / up (centered) |

## Files & Search (Telescope)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fk` | Keymaps |

## LSP

| Key | Action |
|-----|--------|
| `gd` | Definition |
| `gr` | References |
| `K` | Hover docs |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename |
| `<leader>lf` | Format (conform/ruff) |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>d` | Diagnostic float |

## Git (Gitsigns + LazyGit)

| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit |
| `<leader>gs` | Stage hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `]c` / `[c` | Next / prev hunk |

## Debugging (DAP)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>di/o/O` | Step into / over / out |
| `<leader>dr` | REPL |
| `<leader>du` | Toggle UI |
| `<leader>dt` | Terminate |
| `<leader>dpm/dpc` | Debug test method / class |

## Terminal

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle terminal |
| `<leader>tf` | Floating terminal |
| `<leader>tp` | Python REPL |

## Splits

| Key | Action |
|-----|--------|
| `<leader>sv` | Vertical split |
| `<leader>sh` | Horizontal split |

## Misc

| Key | Action |
|-----|--------|
| `<leader>e` | File explorer (Neo-tree) |
| `gcc` | Toggle line comment |
| `<leader>mp` | Markdown preview |
| `:Lazy` | Plugin manager |
| `:Mason` | LSP installer |
| `:ConformInfo` | Formatter status |
