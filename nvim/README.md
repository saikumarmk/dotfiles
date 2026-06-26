# Neovim Configuration for ML Engineering & Quarto Development

A comprehensive Neovim setup tailored for Machine Learning engineering with Python and Quarto document development with R and Python support.

> **📝 Recent Update:** Switched to `basedpyright` (modern Python LSP) and made R language server optional. See [SETUP_NOTES.md](SETUP_NOTES.md) for details.

## Features

### Core Features
- **Modern Plugin Manager**: lazy.nvim for fast plugin management
- **Beautiful UI**: Catppuccin Mocha color scheme with lualine status bar
- **LSP Support**: Full language server support for Python, R, Lua, Markdown, and more
- **Smart Autocompletion**: nvim-cmp with multiple sources
- **Syntax Highlighting**: Treesitter for advanced syntax highlighting

### ML/Data Science Features
- **Quarto Support**: Full integration with Quarto for literate programming
- **Jupyter Kernels**: Molten for running Python/R code in Jupyter kernels
- **Python Debugging**: nvim-dap with Python debugging support
- **REPL Integration**: Built-in Python and R REPL terminals
- **Markdown Preview**: Live preview for Markdown and Quarto files

### Developer Tools
- **File Explorer**: Neo-tree for easy file navigation
- **Fuzzy Finder**: Telescope for searching files, text, and more
- **Git Integration**: Gitsigns for git decorations and LazyGit for git management
- **Terminal**: Toggleterm for integrated terminal support
- **GitHub Copilot**: AI-powered code completion

## Installation

The configuration is already installed! On first launch, Neovim will automatically install all plugins via lazy.nvim.

## Getting Started

### First Launch

1. Open Neovim:
   ```bash
   nvim
   ```

2. Wait for plugins to install (this happens automatically)

3. After installation, check health:
   ```vim
   :checkhealth
   ```

4. View installed plugins:
   ```vim
   :Lazy
   ```

5. View and install LSP servers:
   ```vim
   :Mason
   ```

### Setting up Copilot (Optional)

If you want to use GitHub Copilot:

1. In Neovim, run:
   ```vim
   :Copilot auth
   ```

2. Follow the authentication steps in your browser

### Setting up Quarto

For Quarto preview to work, make sure you have Quarto installed:

```bash
brew install quarto  # On macOS
```

### Setting up R (Optional)

If you want R support:

```bash
brew install r  # On macOS
```

Then in R, install the language server:
```r
install.packages("languageserver")
```

## Key Bindings

See [KEYBINDINGS.md](KEYBINDINGS.md) for a complete list of keybindings.

### Quick Reference

**Leader Key**: `Space`

#### Essential Commands
- `<Space>ff` - Find files
- `<Space>fg` - Search text (grep)
- `<Space>e` - Toggle file explorer
- `<Space>w` - Save file
- `<Space>q` - Quit

#### LSP
- `gd` - Go to definition
- `K` - Show documentation
- `<Space>ca` - Code actions
- `<Space>rn` - Rename

#### Git
- `<Space>gg` - Open LazyGit
- `<Space>gs` - Stage hunk
- `]c` / `[c` - Next/previous git hunk

#### Terminal
- `<C-\>` - Toggle terminal
- `<Space>tp` - Python REPL
- `<Space>tr` - R REPL

#### Quarto
- `<Space>qp` - Preview Quarto document
- `<Space>rc` - Run current line/selection
- `<Space>ra` - Run all code

## Project Structure

```
~/.config/nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── config/
│   │   ├── settings.lua     # Neovim settings
│   │   └── keymaps.lua      # Global keymaps
│   └── plugins/
│       ├── colorscheme.lua  # Color scheme
│       ├── lsp.lua          # LSP configuration
│       ├── cmp.lua          # Autocompletion
│       ├── treesitter.lua   # Syntax highlighting
│       ├── telescope.lua    # Fuzzy finder
│       ├── neo-tree.lua     # File explorer
│       ├── git.lua          # Git integration
│       ├── terminal.lua     # Terminal integration
│       ├── quarto.lua       # Quarto support
│       ├── dap.lua          # Debugging
│       ├── copilot.lua      # GitHub Copilot
│       └── ui.lua           # UI enhancements
├── KEYBINDINGS.md           # Complete keybindings reference
└── README.md                # This file
```

## Customization

### Changing Color Scheme

Edit `~/.config/nvim/lua/plugins/colorscheme.lua` and change the `flavour` option:
- `latte` - Light theme
- `frappe` - Medium contrast
- `macchiato` - Higher contrast
- `mocha` - Dark theme (default)

### Adding More Plugins

1. Create a new file in `~/.config/nvim/lua/plugins/` (e.g., `myplugin.lua`)
2. Return a table with plugin configuration:
   ```lua
   return {
     "username/plugin-name",
     config = function()
       -- Plugin setup here
     end,
   }
   ```
3. Restart Neovim or run `:Lazy sync`

### Modifying Keybindings

Edit the relevant plugin file in `~/.config/nvim/lua/plugins/` or add global keybindings in `~/.config/nvim/lua/config/keymaps.lua`.

## Workflow Tips

### Python Development
1. Open a Python file
2. LSP will automatically start (Pyright)
3. Use `gd` to navigate to definitions
4. Use `<Space>ca` for code actions (imports, refactoring)
5. Use `<Space>db` to set breakpoints and `<Space>dc` to start debugging

### Quarto Documents
1. Open a `.qmd` file
2. Use `<Space>qp` to start preview
3. Run code chunks with `<Space>rc`
4. Use `<Space>mi` to initialize a Jupyter kernel
5. Use `<Space>me` to evaluate code in the kernel

### Git Workflow
1. Use `<Space>gg` to open LazyGit
2. Stage changes with `<Space>gs`
3. Navigate between changes with `]c` and `[c`
4. View blame with `<Space>gb`

## Troubleshooting

### LSP not working
1. Check if language server is installed: `:Mason`
2. Check LSP status: `:LspInfo`
3. Restart LSP: `:LspRestart`

### Plugins not loading
1. Check plugin status: `:Lazy`
2. Update plugins: `:Lazy update`
3. Clean and reinstall: `:Lazy clean` then `:Lazy sync`

### Treesitter errors
1. Update parsers: `:TSUpdate`
2. Check installed parsers: `:TSInstallInfo`

### Copilot not working
1. Check authentication: `:Copilot status`
2. Re-authenticate: `:Copilot auth`
3. Check if Node.js is installed: `node --version`

## Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [LSP Configuration Guide](https://github.com/neovim/nvim-lspconfig)
- [Quarto Documentation](https://quarto.org/)
- [Catppuccin Theme](https://github.com/catppuccin/nvim)

## Credits

This configuration uses the following amazing plugins:
- lazy.nvim - Plugin manager
- catppuccin - Color scheme
- nvim-lspconfig - LSP configuration
- nvim-cmp - Autocompletion
- nvim-treesitter - Syntax highlighting
- telescope.nvim - Fuzzy finder
- neo-tree.nvim - File explorer
- gitsigns.nvim - Git integration
- lazygit.nvim - Git UI
- toggleterm.nvim - Terminal integration
- quarto-nvim - Quarto support
- molten-nvim - Jupyter kernel integration
- nvim-dap - Debugging support
- copilot.lua - GitHub Copilot

And many more! See `:Lazy` for the complete list.

---

**Enjoy your new Neovim setup!**

For questions or issues, refer to the keybindings cheatsheet or the plugin documentation.
