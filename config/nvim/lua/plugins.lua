-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
	spec = {
		-- Misc.
		"junegunn/fzf.vim",
		"junegunn/vim-easy-align",
		{
			"SirVer/ultisnips",
			config = require("config.ultisnips").config
		},
		"tpope/vim-fugitive",
		--"benlubas/molten-nvim",

		-- LSP/Completion/Linting
		{
			"neovim/nvim-lspconfig",
			config = require("config.nvim-lspconfig").config
		},
		{
			"hrsh7th/nvim-cmp",
			config = require("config.nvim-cmp").config
		},
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"editorconfig/editorconfig-vim",
		{
			"mfussenegger/nvim-dap",
			config = require("config.nvim-dap").config
		},

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			config = require("config.nvim-treesitter").config
		},
		"nvim-treesitter/nvim-treesitter-context",

		-- Language Specific
		{
			"lervag/vimtex",
			config = require("config.vimtex").config
		}
	},

	checker = { enabled = false }
})
