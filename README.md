# Low Plugin Neovim Configuration
Playing around with a low-plugin config for neovim based on https://github.com/smnatale/nvim_native

# Setup
1. Store new configuration files in a new folder under `~/.config/` named something like `nvim_native`.
Create an alias to keep separate nvim configurations, e.g., `alias nv='NVIM_APPNAME=nvim_native nvim'`
1. Install language servers for lua (lua_ls) and typescript (tsgo)

# Features
- Completions
- Colorscheme
- Diagnostics
- Ripgrep
- Find
- Netrw (filepane)
- Custome status bar with current git branch

# Quick Overview
- Leaderkey = <space>
- leader+e - Opens Netrw
- leader+g - Opens ripgrep
- leader+f - Opens :find with tab completion
- leader+d - Diagnostics

# Netrw
- d - Create directory
- % - Touch(create) a new file, does not open automatically
- D - Delete a file
