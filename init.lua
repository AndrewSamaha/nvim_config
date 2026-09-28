vim.g.mapleader = " "

require("options")
require("lsp")
require("colorscheme")
require("netrw")
require("keymaps")
require("statusline")
require("find")
require("grep")
require("autocommands")
require("diagnostics")

vim.pack.add({
  "https://github.com/sphamba/smear-cursor.nvim",
})
require("smear_cursor").setup({})

