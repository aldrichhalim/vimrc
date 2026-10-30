" ============================================================================
" .vimrc
" ============================================================================

" ----------------------------------------------------------------------------
" Leader (set first so every <leader> mapping and plugin sees it)
" ----------------------------------------------------------------------------
let mapleader = ","

" ----------------------------------------------------------------------------
" Plugins (vim-plug)
" ----------------------------------------------------------------------------
call plug#begin()

" Defaults and editing
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'

" Appearance
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git and language support
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

call plug#end()

" ----------------------------------------------------------------------------
" General
" ----------------------------------------------------------------------------
set encoding=utf-8
set hidden                      " Required by coc for multi-file edits (rename, etc.)
set mouse=a
set clipboard=unnamedplus
set updatetime=300              " Faster CursorHold (coc, gitgutter, checktime)
set shortmess+=c                " Suppress completion-menu messages

" Backups and persistent undo
set nobackup
set nowritebackup
silent! call mkdir(expand('~/.vim/undo'), 'p')
set undodir=~/.vim/undo//
set undofile

" Reload files changed outside Vim (e.g. by agentic AI coding tools)
set autoread

" ----------------------------------------------------------------------------
" Interface
" ----------------------------------------------------------------------------
set number
set relativenumber
set signcolumn=yes
set scrolloff=8
set splitright
set splitbelow

" ----------------------------------------------------------------------------
" Search
" ----------------------------------------------------------------------------
set ignorecase
set smartcase
set hlsearch

" ----------------------------------------------------------------------------
" Indentation
" ----------------------------------------------------------------------------
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" ----------------------------------------------------------------------------
" Folding
" ----------------------------------------------------------------------------
set foldmethod=syntax
set foldlevelstart=99

" ----------------------------------------------------------------------------
" Color scheme
" ----------------------------------------------------------------------------
if has('termguicolors')
  set termguicolors
endif
let g:gruvbox_italic = 1
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'
set background=light
colorscheme gruvbox

" ----------------------------------------------------------------------------
" Plugin settings
" ----------------------------------------------------------------------------

" airline (it renders coc status itself, so no manual statusline entry)
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'

" auto-pairs: let coc own <CR> (see mappings below) to avoid a mapping clash
let g:AutoPairsMapCR = 0

" coc
let g:coc_global_extensions = [
      \ 'coc-tsserver',
      \ 'coc-pyright',
      \ 'coc-clangd',
      \ 'coc-go',
      \ 'coc-json',
      \ ]

" ----------------------------------------------------------------------------
" Completion (coc)
" ----------------------------------------------------------------------------
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Manually trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" ----------------------------------------------------------------------------
" Language server navigation and actions
" ----------------------------------------------------------------------------
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)

nmap <leader>a  <Plug>(coc-codeaction-cursor)
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>qf <Plug>(coc-fix-current)

command! -nargs=0 Format :call CocActionAsync('format')
nnoremap <silent> <leader>f :Format<CR>

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" ----------------------------------------------------------------------------
" Fuzzy finder (fzf; :Rg requires ripgrep)
" ----------------------------------------------------------------------------
nnoremap <C-p>      :Files<CR>
nnoremap <leader>b  :Buffers<CR>
nnoremap <leader>g  :Rg<CR>
nnoremap <leader>G  :Rg <C-r><C-w><CR>
nnoremap <leader>/  :BLines<CR>
nnoremap <leader>:  :History:<CR>

" ----------------------------------------------------------------------------
" General mappings
" ----------------------------------------------------------------------------
nnoremap <silent> <leader><space> :nohlsearch<CR>
nnoremap <leader>w :write<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer navigation
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [b :bprevious<CR>

" Move selected lines up/down and reindent
xnoremap J :move '>+1<CR>gv=gv
xnoremap K :move '<-2<CR>gv=gv

" ----------------------------------------------------------------------------
" Autocommands
" ----------------------------------------------------------------------------
augroup vimrc_autoread
  autocmd!
  " Pick up external changes; CursorHold covers terminals without focus events
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() !=# 'c' | silent! checktime | endif
augroup END

augroup vimrc_filetype
  autocmd!
  " Disable automatic comment continuation
  autocmd FileType * setlocal formatoptions-=r formatoptions-=o
  " Go (gofmt) and Makefiles require real tabs
  autocmd FileType go,make setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=0
  " PEP 8
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
augroup END

augroup vimrc_misc
  autocmd!
  " Highlight other occurrences of the symbol under the cursor
  autocmd CursorHold * silent call CocActionAsync('highlight')
  " Restore last cursor position when reopening a file
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &filetype !~# 'commit' |
        \   execute "normal! g`\"" |
        \ endif
augroup END
