" vim: set foldmethod=marker foldlevel=0 nomodeline:
" VIM DEFAULTS {{{

unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

augroup vimrc
	autocmd!
augroup END

" }}}
" VIM-PLUG {{{

silent! if plug#begin()

" junegunn
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-journal'
Plug 'junegunn/goyo.vim'
	nnoremap <Leader>G :Goyo<CR>
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" tpope
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
	map  gc  <Plug>Commentary
	nmap gcc <Plug>CommentaryLine
Plug 'tpope/vim-fugitive'
	nmap     <Leader>g :Git<CR>
	nnoremap <Leader>d :Gdiff<CR>
Plug 'tpope/vim-vinegar'

" utility
Plug 'dense-analysis/ale'
	let g:ale_completion_enabled = 1
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
	let g:undotree_WindowLayout = 2
	nnoremap U :UndotreeToggle<CR>
Plug 'rhysd/git-messenger.vim'
Plug 'justinmk/vim-gtfo'

Plug 'preservim/tagbar', { 'on': 'TagbarToggle' }
	let g:tagbar_sort = 0
Plug 'mhinz/vim-signify'
	let g:signify_vcs_list = ['git']
	let g:signifundotreey_skip_filetype = { 'journal': 1 }
	let g:signify_sign_add          = '│'
	let g:signify_sign_change       = '│'
	let g:signify_sign_changedelete = '│'

" Languages
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries'}
Plug 'rust-lang/rust.vim'
	let g:rustfmt_autosave = 1

" Markdown tools
Plug 'chrisbra/unicode.vim'
Plug 'ferrine/md-img-paste.vim'
	autocmd FileType markdown nnoremap <buffer> <silent> <leader>v :call mdip#MarkdownClipboardImage()<CR>
	let g:mdip_imgdir = 'images'
	let g:mdip_imgname = 'image'
Plug 'mzlogin/vim-markdown-toc'

call plug#end()
endif

" }}}
" Settings {{{
"
" Colors
silent! colo seoul256
let g:seoul256_background = 234

syntax on
set nocompatible                " Enables us Vim specific features
filetype off                    " Reset filetype detection first ...
filetype plugin indent on       " ... and enable filetype detection
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
set noexpandtab
set smarttab
set scrolloff=5                 " Sets Scroll offset to keep cursor from edge of screen
set sidescrolloff=10            " Sets Scroll offset to keep cursor from edge of screen
set nostartofline               " Keeps cursor in current column when jumping to lines
set relativenumber              " sets relative number for easier macros
set timeoutlen=500
set updatetime=500
set signcolumn=number
set background=dark
set list
set listchars=tab:▸-,trail:X
set virtualedit=block
set nojoinspaces
set diffopt=filler,vertical
set clipboard=unnamed
set foldlevelstart=99

set formatoptions+=1
if has('patch-7.3.541')
	set formatoptions+=j
endif
if has('patch-7.4.338')
	let &showbreak = '↳ '
	set breakindent
	set breakindentopt=sbr
endif

if has('termguicolors')
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors
endif

function! s:statusline_expr()
	let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
	let ro  = "%{&readonly ? '[RO] ' : ''}"
	let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
	let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
	let sep = ' %= '
	let pos = ' %-12(%l : %c%V%) '
	let pct = ' %P'

	return '[%n] %F %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()

" mouse
silent! set ttymouse=xterm2
set mouse=a

" 80 chars/line
set textwidth=0
if exists('&colorcolumn')
	set colorcolumn=80
endif

if has("patch-8.1.1904")
	set completeopt+=popup
	set completepopup=align:menu,border:off,highlight:Pmenu
endif

" ctags
set tags=./tags;/

" Annoying temporary files
set backupdir=/tmp//,.
set directory=/tmp//,.

" Semi-persistent undo
if has('persistent_undo')
	set undodir=/tmp,.
	set undofile
endif

if exists('&fixeol')
	set nofixeol
endif

" }}}
" Mappings {{{

noremap <C-F> <C-D>
noremap <C-B> <C-U>

" Open new line below and above current line
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

" Save
inoremap <C-s>     <C-O>:update<cr>
nnoremap <C-s>     :update<cr>
nnoremap <leader>s :update<cr>
nnoremap <leader>w :update<cr>

" Disable CTRL-A on tmux or on screen
if $TERM =~ 'screen'
	nnoremap <C-a> <nop>
	nnoremap <Leader><C-a> <C-a>
endif

" Quit
inoremap <C-Q>     <esc>:q<cr>
nnoremap <C-Q>     :q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>Q :qa!<cr>

" Tags
nnoremap <C-]> g<C-]>
nnoremap g[ :pop<cr>

" Jump list (to newer position)
nnoremap <C-p> <C-i>

" jk | Escaping!
inoremap jk <Esc>
xnoremap jk <Esc>
cnoremap jk <C-c>

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-^> <C-o><C-^>

" Make Y behave like other capitals
nnoremap Y y$

" qq to record, Q to replay
nnoremap Q @q

" quickfix
nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz

" buffers
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" Tabs
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" <tab> / <s-tab> | Circular windows navigation
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W

" Moving lines
nnoremap <silent> <C-k> :move-2<cr>
nnoremap <silent> <C-j> :move+<cr>
nnoremap <silent> <C-h> <<
nnoremap <silent> <C-l> >>
xnoremap <silent> <C-k> :move-2<cr>gv
xnoremap <silent> <C-j> :move'>+<cr>gv
xnoremap <silent> <C-h> <gv
xnoremap <silent> <C-l> >gv
xnoremap < <gv
xnoremap > >gv

" <Leader>c Close quickfix/location window
nnoremap <leader>c :cclose<bar>lclose<cr>

" <leader>bs | buf-search
nnoremap <leader>bs :cex []<BAR>bufdo vimgrepadd @@g %<BAR>cw<s-left><s-left><right>
" <leader>bb | fzf Buffers
nnoremap <leader>bb :Buffers<CR>

" Enter automatically into the files directory
au BufEnter * silent! lcd %:p:h

" NetRW
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" }}}
" AUTOCMD {{{
augroup vimrc
	au BufWritePost vimrc,.vimrc nested if expand('%') !~ 'fugitive' | source % | endif

	" Fugitive
	au FileType gitcommit setlocal completefunc=emoji#complete
	au FileType gitcommit nnoremap <buffer> <silent> cd :<C-U>Gcommit --amend --date="$(date)"<CR>

	" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
	au BufNewFile,BufRead,InsertLeave * silent! match ExtraWhitespace /\s\+$/
	au InsertEnter * silent! match ExtraWhitespace /\s\+\%#\@<!$/

	" Unset paste on InsertLeave
	au InsertLeave * silent! set nopaste

	" Close preview window
	if exists('##CompleteDone')
		au CompleteDone * pclose
	else
		au InsertLeave * if !pumvisible() && (!exists('*getcmdwintype') || empty(getcmdwintype())) | pclose | endif
	endif
augroup END

augroup py
	au!
	au BufNewFile,BufRead *.py setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
augroup END
" }}}
