
"-------------------------------------------------------------------------------"
let s:VIMRC_PATH = "~/"
let s:VIM_PATH = ".vim/"
let g:vim_root_path = s:VIMRC_PATH . s:VIM_PATH
"let &runtimepath=substitute(&rtp, '\/\.vim', '\/\.vim1', 'g')

"echo 'KJK_DEBUG ['$VIMRUNTIME']:['$VIMINIT']:['$MYVIMRC']'
"
"leader settings
"-------------------------------------------------------------------------------"
"let mapleader=','
"let maplocalleader=','


if 1 "android setting
"==============================================================================="
function! FUNC_FindAndroidRoot()
    let cur_dir = getcwd()
    if 0 "android full source setting
        let temp_dir = cur_dir
        while temp_dir != "/"
            if filereadable(temp_dir . "/build/envsetup.sh")
                return temp_dir
            elseif filereadable(temp_dir . "/../android/build/envsetup.sh")
                return temp_dir
            else
                cd ..
                let temp_dir = getcwd()
            endif
        endwhile
    endif
    return cur_dir
endfunction

function! FUNC_FindProjectRoot()
    let cur_dir = getcwd()
    let org_dir = cur_dir
    while cur_dir != "/"
        let dir_to_check = cur_dir . '/.git'
"        echo 'check ' . dir_to_check .' :' . isdirectory(dir_to_check)
        if isdirectory(dir_to_check)
            return cur_dir
        endif
        if filereadable(cur_dir . "/tags")
            return cur_dir
        endif
        cd ..
        let cur_dir = getcwd()
    endwhile
    let cur_dir = org_dir
"    echo 'rootDir is ' . cur_dir
    return cur_dir
endfunction

let g:RootDir=FUNC_FindProjectRoot()
let g:include_files='*.c, *.cpp, *.java, *.mk, *.sh, *.xml'
let g:exclude_dirs='.repo, .git, .svn, .cache, out_*'
let g:exclude_files='*.obj, *.o, *.class, *.jar, *.so, *.js, *.html, *~'
endif

"
"Extra settings for vim
"
set number
set statusline+=%F  "show full path for current editing file.
set laststatus=2    "and show it permanantly.

if 1
"==============================================================================="
"ctags"
"-------------------------------------------------------------------------------"
if version >= 600

"setting for basic operation
nmap <F12>hh :help my_find<cr>
"create: ctag create
nmap <F12>c :call FUNC_ctags_create()<cr>
nmap <F12><F12> <C-t>
nmap <F12> <C-]>
"reference: 현재 cursor의 symbol과 비슷한 symbol defintion 찾기, regexp
"nmap <F12>s :call FUNC_ctags_search()<cr>
nmap <F12>s :ltag /^<C-R>=expand("<cword>")<CR>$

"setting for view
"definition preview in horizontal/vertical/tab
nmap <F12>v <C-W><C-]>
nmap <F12>vv :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
nmap <F12>vt :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
"이전 검색한 symbol이 jump할수 있는 list보여주기
nmap <F12>7 :lclose<cr>
nmap <F12>8 :lopen<cr>
nmap <F12>9 :tp<cr>
nmap <F12>0 :tn<cr>
"set tags=tags,TAGS,$PWD/tags,$HOME/.vim/tags
set tags=./tags,./TAGS
execute "set tags+=".g:RootDir."/tags"
"echo "get tags ".g:RootDir."/tags"
"set tags+=$HOME/.vim/tags
"set tags+=FUNC_ctags_create()


"generate absolute path to using ctags at any directory"
    func! FUNC_ctags_create()
        exe "!echo [ctag will be created, enter to continue, or Ctrl-C]"
        exe "!$HOME/.vim/myctags.sh" g:RootDir
    endfunc

    func! FUNC_ctags_search()
        let st = expand("<cword>")
        exe "ltag /^".st
    endfunc

endif
"_______________________________________________________________________________
endif

set mouse=a
syntax on
filetype on
filetype plugin on "filetype에 따라 plugin이 동작해라
filetype indent on "indentation도 마찬가지

"environments
""=============================================================================="
set matchpairs+=<:> "{},[],()
set ttymouse=xterm
set ttyfast "fast terminal transfer

set mouse=a ""use the mouse in all modes
set mousemodel=popup_setpos  "mouse button behavior
set nobackup "backup file, 생성안함"
set noswapfile "swap파일 생성 안함
"set autochdir "chdir to the file located when opening file
""가끔 위의 명령은 plugin에서 동작알될때가 있다. 그 경우 아래 사용
autocmd BufEnter * silent! lcd %:p:h


"encoding
""=============================================================================="
set encoding=utf-8 "read encoding"
set fileencoding=utf-8 "write encoding: fenc"
set fileencodings=utf-8,cp949,unicode "write encoding: fencs"
set fileformat=unix
set fileformats=unix,dos,mac
"set termencoding=utf-8


