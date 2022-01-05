" Install vim-plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin()

" Colors
Plug 'junegunn/seoul256.vim'


" Vim Lightline
Plug 'itchyny/lightline.vim'
let g:lightline = {'colorscheme': 'seoul256'}


" Tmux Statusline Generation
Plug 'edkolev/tmuxline.vim'
let g:tmuxline_powerline_separators = 0


" Fuzzy Search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'


" Languages
Plug 'govim/govim'
Plug 'cespare/vim-toml'
Plug 'tsandall/vim-rego'
Plug 'ekalinin/Dockerfile.vim'

Plug 'stephpy/vim-yaml'
augroup yaml
	au!
	au BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
	au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
augroup END

Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

Plug 'dense-analysis/ale'
let g:ale_enabled = 0
let g:ale_linters = {'python': ['yapf']}
let g:ale_fixers = {'python': ['remove_trailing_lines', 'trim_whitespace', 'yapf', 'isort']}
let g:ale_fix_on_save = 1
augroup py
	au!
	au BufNewFile,BufRead *.py setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
	au FileType python ALEEnable
augroup END

call plug#end()

" Colors
syntax enable
color seoul256
let g:seoul256_background = 234

""""""""""""""""""""""
"      Settings      "
""""""""""""""""""""""

syntax on
set nocompatible                " Enables us Vim specific features
filetype off                    " Reset filetype detection first ...
filetype plugin indent on       " ... and enable filetype detection
set ttyfast                     " Indicate fast terminal conn for faster redraw
set ttyscroll=3                 " Speedup scrolling
set laststatus=2                " Show status line always
set encoding=utf-8              " Set default encoding to UTF-8
set autoread                    " Automatically read changed files
set autoindent                  " Enabile Autoindent
set smartindent
set backspace=indent,eol,start  " Makes backspace key more powerful.
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set noerrorbells                " No beeps
set number                      " Show line numbers
set showcmd                     " Show me what I'm typing
set noswapfile                  " Don't use swapfile
set nobackup                    " Don't create annoying backup files
set nowritebackup
set splitright                  " Vertical windows should be split to right
set splitbelow                  " Horizontal windows should split to bottom
set autowrite                   " Automatically save before :next, :make etc.
set hidden                      " Buffer should still exist if window is closed
set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats
set noshowmatch                 " Do not show matching brackets by flickering
set noshowmode                  " We show the mode with airline or lightline
set ignorecase                  " Search case insensitive...
set smartcase                   " ... but not it begins with upper case
set completeopt=menu,menuone    " Show popup menu, even if there is one entry
set pumheight=10                " Completion window max size
set nocursorcolumn              " Do not highlight column (speeds up highlighting)
set nocursorline                " Do not highlight cursor (speeds up highlighting)
set lazyredraw                  " Wait to redraw
set tabstop=4
set shiftwidth=4
set scrolloff=3                 " Sets Scroll offset to keep cursor from edge of screen
set sidescrolloff=10            " Sets Scroll offset to keep cursor from edge of screen
set nostartofline               " Keeps cursor in current column when jumping to lines
set relativenumber              " sets relative number for easier macros
"set mouse=a
set ttymouse=sgr
set updatetime=500
set balloondelay=250
set signcolumn=number
set visualbell
set background=dark
set list
set listchars=tab:▸-,trail:X

if has("patch-8.1.1904")
	set completeopt+=popup
	set completepopup=align:menu,border:off,highlight:Pmenu
endif

" Enable to copy to clipboard for operations like yank, delete, change and put
" http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed

" This enables us to undo files even if you exit Vim.
if has('persistent_undo')
  set undofile
  set undodir=~/.config/vim/tmp/undo//
endif


""""""""""""""""""""""
"      Mappings      "
""""""""""""""""""""""

" Set leader shortcut to a comma ','. By default it's the backslash
let mapleader = ','

" Set Capslock to Escape and Back in Vim
au VimEnter * :silent !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
au VimLeave * :silent !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

" Move up and down during insert mode
inoremap <expr> <C-j> pumvisible() ? "<C-n>" : "<C-j>"
inoremap <expr> <C-k> pumvisible() ? "<C-p>" : "<C-k>"

" Exec Omni easier
inoremap <C-@> <C-x><C-o>

" Jump to next error with Ctrl-n and previous error with Ctrl-m. Close the
" quickfix window with <leader>a
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cwindow<CR>
nnoremap <leader>c :cclose<CR>

" Visual linewise up and down by default (and use gj gk to go quicker)
noremap <Up> gk
noremap <Down> gj
noremap j gj
noremap k gk

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Act like D and C
nnoremap Y y$

" Enter automatically into the files directory
au BufEnter * silent! lcd %:p:h

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
map <C-s> :Vexplore<CR>

" GOVIM
nmap <silent> <buffer> <C-b> :GOVIMGoToDef<CR>
nmap <silent> <buffer> <C-t> :GOVIMGoToPrevDef<CR>
nmap <silent> <buffer> <Leader>h :<C-u>call GOVIMHover()<CR>

nmap <silent> <buffer> <F2> :execute "GOVIMQuickfixDiagnostics" | cw | if len(getqflist()) > 0 && getwininfo(win_getid())[0].quickfix == 1 | :wincmd p | endif<CR>
imap <silent> <buffer> <F2> <C-O>:execute "GOVIMQuickfixDiagnostics" | cw | if len(getqflist()) > 0 && getwininfo(win_getid())[0].quickfix == 1 | :wincmd p | endif<CR>

" GovimFZFSymbol is a user-defined function that can be called to start fzf in
" a mode whereby it uses govim's new child-parent capabilities to query the
" parent govim instance for gopls Symbol method results that then are used to
" drive fzf.
function GovimFZFSymbol(queryAddition)
  let l:expect_keys = join(keys(s:symbolActions), ',')
  let l:source = join(GOVIMParentCommand(), " ").' gopls Symbol -quickfix'
  let l:reload = l:source." {q}"
  call fzf#run(fzf#wrap({
        \ 'source': l:source,
        \ 'sink*': function('s:handleSymbol'),
        \ 'options': [
        \       '--with-nth', '2..',
        \       '--expect='.l:expect_keys,
        \       '--phony',
        \       '--bind', 'change:reload:'.l:reload
        \ ]}))
endfunction

" Map \s to start a symbol search
"
" Once you have found the symbol you want:
"
" * Enter will open that result in the current window
" * Ctrl-s will open that result in a split
" * Ctrl-v will open that result in a vertical split
" * Ctrl-t will open that result in a new tab
"
nmap <Leader>s :call GovimFZFSymbol('')<CR>

" s:symbolActions are the actions that, in addition to plain <Enter>,
" we want to be able to fire from fzf. Here we map them to the corresponding
" command in VimScript.
let s:symbolActions = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit',
  \ }

" With thanks and reference to github.com/junegunn/fzf.vim/issues/948 which
" inspired the following
function! s:handleSymbol(sym) abort
  " a:sym is a [2]string array where the first element is the
  " key pressed (or empty if simply Enter), and the second element
  " is the entry selected in fzf, i.e. the match.
  "
  " The match will be of the form:
  "
  "   $filename:$line:$col: $match
  "
  if len(a:sym) == 0
    return
  endif
  let l:cmd = get(s:symbolActions, a:sym[0], "")
  let l:match = a:sym[1]
  let l:parts = split(l:match, ":")
  execute 'silent' l:cmd
  execute 'buffer' bufnr(l:parts[0], 1)
  set buflisted
  call cursor(l:parts[1], l:parts[2])
  normal! zz
endfunction
