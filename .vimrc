" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
Plug 'rose-pine/vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'mechatroner/rainbow_csv'

call plug#end()

set encoding=utf-8

"colorscheme rosepine
" Gruvbox
set background=dark
let g:gruvbox_bold=1
let g:gruvbox_transparent_bg=1
let g:gruvbox_sign_column='bg0'
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='soft'
colorscheme gruvbox

let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='default'
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1

" CoC Configurations
let g:coc_global_extensions = [
   \ 'coc-snippets',
   \ 'coc-tsserver',
   \ 'coc-json',
   \ 'coc-clangd',
   \ 'coc-python',
   \ ]

" Use <C-Space> to trigger completion
inoremap <silent><expr> <c-@> coc#refresh()

inoremap <silent> <c-e> :call coc#float#close_all()<CR>
inoremap <silent> <c-e> :call coc#float#close_all()<CR>

" Use `[d` and `]d` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" Remap Keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
   if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
   else
      call feedkeys('K', 'in')
   endif
endfunction

" Highlight symbol under cursor on Cursor Hold
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current symbol
nmap ,rn <Plug>(coc-rename)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" ------------------------------------------------------------------------------
" Features
set nocompatible

if has('filetype')
	filetype indent plugin on
endif

if has('syntax')
	syntax on
endif
hi Normal guibg=NONE ctermbg=NONE
hi clear SignColumn
command -nargs=0 Drk :set bg=dark
command -nargs=0 Lgt :set bg=light
command -nargs=0 Tsp :hi Normal guibg=NONE ctermbg=NONE | hi clear SignColumn
set termguicolors

set hidden

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

set hlsearch
set incsearch

autocmd BufRead,BufNewFile *.h set filetype=c

" ------------------------------------------------------------------------------
"  Usability Options
"
"  Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

set autoindent

" Stop certain movements from always going to the first character of a line
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
"set laststatus=2

"set jumpoptions=stack

" Display line numbers on the left
set number
set relativenumber

" at least 8 lines above of below
set scrolloff=8

" Indentation options
set tabstop=3
set softtabstop=3
set shiftwidth=3
set expandtab
set smartindent

set nowrap

set updatetime=100

" ------------------------------------------------------------------------------
"  Mappings
"
let mapleader = ' '

" Map Y to act like D and C, i.e., to yank until EOL, rather than act as yy
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" void paste
xnoremap <Leader>p "_dP
" void delete
nnoremap <Leader>d "_d
vnoremap <Leader>d "_d

nnoremap <Leader>b :ls<CR>:b
nnoremap <Leader>e :b#<CR>
nnoremap <Leader>[ :bp<CR>
nnoremap <Leader>] :bn<CR>
nnoremap <space> <nop>

" Append Filename
nnoremap <Leader>af :execute 'normal! a' . expand('%:t')<CR>

" ------------------------------------------------------------------------------
" Functions
function! ExpandCommentLine()
   let line = getline('.')
   let text = substitute(line, "\\v.*\\/\\*\\W*(\\w)((\\w|\\s){-})\\W{-}\\*\\/.*", "\\1\\2", "")
   let indent = matchstr(line, '^\s*')
   let prefix = "/*"
   let suffix = "*/"
   if strlen(text) == 0
      let fixed_text = " "
   else
      let fixed_text = " " . text . " "
   endif

   let dash_needed = 80 - (strlen(prefix) + strlen(fixed_text) + strlen(suffix) + strlen(indent))
   if dash_needed < 0
      let new_line = indent . prefix . fixed_text . suffix
   else
      let left_dashes = dash_needed / 2
      let right_dashes = dash_needed - left_dashes
      let new_line = indent . prefix . repeat('-', left_dashes) . fixed_text . repeat('-', right_dashes) . suffix
   endif
   call setline('.', new_line)
endfunction