"search
""=============================================================================="
set maxmempattern=1000
set magic "search시 pattern입력시 특수문자 입력시 backslash를 달아야 한다.
set nowrapscan "마지막까지 search시 처음으로 돌아가지 않도록, or viceverse
set hlsearch "when searching by using /, hilight match word"
"search시 hlsearch로 highlight 이후 un-highlight할때
"nmap <silent> <leader>/ :nohlsearch<CR>
"set incsearch "with hlsearch incremetal search", slow for big-size file

""search pattern시 대소문자 구별을 하지 않는다.
"ignorecase toggle을 원하면 :set ic!
set ignorecase

""search pattern이 모두 소문자이면 실제 검색시 대소문자 구별 안한다.
"만약 구별을 해야 한다면 xxx search시 /\Cxxx로 검색해라
set smartcase


"autoe complete
""=============================================================================="
set history=200 "viminfo history buffer"
set completeopt+=menuone
set complete-=i
set complete-=t
set wildchar=<Tab> "autocomplete에 사용되는 key
set wildmenu "autocomplete시 simple menu를 보여줌
set wildmode=longest:full,full

set smartindent "똑똑한 indent"
set autoindent "자동 indent in newline"
set cindent "c일때 자동 indent"
set cinoptions=:0,g0,(0,l1,t0
set nofoldenable "not folding"

"editing
"=============================================================================="
set hidden "새로운 buffer를 열기전에 이전 buffer를 반드시 저장하지v않아도(hidden) 된다
"set autoread "file auto reload, when file is changed outside
"set autowrite "아래와 같은 명령시 자동으로 저장 하는 가에 대한 옵션이다.
            " :next, :rewind, :last, :first, :previous, :stop, :suspend, :tag, :!,
set clipboard+=unnamed " share windows clipboard
set backspace=indent,eol,start "make backspace more flexible

"for real tab not 4space, plz input <C-V> <TAB>
set expandtab "use space instead of tab"
set tabstop=4 "tab key를 4width로 조정"
set shiftwidth=4 "auto indentation시 width"
set softtabstop=0

"toggle paste mode, when you copy text from external clipboard, and paste, ban cascading indentation
set pastetoggle=<Ins>
"nmap <LocalLeader>pp :set pastetoggle<cr>

" when you open root previledged file, and save please use w!!
cmap w!! w !sudo tee % >/dev/null

"hightlight spaces end of the line.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

"remove extra whitespaces when it saves.
"autocmd FileType c,cpp,java autocmd BufWritePre <buffer> :%s/\s\+$//e
"autocmd BufWritePre *.java :%s/\s\+$//e
func! FUNC_RemoveExtraWhitespace()
    %s/\s\+$//e
endfunc
nmap <Leader>rw :call FUNC_RemoveExtraWhitespace()<cr>

"unix format으로 변경하고,"trailing space 지우기
func! FUNC_dos2unix()
    %s/^M//g
    %s/\s\+$//
endfunc
nmap  <LocalLeader>unix :call FUNC_dos2unix()<cr>

" change Pmenu color.
hi PmenuSel ctermfg=7 ctermbg=4 guibg=#555555 guifg=#ffffff

"==============================================================================="
" FuzzyFile
"-------------------------------------------------------------------------------"
map <Leader>fc :FufCoverageFile!<CR>
map <Leader>ff :FufFile **/<CR>
map <Leader>ft :FufTag!<CR>
"map <F2> :FufFile **/<CR>
map <Leader>fb :FufBuffer!<CR>
"map <Leader>fd :FufDir!<CR>

"let g:fuf_coveragefile_globPatterns = ['g:RootDir/**/']
let g:fuf_coveragefile_exclude = '\v\~$|\.(o|exe|dll|bak|orig|swp|class|html)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])'
"noremap <F3> :FufTagWithCursorWord!<CR>
map <Leader>fT :FufTagWithCursorWord!<CR>

"==============================================================================="
" tagvar plugin settings
"-------------------------------------------------------------------------------"
nnoremap <silent> <F9>hh :help my_tag<CR>
"nnoremap <silent> <F9> :TagbarToggle<CR>
nnoremap <silent> <F9> :TlistToggle<CR>

"==============================================================================="
"" minibufexpl
"-------------------------------------------------------------------------------"
"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplModSelTarget = 1

"==============================================================================="
"" split window resize
"-------------------------------------------------------------------------------"
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

"==============================================================================="
"" Vundle
"-------------------------------------------------------------------------------"
set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'
"
" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'tpope/vim-rails.git'
" vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'
"Bundle 'minibufexpl.vim'
Bundle 'javacomplete'
Bundle 'AutoComplPop'
Bundle 'Tagbar'
Bundle 'taglist.vim'
Bundle 'BufOnly.vim'
" non github repos
"Bundle 'git://git.wincent.com/command-t.git'
" git repos on your local machine (ie. when working on your own plugin)
" ...

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
