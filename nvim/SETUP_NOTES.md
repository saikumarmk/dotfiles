# Setup Notes & Troubleshooting

## Recent Updates

### Language Server Changes (Fixed)

**What was fixed:**
- Removed deprecated `pyright` → Replaced with `basedpyright`
- Removed auto-install of `r_language_server` (it was causing errors)
- R language server is now optional and must be manually installed

**What you need to do:**

1. **Clean up old LSP installations (recommended):**

   Open Neovim and run:
   ```vim
   :Mason
   ```

   Then:
   - Press `/` to search
   - Search for "pyright" (old version)
   - Press `X` to uninstall it if installed
   - Press `q` to close

2. **Restart Neovim:**
   ```bash
   nvim
   ```

   The new `basedpyright` will install automatically!

3. **Verify everything is working:**
   ```vim
   :checkhealth mason
   :LspInfo
   ```

### Optional: Install R Language Server

Only do this if you need R support:

1. **Install R:**
   ```bash
   brew install r
   ```

2. **Install R languageserver package:**
   ```bash
   R
   ```

   Then in R console:
   ```r
   install.packages("languageserver")
   quit()
   ```

3. **Install via Mason:**

   In Neovim:
   ```vim
   :Mason
   ```

   Search for "r-language-server" and press `i` to install

## Common Issues After Update

### "LSP not attaching to buffer"

**Solution:**
1. Restart Neovim completely
2. Run `:LspRestart`
3. Check `:LspInfo` to see active servers

### "basedpyright not found"

**Solution:**
1. Run `:Mason` and ensure basedpyright is installing
2. Wait for installation to complete (check `:MasonLog` for details)
3. Restart Neovim

### "Undefined global 'vim'" warnings in Lua files

**Solution:** This is normal and should be suppressed by the lua_ls configuration. If you still see it:
```vim
:LspRestart
```

## Verifying Your Setup

Run these commands in Neovim to check everything:

```vim
" Check overall health
:checkhealth

" Check Mason packages
:checkhealth mason

" Check LSP status
:LspInfo

" View Mason log (if issues)
:MasonLog

" Update all plugins
:Lazy sync
```

## Python LSP (basedpyright) Notes

**basedpyright** is a modern fork of pyright with additional features:
- Faster performance
- Better type inference
- Active development
- Drop-in replacement for pyright

All your Python development features work exactly the same:
- Go to definition (`gd`)
- Hover documentation (`K`)
- Code actions (`<Space>ca`)
- Rename (`<Space>rn`)
- Auto-imports
- Type checking

## If You Encounter Any Errors

1. **First, try a clean restart:**
   ```bash
   # Close Neovim completely
   # Then reopen
   nvim
   ```

2. **Check for errors:**
   ```vim
   :checkhealth
   :LspInfo
   :Mason
   ```

3. **View detailed logs:**
   ```vim
   :MasonLog
   :messages
   ```

4. **Clean install (if needed):**
   ```vim
   :Lazy clean
   :Lazy sync
   ```

   Then restart Neovim.

## Updated File

The following file was updated:
- `~/.config/nvim/lua/plugins/lsp.lua`

Changes:
- ✅ Switched from `pyright` to `basedpyright`
- ✅ Made R language server optional (prevents installation errors)
- ✅ Added safety checks for R language server setup
- ✅ Updated configuration with helpful comments

## Everything Else

All other plugins and configurations remain the same and are working perfectly:
- ✅ Quarto support
- ✅ Treesitter
- ✅ Telescope
- ✅ Git integration
- ✅ Terminal
- ✅ Debugging
- ✅ Copilot
- ✅ All other LSP servers (Lua, Markdown, JSON, YAML, Bash)

---

Last updated: $(date)
