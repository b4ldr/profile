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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'b4ldr/vim-medic_chalk'
Plug 'NLKNguyen/papercolor-theme'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'rust-lang/rust.vim'
Plug 'mrk21/yaml-vim'
Plug 'jvirtanen/vim-hcl'
call plug#end()
"https://github.com/psf/black/issues/1307
let g:vimspector_enable_mappings = 'HUMAN'
let g:go_debug=['shell-commands']
let g:syntastic_loc_list_height = 3
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-cl', 'coc-go', 'coc-solargraph', 'coc-python', 'coc-html', 'coc-json', 'coc-markdownlint', 'coc-perl', 'coc-jedi', 'coc-rust-analyzer']
set background=dark
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

"let g:syntastic_python_pylint_exe = '/home/jbond/.local/bin//pylint'
let g:syntastic_python_pylint_exe = '/Users/john.bond/Library/Python/3.9/bin/pylint'
let g:syntastic_python_pylint_args = '--rcfile=/Users/john.bond/.config/pylintrc'
let g:syntastic_python_pylint_post_args = '--rcfile=/Users/john.bond/.config/pylintrc'
let g:syntastic_python_python_exe = '/usr/bin/python3'
let g:syntastic_python_python_args = '-m py_compile'

highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$/
"autocmd BufWritePre *.py execute ':Black'
nnoremap <F2> :Black<CR>
nnoremap <F7> :TagbarToggle<CR>
autocmd BufRead */git/puppet/**/*.pp set sw=4 ts=4 et
autocmd BufNewFile */git/puppet/**/*.pp set sw=4 ts=4 et
nnoremap <c-n> :lnext<CR>
nnoremap <c-p> :lprevious<CR>
au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
" set nobackup
" set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
