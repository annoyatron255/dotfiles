ret = {}

ret.config = function()
	vim.g.UltiSnipsExpandTrigger = "<tab>"
	vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
	vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
	vim.g.UltiSnipsEditSplit = "vertical"
	vim.g.UltiSnipsSnippetDirectories = {"~/.config/nvim/UltiSnips", "UltiSnips"}
end

return ret
