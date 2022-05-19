set encoding=utf-8
set t_u7=

set termguicolors
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set number
" shift tab for command mode
nmap <S-Tab> <<
" shift tab for insert mode
imap <S-Tab> <Esc><<i

noremap <F8> :call HexMe()<CR>

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
inoremap <F7> <C-O>zM
nnoremap <F7> zM

inoremap <F9> <C-O>zR
nnoremap <F9> zR

let $in_hex=0
function HexMe()
    set binary
    set noeol
    if $in_hex>0
        :%!xxd -r
        let $in_hex=0
    else
        :%!xxd
        let $in_hex=1
    endif
endfunction

function MapToggle(key, opt)
    let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
    exec 'nnoremap '.a:key.' '.cmd
    exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command -nargs=+ MapToggle call MapToggle(<f-args>)

function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize '
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
ca shell Shell

function! s:ExecuteInVerticalShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright vnew ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize '
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ VerticalShell call s:ExecuteInVerticalShell(<q-args>)
ca vshell VerticalShell

MapToggle <F2> expandtab

set nocompatible
filetype off
let terraform_fmt_on_save = 1

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Bundle 'Yggdroot/indentLine'
Plugin 'flazz/vim-colorschemes'
Plugin 'morhetz/gruvbox'
"Plugin 'Quramy/tsuquyomi'
Plugin 'leafgarland/typescript-vim'
Plugin 'Quramy/vim-js-pretty-template'
Plugin 'jason0x43/vim-js-indent'
Plugin 'tpope/vim-obsession'
Plugin 'wesQ3/vim-windowswap'
Plugin 'tpope/vim-fugitive'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'tommcdo/vim-fubitive'
Plugin 'tpope/vim-unimpaired'
Plugin 'hashivim/vim-terraform'

call vundle#end()
filetype plugin indent on

set t_Co=256
syntax on
set background=dark
colorscheme gruvbox

set colorcolumn=100

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:⋅
set list

set statusline=%<%f\ %h%m%r
set statusline+=%{FugitiveStatusline()}
set statusline+=%=%-14.(%l,%c%V%)\ %P

autocmd FileType typescript nmap <buffer> <Leader>e <Plug>(TsuquyomiRenameSymbol)
autocmd FileType typescript nmap <buffer> <Leader>E <Plug>(TsuquyomiRenameSymbolC)
autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

autocmd FileType terraform setlocal foldmethod=syntax

