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
  end,
})

vim.keymap.set("n", "<leader>e", ":Lexplore<cr>", { silent = true })


