ret = {}

vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
	group = vim.api.nvim_create_augroup("user_diagnostic_qflist", {}),
	callback = function(args)
		-- Use pcall because I was getting inconsistent errors when quitting vim.
		-- Possibly timing errors from trying to get/create diagnostics/qflists
		-- that don't exist anymore. DiagnosticChanged fires at some strange times.
		local has_diagnostics, diagnostics = pcall(vim.diagnostic.get)
		local has_qflist, qflist = pcall(vim.fn.getqflist, { title = 0, id = 0, items = 0 })
		if not has_diagnostics or not has_qflist then return end

		-- Sometimes the event fires with an empty diagnostic list in the data.
		-- This conditional prevents re-creating the qflist with the same
		-- diagnostics, which reverts selection to the first item.
		if #args.data.diagnostics == 0 and #diagnostics > 0 and
			qflist.title == "All Diagnostics" and #qflist.items == #diagnostics then
			return
		end

		vim.schedule(function()
			-- If the last qflist was created by this autocmd, replace it so other
			-- lists (e.g., vimgrep results) aren't buried due to diagnostic changes.
			pcall(vim.fn.setqflist, {}, qflist.title == "All Diagnostics" and "r" or " ", {
				title = "All Diagnostics",
				items = vim.diagnostic.toqflist(diagnostics),
			})

			-- Don't steal focus from other qflists. For example, when working
			-- through vimgrep results, you likely want :cnext to take you to the
			-- next match, rather than the next diagnostic. Use :cnew to switch to
			-- the diagnostic qflist when you want it.
			if qflist.id ~= 0 and qflist.title ~= "All Diagnostics" then pcall(vim.cmd.cold) end
		end)
	end
})

ret.config = function()
	vim.lsp.set_log_level("debug")
	local lspconfig = require("lspconfig")

	local on_attach = function(client, bufnr)
		local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
		local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

		buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

		-- Mappings
		local opts = { noremap=true, silent=true }
		buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
		buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
		buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
		buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
		buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	end

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics, {
			underline = true,
			virtual_text = true,
			signs = false
		}
	)

	local servers = { "clangd", "pyright", "jdtls" --[[, "ltex"]] }
	for _, lsp in ipairs(servers) do
		lspconfig[lsp].setup { on_attach = on_attach }
	end

	--[[lspconfig.sumneko_lua.setup {
		cmd = { "lua-language-server", "-E", "/usr/share/lua-language-server/main.lua"},
		settings = {
			Lua = {
				runtime = {
					version = "Lua 5.3",
					path = {
						"./?.lua",
						"./?/init.lua",
						"/usr/share/lua/5.3/?.lua",
						"/usr/share/lua/5.3/?/init.lua",
						"/usr/lib/lua/5.3/?.lua",
						"/usr/lib/lua/5.3/?/init.lua",
						"/usr/share/awesome/lib/?.lua",
						"/usr/share/awesome/lib/?/init.lua"
					}
				},
				diagnostics = {
					disable = {
						"lowercase-global"
					},
					globals = {
						"client",
						"awesome",
						"screen",
						"root",
						"mousegrabber"
					}
				},
				workspace = {
					library = {
						["/usr/share/lua/5.4"] = true,
						["/usr/share/awesome/lib"] = true
					}
				}
			}
		},
		on_attach = on_attach
	}]]
end

ret.toggle_diagnostics = function()
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
