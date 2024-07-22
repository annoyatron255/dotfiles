ret = {}

ret.config = function()
	require("nvim-treesitter.configs").setup {
		ensure_installed = {
			"c", "cpp", "bash", "python", "lua",
			"javascript"
		},
		highlight = {
			enable = true
		}
	}
end

return ret
