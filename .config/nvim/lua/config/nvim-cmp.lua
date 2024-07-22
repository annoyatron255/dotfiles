ret = {}

ret.config = function()
	local cmp = require("cmp")

	cmp.setup {
		enabled = true,
		snippet = {
			expand = function(args)
				vim.fn["UltiSnips#Anon"](args.body)
			end,
		},
		--[[view = {
			entries = { name = "custom", selection_order = 'near_cursor' }
		},]]
		mapping = {
			['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
			['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
			['<CR>'] = cmp.mapping.confirm { select = true },
			['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
			['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
		},
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'nvim_lsp_signature_help' },
			--{ name = 'ultisnips' },
		}, {
			{ name = 'buffer' },
		})
	}

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

	vim.g.cmp_toggle_flag = false -- initialize
	local normal_buftype = function()
		return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt'
	end
end

ret.toggle_completion = function()
	local ok, cmp = pcall(require, "cmp")
	if ok then
		local next_cmp_toggle_flag = not vim.g.cmp_toggle_flag
		if next_cmp_toggle_flag then
			print("completion on")
		else
			print("completion off")
		end
		cmp.setup {
			enabled = function()
				vim.g.cmp_toggle_flag = next_cmp_toggle_flag
				if next_cmp_toggle_flag then
					return normal_buftype
				else
					return next_cmp_toggle_flag
				end
			end
		}
	else
		print("completion not available")
	end
end

return ret
