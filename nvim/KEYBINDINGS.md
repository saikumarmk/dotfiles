# Neovim Keybindings Cheatsheet

**Leader Key:** `Space`
**Local Leader Key:** `,`

## General

| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>x` | Save and quit |
| `<leader>h` | Clear search highlighting |

## Window Navigation

| Key | Action |
|-----|--------|
| `<C-h>` | Move to left window |
| `<C-j>` | Move to down window |
| `<C-k>` | Move to up window |
| `<C-l>` | Move to right window |

## Window Resizing

| Key | Action |
|-----|--------|
| `<C-Up>` | Decrease height |
| `<C-Down>` | Increase height |
| `<C-Left>` | Decrease width |
| `<C-Right>` | Increase width |

## Split Windows

| Key | Action |
|-----|--------|
| `<leader>sv` | Vertical split |
| `<leader>sh` | Horizontal split |

## Buffer Navigation

| Key | Action |
|-----|--------|
| `<S-l>` | Next buffer |
| `<S-h>` | Previous buffer |

## File Explorer (Neo-tree)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle Neo-tree |
| `<leader>o` | Focus Neo-tree |
| `<CR>` or `l` | Open file/folder |
| `h` | Close folder |
| `s` | Open in split |
| `v` | Open in vertical split |
| `t` | Open in new tab |

## Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search text) |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>fc` | Commands |
| `<leader>fk` | Keymaps |

## LSP (Language Server)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Show references |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `<leader>lf` | Format document (LSP) |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>d` | Show diagnostic float |

## Autocompletion (nvim-cmp)

| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selection |
| `<Tab>` | Next item / Expand snippet |
| `<S-Tab>` | Previous item |
| `<C-b>` | Scroll docs up |
| `<C-f>` | Scroll docs down |
| `<C-e>` | Abort completion |

## Git (Gitsigns)

| Key | Action |
|-----|--------|
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gS` | Stage buffer |
| `<leader>gu` | Undo stage hunk |
| `<leader>gR` | Reset buffer |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gtb` | Toggle current line blame |
| `<leader>gd` | Diff this |
| `<leader>gtd` | Toggle deleted |
| `<leader>gg` | Open LazyGit |
| `]c` | Next hunk |
| `[c` | Previous hunk |

## Terminal (ToggleTerm)

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle terminal |
| `<leader>tp` | Toggle Python REPL |
| `<leader>tr` | Toggle R REPL |
| `<leader>tf` | Toggle floating terminal |
| `<leader>th` | Toggle horizontal terminal |
| `<leader>tv` | Toggle vertical terminal |
| `<Esc>` (in terminal) | Exit terminal mode |

## Quarto

| Key | Action |
|-----|--------|
| `<leader>qp` | Quarto preview |
| `<leader>qq` | Close Quarto preview |
| `<leader>qh` | Quarto help |
| `<leader>qe` | Send code above |
| `<leader>qa` | Send all code |
| `<leader>rc` | Run current line/selection |
| `<leader>ra` | Run all |

## Molten (Jupyter Kernels)

| Key | Action |
|-----|--------|
| `<leader>mi` | Initialize Molten |
| `<leader>me` | Evaluate operator/visual |
| `<leader>ml` | Evaluate line |
| `<leader>mr` | Re-evaluate cell |
| `<leader>mo` | Show output |
| `<leader>mh` | Hide output |
| `<leader>md` | Delete cell |

## Markdown Preview

| Key | Action |
|-----|--------|
| `<leader>mp` | Start markdown preview |
| `<leader>ms` | Stop markdown preview |

## Debugging (DAP)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dL` | Logpoint (prints without stopping) |
| `<leader>dc` | Pick launch config & start |
| `<leader>dA` | Debug current file (prompt for args) |
| `<leader>dn` | New launch config (template wizard → run/save) |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>dr` | Toggle REPL |
| `<leader>dl` | Run last |
| `<leader>du` | Toggle DAP UI |
| `<leader>dt` | Terminate |
| `<leader>dpm` | Debug Python test method |
| `<leader>dpc` | Debug Python test class |
| `<leader>dps` | Debug Python selection |

## GitHub Copilot

| Key | Action |
|-----|--------|
| `<M-l>` | Accept suggestion |
| `<M-]>` | Next suggestion |
| `<M-[>` | Previous suggestion |
| `<C-]>` | Dismiss suggestion |
| `<leader>cp` | Open Copilot panel |
| `<leader>ce` | Enable Copilot |
| `<leader>cd` | Disable Copilot |
| `<leader>cs` | Copilot status |

## Treesitter Text Objects

| Key | Action |
|-----|--------|
| `<CR>` | Incremental selection |
| `<BS>` | Decremental selection |
| `af` | Around function |
| `if` | Inside function |
| `ac` | Around class |
| `ic` | Inside class |
| `]f` | Next function start |
| `[f` | Previous function start |
| `]c` | Next class start |
| `[c` | Previous class start |

## Comments (Comment.nvim)

| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc` (visual) | Toggle comment for selection |

## Surround (nvim-surround)

| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surrounding |
| `ds{char}` | Delete surrounding |
| `cs{target}{replacement}` | Change surrounding |

Examples:
- `ysiw"` - Surround word with "
- `ds"` - Delete surrounding "
- `cs"'` - Change " to '

## Visual Mode

| Key | Action |
|-----|--------|
| `<` | Decrease indent (stay in visual) |
| `>` | Increase indent (stay in visual) |
| `J` | Move selection down |
| `K` | Move selection up |
| `p` | Paste without yanking |

## Scrolling

| Key | Action |
|-----|--------|
| `<C-d>` | Scroll down (centered) |
| `<C-u>` | Scroll up (centered) |
| `n` | Next search (centered) |
| `N` | Previous search (centered) |

## Tips

1. Press `<Space>` and wait to see available keybindings (which-key)
2. Use `:Telescope keymaps` to search all keymaps
3. Use `:checkhealth` to verify plugin installation
4. Use `:Lazy` to manage plugins
5. Use `:Mason` to manage LSP servers
