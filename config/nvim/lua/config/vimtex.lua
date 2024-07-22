ret = {}

ret.config = function()
	vim.g.tex_flavor = "latex"
	vim.g.vimtex_view_method = "zathura"
	vim.g.vimtex_quickfix_mode = 0
	vim.g.vimtex_mappings_enabled = 0
	vim.g.vimtex_matchparen_enabled = 0
	vim.g.vimtex_view_forward_search_on_start = 0
end

return ret
