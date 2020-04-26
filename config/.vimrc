set nocompatible "关闭与vi的兼容模式
set backspace=indent,eol,start "解决backspace不可用问题
filetype off


"----------------vundle插件管理器配置------------------
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
 
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"------------------plugins start------------------
" 自动缩进
Plugin 'vim-scripts/indentpython.vim'
" 自动补全
"Plugin 'Valloric/YouCompleteMe'
" 语法检查
Plugin 'vim-syntastic/syntastic'
" flake8 代码风格检查
Plugin 'nvie/vim-flake8'
" Class structure viewer
Plugin 'majutsushi/tagbar'
" 配色方案
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
" nerdtree 树形目录
Plugin 'scrooloose/nerdtree'
" nerdtree 添加git支持
Plugin 'Xuyuanp/nerdtree-git-plugin'
" 状态栏美化
Plugin 'Lokaltog/vim-powerline'
" 缩进指示线
Plugin 'Yggdroot/indentLine'
" autopep8 自动格式化
Plugin 'tell-k/vim-autopep8'
" auto-pairs 自动补全括号引号
Plugin 'jiangmiao/auto-pairs'
" Git Integration
Plugin 'tpope/vim-fugitive'
" ctrl+p 搜索插件
Plugin 'kien/ctrlp.vim'

"-------------------plugins end-------------------

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" 插件配置
" YouCompleteMe 插件配置
let g:ycm_min_num_of_chars_for_completion = 2  "开始补全的字符数
let g:ycm_python_binary_path = 'python'  "jedi模块所在python解释器路径
let g:ycm_seed_identifiers_with_syntax = 1  "开启使用语言的一些关键字查询
let g:ycm_autoclose_preview_window_after_completion=1 "补全后自动关闭预览窗口
autocmd InsertLeave * if pumvisible() == 0|pclose|endif	"离开插入模式后自动关闭预览窗口"
let g:ycm_confirm_extra_conf=0 "去掉提示
nnoremap <c-j> :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_auto_trigger = 1   "启用YCM
" 配色配置
colorscheme zenburn
set background=dark
set t_Co=256
" 添加开关树形目录的快捷键 ctrl+n
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['__pycache__', '\~$', '\.pyc$', '\.swp$'] "设置忽略.pyc文件
" 设置autopep8快捷键 F8
autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>
" 设置tagbar快捷键 F9
nmap <F9> :TagbarToggle<CR>
" 设置tagbar宽度35
let g:tagbar_width = 35
"关闭排序,即按标签本身在文件中的位置排序
let g:tagbar_sort = 0
autocmd BufReadPost *.py call tagbar#autoopen() "如果是python语言的程序的话，tagbar自动开启
"autocmd BufReadPost *.py 25vsp ./ "python文件自动打开nerdtree


"-------------------快捷键配置--------------------
"插入模式换行 ctrl+L
inoremap <C-l> <Esc>o



"--------------------vim常规配置--------------------
set number "显示行号
set nowrap    "不自动折行
set showmatch    "显示匹配的括号
set scrolloff=3        "距离顶部和底部3行"
set encoding=utf-8  "编码
set fenc=utf-8      "编码
"set mouse=a        "启用鼠标
set hlsearch        "搜索高亮
syntax on    "语法高亮
set splitright  "设置右边打开新窗口
set splitbelow  "设置下方打开新窗口
" 设置文件打开后光标处于上次退出的位置
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


"python config
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
"    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

"html config
au BufNewFile,BufRead *.html
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
"    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

"f5 to run
map <F5> :call RunPython()<CR>
func! RunPython()
    exec "W"
    if &filetype == 'python'
        exec "!python %"
    endif
endfunc

set conceallevel=0
