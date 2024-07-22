vim.g.python_host_prog = "/usr/bin/python"
vim.g.python3_host_prog = "/usr/bin/python"

require("plugins")

-- Better spelling suggestions
_G.HunspellSuggest = function()
	s = vim.fn.systemlist("hunspell -a", vim.v.val)[2]

	suggestions = {}
	index = 1
	for token in string.gmatch(s, "[:,] ([^,]+)") do
		table.insert(suggestions, {token, index})
		index = index + 1

		if index >= 25 then
			break
		end
	end
	return suggestions
end
--vim.api.nvim_set_option("spellsuggest", "expr:v:lua.HunspellSuggest(),best")

-- Auto load view if reload is more recent than 10 minutes
local load_view_if_recent = function()
	local view_file = vim.fn.expand("%:p:~"):gsub("=", "=="):gsub("/", "=%+") .. "="
	if not view_file then return end
	local view_path = vim.api.nvim_get_option("viewdir") .. view_file

	local ts = vim.fn.getftime(view_path)

	if math.abs(ts - vim.fn.localtime()) < 10 * 60 then
		vim.cmd("loadview")
	end
end
vim.api.nvim_create_autocmd({"BufWinEnter"}, {pattern = {"*"}, callback = load_view_if_recent})
-- Automatically make view on exit when there is a filename
local mkview_if_filename = function()
	local filename = vim.fn.expand("%:p")
	if filename and filename ~= "" then
		vim.cmd("mkview")
	end
end
vim.api.nvim_create_autocmd({"BufWinLeave"}, {pattern = {"*"}, callback = mkview_if_filename})

vim.cmd("runtime nvimrc.vim")
vim.cmd("runtime vimrc.vim")
