set nocompatible              " be iMproved, required

call plug#begin()

Plug 'lervag/vimtex'
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'https://github.com/SirVer/ultisnips'
Plug 'https://github.com/jpalardy/vim-slime'
Plug 'neovim/nvim-lspconfig'

call plug#end()

" vimtex
let g:tex_flavor = "latex"
let g:vimtex_view_general_viewer = "zathura"
let g:vimtex_quickfix_mode=0
let g:vimtex_mappings_enabled=0
" ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips', 'UltiSnips']
" vim-slime
let g:slime_no_mappings=1
let g:slime_target="x11"
function SlimeOverride_EscapeText_tex(text)
	let @+ = a:text
	return "\x15%paste -q\n"
endfunction
" lspconfig
lua << EOF
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
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		underline = false,
		virtual_text = false,
		signs = false
	}
)

local servers = { "ccls", "pyls" }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup { on_attach = on_attach }
end
lspconfig.sumneko_lua.setup {
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
}
EOF

function! SendCodeChunk()
	let line_ini = search("\\\\begin{pycode}", 'bcnW')
	let line_end = search("\\\\end{pycode}", 'nW')

	" line after delimiter or top of file
	let line_ini = line_ini ? line_ini + 1 : 1
	" line before delimiter or bottom of file
	let line_end = line_end ? line_end - 1 : line("$")

	call slime#send_range(line_ini, line_end)
endfunction

lua << EOF
function SendCode(to_cursor_block, begin_splits, end_splits)
	if not begin_splits then
		begin_splits = {
			"\\begin{pycode}",
			"\\begin{pyblock}",
			"\\begin{pyconsole}"
		}
	end
	if not end_splits then
		end_splits = {
			"\\end{pycode}",
			"\\end{pyblock}",
			"\\end{pyconsole}"
		}
	end

	local chunk_index = nil
	local whitespace_end_index = nil
	local buffer = vim.fn.getline("1", "$")
	local code = ""

	for line_num, line in ipairs(buffer) do
		if not chunk_index then
			if to_cursor_block and line_num > vim.fn.line(".") then break end
			for i, split in ipairs(begin_splits) do
				if line ~= "" and string.find(line, split) then
					chunk_index = i
					whitespace_end_index = nil
					break
				end
			end
		else
			-- gobble leading whitespace
			if not whitespace_end_index then
				_, whitespace_end_index = string.find(line, "^[ \t]*")
			end

			if line ~= "" and string.find(line, end_splits[chunk_index]) then
				chunk_index = nil
			else
				code = code .. string.sub(line, whitespace_end_index + 1) .. '\n'
			end
		end
	end

	local clipboard_copy = vim.fn.getreg("+")
	vim.fn["slime#send"](code)
	vim.defer_fn(function () vim.fn.setreg("+", clipboard_copy) end, 100)
end
EOF
command SendCodeBuffer :lua SendCode(false)
command SendCodeAbove :lua SendCode(true)

let g:markdown_fenced_languages = ['python', 'tex', 'c']
let g:vimsyn_embed = 'lPr'

filetype on
filetype plugin on 
filetype indent on

syntax enable
set autoindent
set backspace=indent,eol,start
set tabpagemax=30
set so=2
set mouse=a
set clipboard=unnamedplus
hi Visual cterm=NONE ctermbg=8
set background=light
set laststatus=1
" highlight yank
au TextYankPost * silent! lua vim.highlight.on_yank {higroup="Visual", timeout=100, on_visual=false}
" lower timeout
set timeoutlen=200

" case insensitive search if lowercase
set ignorecase
set smartcase

" spelllang
set spelllang=en_us

" undofile
set undofile

" Custom bindings
let mapleader = ","
" save file
noremap <leader>w :w<CR>
" quit
noremap <leader>q :q<CR>
" save and quit
noremap <leader>x :x<CR>
" toggle spelling
noremap <leader>s :setlocal spell!<CR>
" correct last spelling mistake
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
" fzf switch buffer
noremap <leader>b :Buffers<CR>
" fzf git files
noremap <leader>g :GFiles<CR>
" fzf files
noremap <leader>f :Files<CR>
" rg
noremap <leader>r :Rg<CR>

" allow common typos
command W :w
command Q :q

" sudo writing
ca w!! w !sudo tee % > /dev/null

" Default relative number
set relativenumber
set number
" Toggle relative number
noremap + :set relativenumber! <bar> set number!<Enter>

" Show line breaks clearly
set showbreak=›

" Clear search highlighting with Escape key
nnoremap <silent><esc> :noh<return><esc>

" easier splits shortcuts
noremap <Esc>a <C-w>
tnoremap <Esc>a <C-w>

" Map completion
inoremap <C-@> <C-x><C-o>

" Mapping to move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Disable middle click pasting
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>
