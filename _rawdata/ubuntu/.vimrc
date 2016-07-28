"===============================================================================
"        Filename: vimrc
"          Author: Wu Yin(吴垠)
"           Email: lazy_fox#gmail.com
"        Homepage: http://blog.csdn.net/wooin
"         Created: 2007-10-26
"===============================================================================
"set encoding=gb2312
set fileencodings=utf-8,gb2312,gbk,gb18030
set termencoding=utf-8
"set encoding=prc
set guifont=Monospace\ 15   " 设置字体，字体名称和字号
set tabstop=4       " 设置tab键的宽度 Force tabs to be displayed/expanded to 4 spaces (instead of default 8)
set expandtab 		" Turn Tab keypresses into spaces.
set backspace=2     " 设置退格键可用
"set number             " 显示行号
"set vbt_vb=        " vim进行编辑时，如果命令错误，会发出一个响声，该设置去掉响声
"set wrap           " 自动换行
"set nowrap         " 不自动换行
"set linebreak       " 整词换行
"set whichwrap=b,s,<,>,[,]       " 光标从行首和行末时可以跳到另一行去
"set list                       " 显示制表符
"set listchars = tab:>-,trail:- " 将制表符显示为'>---',将行尾空格显示为'-'
"set listchars=tab:./ ,trail:.   " 将制表符显示为'.   '
set autochdir                   " 自动设置目录为正在编辑的文件所在的目录
set hidden          " 没有保存的缓冲区可以自动被隐藏
"set scrolloff=5

"--------------------------------------------------------------------------------
" 查找/替换相关的设置
"--------------------------------------------------------------------------------
set hlsearch        " 高亮显示搜索结果
set incsearch       " 查询时非常方便，如要查找book单词，当输入到/b时，会自动找到
                    " 第一个b开头的单词，当输入到/bo时，会自动找到第一个bo开头的
                    " 单词，依次类推，进行查找时，使用此设置会快速找到答案，当你
                     " 找要匹配的单词时，别忘记回车
set gdefault        " 替换时所有的行内匹配都被替换，而不是只有第一个

"--------------------------------------------------------------------------------
" 状态栏相关的设置
"--------------------------------------------------------------------------------
set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
set laststatus=2    " always show the status line
set ruler           " 在编辑过程中，在右下角显示光标位置的状态行

"--------------------------------------------------------------------------------
" 编程相关的设置
"--------------------------------------------------------------------------------
set completeopt=longest,menu    " 关掉智能补全时的预览窗口
"filetype pluginindenton       " 加了这句才可以用智能补全
filetype plugin indent on
"set tags=/local/projects/android_gingerbread/tags
"set tags=/local/projects/android4.0.3.r1/tags
syn on              " 打开语法高亮
set showmatch       " 设置匹配模式，类似当输入一个左括号时会匹配相应的那个右括号
set smartindent     " 智能对齐方式
set shiftwidth=4    " 换行时行间交错使用4个空格
set autoindent      " 自动对齐
set ai!             " 设置自动缩进
"colorscheme torte

"--------------------------------------------------------------------------------
" 代码折叠
"--------------------------------------------------------------------------------
"set foldmarker={,}
"set foldmethod=marker
set foldmethod=syntax
set foldlevel=100       " Don't autofold anything (but I can still fold manually)
"set foldopen-=search   " don't open folds when you search into them
"set foldopen-=undo     " don't open folds when you undo stuff
"set foldcolumn=4

"--------------------------------------------------------------------------------
" 模仿MS Windows中的快捷键
"--------------------------------------------------------------------------------
vmap <C-c> "yy
vmap <C-x> "yd
nmap <C-v> "yp
vmap <C-v> "yp
nmap <C-a> ggvG$

"--------------------------------------------------------------------------------
" 窗口操作的快捷键
"--------------------------------------------------------------------------------
nmap wv     <C-w>v     " 垂直分割当前窗口
nmap wc     <C-w>c     " 关闭当前窗口
nmap ws     <C-w>s     " 水平分割当前窗口

"--------------------------------------------------------------------------------
" 模仿MS Windows中的保存命令: Ctrl+S
"--------------------------------------------------------------------------------
imap <C-s> <Esc>:wa<cr>i<Right>
nmap <C-s> :wa<cr>




"###############################################################################
" The following is the Plugins' setting
"###############################################################################

"--------------------------------------------------------------------------------
" TagList :Tlist
"--------------------------------------------------------------------------------
"let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window=1

"--------------------------------------------------------------------------------
" netrw 文件浏览器 :e <PATH>
"--------------------------------------------------------------------------------
"let g:netrw_winsize = 30       " 浏览器宽度

