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

local function netrw_left_click()
  local mouse = vim.fn.getmousepos()
  if mouse.winid == 0 or not vim.api.nvim_win_is_valid(mouse.winid) then
    return
  end

  local buf = vim.api.nvim_win_get_buf(mouse.winid)
  if vim.bo[buf].filetype ~= "netrw" or mouse.line < 1 or mouse.line > vim.api.nvim_buf_line_count(buf) then
    return
  end

  local line = vim.api.nvim_buf_get_lines(buf, mouse.line - 1, mouse.line, false)[1]
  if mouse.column < 1 or mouse.column > vim.fn.strdisplaywidth(line) then
    return
  end

  local byte_col = vim.fn.virtcol2col(mouse.winid, mouse.line, mouse.column)
  vim.api.nvim_win_set_cursor(mouse.winid, { mouse.line, math.min(byte_col - 1, #line) })
  vim.api.nvim_feedkeys(vim.keycode("<CR>"), "mx", false)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
	callback = function(ev)
    vim.keymap.set("n", "%", touch_netrw_file, { buffer = ev.buf })

    -- Netrw's stock mouse handler causes E21 in this terminal.  Handle entry
    -- clicks directly and consume double-clicks so they do not start Visual mode.
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ev.buf) and vim.bo[ev.buf].filetype == "netrw" then
        pcall(vim.keymap.del, "n", "<LeftMouse>", { buffer = ev.buf })
        pcall(vim.keymap.del, "n", "<2-LeftMouse>", { buffer = ev.buf })
        vim.keymap.set("n", "<LeftMouse>", netrw_left_click, { buffer = ev.buf, silent = true })
        vim.keymap.set("n", "<2-LeftMouse>", "<Nop>", { buffer = ev.buf, silent = true })
      end
    end)
  end,
})

vim.keymap.set("n", "<leader>e", ":Lexplore<cr>", { silent = true })
