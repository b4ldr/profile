set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=4
filetype off
"https://github.com/junegunn/vim-plug
call plug#begin()
" https://github.com/psf/black/pull/1545/files applied manually
Plug 'psf/black', { 'branch': 'stable' }
Plug 'guns/xterm-color-table.vim'
Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'jamessan/vim-gnupg'
Plug 'rodjek/vim-puppet'
Plug 'fatih/vim-go'
Plug 'ycm-core/YouCompleteMe'
Plug 'b4ldr/vim-medic_chalk'
Plug 'NLKNguyen/papercolor-theme'
Plug 'Glench/Vim-Jinja2-Syntax'
call plug#end()
"https://github.com/psf/black/issues/1307
let g:black_skip_string_normalization = 1
let g:syntastic_loc_list_height = 3
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_pylint_post_args="--rcfile=~/.vim/config/.pylint"
set completeopt-=preview
filetype plugin indent on
syntax on
set mouse-=a
"color ron
"colorscheme medic_chalk
colorscheme PaperColor
set nu
setlocal spell spelllang=en_gb
au BufRead,BufNewFile *.nse set ft=lua
au BufRead,BufNewFile *.cf set ft=cf3
au BufRead,BufNewFile *.j2 set ft=jinja
set shortmess-=tT
set autoindent
"set autowrite
set backspace=indent,eol,start
set cindent
set cinkeys=0{,0},0),:,!^F,o,O,e
set cinoptions=f0,{0,t0,(0,u0,w1,W1s,)60,*60
set cpo&vim
set diffopt+=icase,iwhite,filler
set encoding=utf8
set fileencoding=utf8
"set fileencodings=ucs-bom,utf-8,default
set foldmethod=syntax
set formatoptions=crn
set fdl=1
set guifont=Andale\ Mono:h13
set guioptions-=tT
set history=60
set hlsearch
set incsearch
set laststatus=2
set modeline
set modelines=5
"set mp=gmake
set nocompatible
"set runtimepath=$DEV/vim,$VIMRUNTIME
set ruler
set shiftround
set showcmd
set showmatch
set smartindent
set smarttab
set viminfo='20,\"80,c
hi PreProc ctermfg=Green
"if &term =~ "xteam.*"
"    let &t_ti = &t_ti . "\e[?2004h"
"    let &t_te = "\e[?2004l" . &t_te
"    function XTermPasteBegin(ret)
"        set pastetoggle=<Esc>[201~
"        set paste
"        return a:ret
"    endfunction
"    map <expr> <Esc>[200~ XTermPasteBegin("i")
"    imap <expr> <Esc>[200~ XTermPasteBegin("")
"    cmap <Esc>[200~ <Nop>
"    cmap <Esc>[201~ <Nop>
"endif

"function! CleverTab()
"    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
"  return "\<Tab>"
"    else
"	return "\<C-N>"
"endfunction
"inoremap <Tab> <C-R>=CleverTab()<CR>

let g:syntastic_python_pylint_exe = '/usr/bin/pylint'
let g:syntastic_python_python_exe = '/usr/bin/python3'
let g:syntastic_python_python_args = '-m py_compile'
let g:syntastic_python_checkers = ['pylint', 'flake8', 'python']

highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$/
"autocmd BufWritePre *.py execute ':Black'
nnoremap <F9> :Black<CR>
autocmd BufRead */git/puppet/**/*.pp set sw=4 ts=4 et
autocmd BufNewFile */git/puppet/**/*.pp set sw=4 ts=4 et
