vim.cmd("packadd packer.nvim")
local use = require("packer").use

-- Auto compile plugin.lua file when edited
vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerSync
	augroup end
]])
return require("packer").startup(function()
	-- Manage self
	use "wbthomason/packer.nvim"

	-- Misc.
	use "junegunn/fzf.vim"
	use {
		"SirVer/ultisnips",
		config = function() require("config.ultisnips").config() end
	}
	use "tpope/vim-fugitive"
	use {
		"benlubas/molten-nvim",
		config = function() require("config.molten-nvim").config() end,
		run = ":UpdateRemotePlugins"
	}

	-- LSP/Completion/Linting
	use {
		"neovim/nvim-lspconfig",
		config = function() require("config.nvim-lspconfig").config() end
	}
	use {
		"hrsh7th/nvim-cmp",
		config = function() require("config.nvim-cmp").config() end
	}
	use "hrsh7th/cmp-nvim-lsp"
	use "hrsh7th/cmp-nvim-lsp-signature-help"
	use "editorconfig/editorconfig-vim"

	-- Treesitter
	use {
		"nvim-treesitter/nvim-treesitter",
		config = function() require("config.nvim-treesitter").config() end
	}

	-- Language Specific
	use {
		"lervag/vimtex",
		config = function() require("config.vimtex").config() end
	}
end)
