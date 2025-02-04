" send code to jupyter
python3 << EOF
import jupyter_client
import time

km = None
def jupyter_connect():
	global km
	cf = jupyter_client.find_connection_file()
	km = jupyter_client.BlockingKernelClient(connection_file = cf)
	km.load_connection_file()
	km.start_channels()
	time.sleep(1)
	if not km.is_alive():
		print("No Jupyter Kernels Available")
		km = None
	return km

def jupyter_restart():
	if km != None and km.is_alive():
		km.shutdown(True)

def jupyter_send_code(code):
	if km == None or not km.is_alive():
		jupyter_connect()
	if km != None:
		km.execute(code, silent=False)
EOF

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

	vim.cmd('python3 << EOF\njupyter_send_code("""' .. code .. '""")\nEOF')
end
EOF
command SendCodeBuffer :lua SendCode(false)
command SendCodeAbove :lua SendCode(true)

" Fenced language highlighting
let g:markdown_fenced_languages = ['python', 'tex', 'c']
let g:vimsyn_embed = 'lPr'

" highlight yank
au TextYankPost * silent! lua vim.highlight.on_yank {higroup="Visual", timeout=100, on_visual=false}

" undofile
set undofile

" nvim specific shortcuts
let mapleader = ","

" fzf switch buffer
noremap <leader>b :Buffers<CR>
" fzf git files
noremap <leader>g :GFiles<CR>
" fzf files
noremap <leader>f :Files<CR>
" rg
noremap <leader>r :Rg<CR>
" toggle nvim-cmp
noremap <leader>c :lua require("config.nvim-cmp").toggle_completion()<CR>
" switch header
noremap <leader>h :ClangdSwitchSourceHeader<CR>

" colorscheme
set termguicolors
colorscheme molokai-edit
