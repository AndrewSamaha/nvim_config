local function touch_netrw_file()
  local name = vim.fn.input("New file: ")
	if name == "" then
    return
  end

	local path = vim.fs.joinpath(vim.b.netrw_curdir, name)
	vim.fn.system({ "touch", path })

	if vim.v.shell_error ~= 0 then
    vim.notify("Could not create " .. path, vim.log.levels.ERROR)
		return
  end

	--vim.api.nvim_feedkeys(vim.keycode("<C-l>"), "m", false)
	vim.fn["netrw#Call"]("NetrwRefresh", 1, vim.b.netrw_curdir)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
	callback = function(ev)
    vim.keymap.set("n", "%", touch_netrw_file, { buffer = ev.buf })

    -- Netrw maps left-click to its file-browser handler.  Let Neovim handle
    -- it normally so clicks and drags on the split separator can resize it.
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ev.buf) and vim.bo[ev.buf].filetype == "netrw" then
        pcall(vim.keymap.del, "n", "<LeftMouse>", { buffer = ev.buf })
      end
    end)
  end,
})

vim.keymap.set("n", "<leader>e", ":Lexplore<cr>", { silent = true })

