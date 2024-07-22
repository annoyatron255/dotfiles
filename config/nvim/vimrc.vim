set nocompatible

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
set laststatus=1

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
set showbreak=↳
" break lines to same indent
set breakindent

" show more verbose terminal title
set title

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
