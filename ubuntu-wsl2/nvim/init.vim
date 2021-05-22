"set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible
set termguicolors
set clipboard=unnamedplus
" Install plugins with vim-plug https://github.com/junegunn/vim-plug
" Reload and runs :PlugInstall to install plugins

call plug#begin('~/.local/share/nvim/plugged')

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tomtom/tcomment_vim'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'slim-template/vim-slim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'ervandew/supertab'
Plug 'tpope/vim-rails'
Plug 'elixir-editors/vim-elixir'
Plug 'jiangmiao/auto-pairs'
Plug 'roman/golden-ratio'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'andymass/vim-matchup'
Plug 'tpope/vim-endwise'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-obsession'
Plug 'vim-airline/vim-airline'
Plug 'brooth/far.vim'
Plug 'dyng/ctrlsf.vim'

call plug#end()

" Use The Silver Searcher if available
" https://github.com/ggreer/the_silver_searcher
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
  cnoreabbrev ag Ack
  cnoreabbrev aG Ack
  cnoreabbrev Ag Ack
  cnoreabbrev AG Ack
endif

" -- Configurations --
let mapleader=","

" Enable syntax highlighting
syntax on

" Don't wrap long lines
set nowrap

" Use 2 spaces for tabs
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab

" Automatically remove all trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" Set default colorscheme to solarized
" set background=dark
" silent! colorscheme solarized8_high

set background=dark
colorscheme gruvbox


" Enable line numbers and don't make them any wider than necessary
set number numberwidth=2

" -- Mappings --

" Toggle NERDTreeToggle
nmap <Leader>g :NERDTreeToggle<CR>
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Switch between panes
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l

" Mapping CtrlP command
nnoremap <Leader>b :<C-U>CtrlPBuffer<CR>
nnoremap <Leader>t :<C-U>CtrlP<CR><Paste>

nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" open new split panes to right and below
set splitright
set splitbelow
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" open terminal on ctrl+n
function! OpenTerminal()
  split term://zsh
  resize 10
endfunction
nnoremap <c-n> :call OpenTerminal()<CR>

set guicursor=

" Highlight the currert line on INSERT mode
:autocmd InsertEnter,InsertLeave * set cul!


" CtrlSF setup
" Use the ack tool as the backend
let g:ctrlsf_backend='ag'
" Auto close the results panel when opening a file
let g:ctrlsf_auto_close={ "normal":0, "compact":0 }
" Immediately switch focus to the search window
let g:ctrlsf_auto_focus={ "at":"start" }
" Don't open the preview window automatically
let g:ctrlsf_auto_preview=0
" Use the smart case sensitivity search scheme
let g:ctrlsf_case_sensitive='smart'
" Normal mode, not compact mode
let g:ctrlsf_default_view='normal'
" Use absoulte search by default
" let g:ctrlsf_regex_pattern=0;
" Position of the search window
let g:ctrlsf_position='right'
" Width or height of search window
let g:ctrlsf_winsize='46'
" Search from the current working directory
let g:ctrlsf_default_root='cwd'
