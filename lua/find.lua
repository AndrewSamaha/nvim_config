local files_by_cwd = {}

local rg_files_command = {
	"rg",
	"--files",
	"--hidden",
	"--glob",
	"!node_modules/**",
	"--glob",
	"!dist/**",
	"--glob",
	"!build/**",
	"--glob",
	"!.cache/**",
	"--glob",
	"!*.tmp",
	"--glob",
	"!*.log",
}

local function files_for_current_directory()
	local cwd = vim.fn.getcwd()
	if not files_by_cwd[cwd] then
		files_by_cwd[cwd] = vim.fn.systemlist(rg_files_command)
	end

	return files_by_cwd[cwd]
end

function _G.native_find(text, _)
	local files = files_for_current_directory()
	return text == "" and files or vim.fn.matchfuzzy(files, text)
end

vim.api.nvim_create_user_command("FindRefresh", function()
	files_by_cwd[vim.fn.getcwd()] = nil
	vim.notify("File finder cache cleared for the current directory")
end, { desc = "Refresh the native :find file cache" })

vim.opt.findfunc = "v:lua.native_find"
vim.keymap.set("n", "<leader>f", ":find ", { silent = false })