"--------------------------------------------------------------------------------
" QuickFix
"--------------------------------------------------------------------------------
nmap <F6> :cn<cr>   " 切换到下一个结果
nmap <F7> :cp<cr>   " 切换到上一个结果

"--------------------------------------------------------------------------------
" WinManager :WMToggle
"--------------------------------------------------------------------------------
let g:winManagerWindowLayout='FileExplorer|TagList'
"let g:winManagerWidth = 30
"let g:defaultExplorer = 0
"nmap <C-w><C-b> :BottomExplorerWindow<cr> " 切换到最下面一个窗格
"nmap <C-w><C-f> :FirstExplorerWindow<cr>   " 切换到最上面一个窗格
nmap wm :WMToggle<cr> " 是nomal模式的命令，不是Ex模式的

"--------------------------------------------------------------------------------
" MiniBufExp
"--------------------------------------------------------------------------------
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplForceSyntaxEnable = 1
"let g:miniBufExplSplitToEdge = 0

"--------------------------------------------------------------------------------
" cscope
"--------------------------------------------------------------------------------
set nocsverb
"cs add /local/projects/android_gingerbread/cscope.out /local/projects/android_gingerbread
"cs add /local/projects/android4.0.3.r1/cscope.out /local/projects/android4.0.3.r1/ 

" add any database in current directory
"if filereadable("cscope.out")
"cs add cscope.out
"else add database pointed to by environment
"elseif $CSCOPE_DB != ""
"cs add $CSCOPE_DB
"endif

set csverb
set cscopequickfix=s-,c-,d-,i-,t-,e-
set cscopetag
"set csprg=/usr/local/bin/cscope
" 按下面这种组合键有技巧,按了<C-_>后要马上按下一个键,否则屏幕一闪
" 就回到nomal状态了
" <C-_>s的按法是先按"Ctrl+Shift+-",然后很快再按"s"
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<cr><cr> :cw<cr>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<cr><cr> :cw<cr>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<cr><cr> :cw<cr>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<cr><cr> :cw<cr>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<cr><cr> :cw<cr>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<cr><cr>
nmap <C-_>i :cs find i <C-R>=expand("<cfile>")<cr><cr> :cw<cr>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<cr><cr> :cw<cr>

"--------------------------------------------------------------------------------
" Grep
"--------------------------------------------------------------------------------
"直接按下<F3>键来查找光标所在的字符串
nnoremap <silent> <F3> :Rgrep<CR>

"--------------------------------------------------------------------------------
" A
"--------------------------------------------------------------------------------
nnoremap <silent> <F12> :A<CR>

"--------------------------------------------------------------------------------
" NERD_commenter
"--------------------------------------------------------------------------------
let NERD_c_alt_style = 1    " 将C语言的注释符号改为//, 默认是/**/
"nmap <F5> ,cc

"--------------------------------------------------------------------------------
" SuperTab :SuperTabHelp
"--------------------------------------------------------------------------------
"let g:SuperTabRetainCompletionType = 2
"let g:SuperTabDefaultCompletionType = "<C-X><C-O>"

"--------------------------------------------------------------------------------
" CVim :help csupport
"--------------------------------------------------------------------------------
let g:C_Comments = "no"         " 用C++的注释风格
let g:C_BraceOnNewLine = "no"   " '{'是否独自一行
let g:C_AuthorName = "Wu Yin"
let g:C_Project="F9"
let g:Cpp_Template_Function = "c-function-description-wuyin"
let g:C_TypeOfH = "c"           " *.h文件的文件类型是C还是C++

"##################################################################
"########################## End Of Vimrc ##########################
"##################################################################

" if filetype is C
"   TODO
" fi

"--------------------------------------------------------------------------------
" 补充
"--------------------------------------------------------------------------------
"set fileencodings=utf-8,gbk,ucs-bom,cp936

" 使用 murphy 调色板
"colo murphy
"
set nocompatible
" 设定文件浏览器目录为当前目录
set bsdir=buffer
set autochdir
" 设置编码
"set enc=utf-8
" 设置文件编码
"set fenc=utf-8
" 设置文件编码检测类型及支持格式
set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
" 指定菜单语言
set langmenu=zh_CN.UTF-8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
" 设置语法高亮度
set syn=cpp

set cindent shiftwidth=4
set autoindent shiftwidth=4
" C/C++注释
set comments=://
" 修正自动C式样注释功能 <2005/07/16>
set comments=s1:/*,mb:*,ex0:/
" 增强检索功能
set tags=./tags,./../tags,./**/tags
" 保存文件格式
set fileformats=unix,dos
" 键盘操作
map <Up> gk
map <Down> gj
" 命令行高度
set cmdheight=1
" 中文帮助
if version > 603
set helplang=cn
endif
