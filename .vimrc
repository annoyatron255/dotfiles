set nocompatible              " be iMproved, required

call plug#begin()

Plug 'dense-analysis/ale'
Plug 'lervag/vimtex'
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'https://github.com/SirVer/ultisnips'

call plug#end()

" ALE
let g:ale_enabled = 0
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
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

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
" lower timeout
set timeoutlen=200

" case insensitive search if lowercase
set ignorecase
set smartcase

" spelllang
set spelllang=en_us

" Custom bindings
let mapleader = ","
" save file
noremap <leader>w :w<CR>
" quit
noremap <leader>q :q<CR>
" save and quit
noremap <leader>x :x<CR>
" toggle ALE
noremap <leader>a :ALEToggle<CR>
" toggle spelling
noremap <leader>s :setlocal spell!<CR>
" correct last spelling mistake
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" allow common typos
command W :w
command Q :q

" Default relative number
set relativenumber
set number
" Toggle relative number
noremap + :set relativenumber! <bar> set number!<Enter>

" Show line breaks clearly
set showbreak=>

" easier splits shortcuts
noremap <Esc>a <C-w>
tnoremap <Esc>a <C-w>

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
