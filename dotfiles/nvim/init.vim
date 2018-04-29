" vim: set fdm=marker fmr={{{,}}} fdl=0 :

scriptencoding utf-8

augroup dotfilesdetect
  au BufNewFile,BufRead * if expand("%:p") =~# $DOTFILES | call martin#dotfile#init() | endif
augroup END

" minpac {{{
command! PackUpdate packadd minpac | source $MYVIMRC | redraw! | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()

if !isdirectory($HOME . '/.config/nvim/pack/minpac/opt')
  echohl String | echo "Installing that minpac for ya" | echohl None
  !mkdir -p ~/.config/nvim/pack/minpac/opt && git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac
  echohl String | echo ":PackUpdate run please" | echohl None
endif

packadd minpac
source ~/.config/nvim/packages.vim
" }}}
" Emmet customization {{{

" Remapping <C-y>, just doesn't cut it.
function! s:expand_html_tab()
        " try to determine if we're within quotes or tags.
        " if so, assume we're in an emmet fill area.
        let line = getline('.')
        if col('.') < len(line)
                let line = matchstr(line, '[">][^<"]*\%'.col('.').'c[^>"]*[<"]')
                if len(line) >= 2
                        return "\<C-n>"
                endif
        endif
        " expand anything emmet thinks is expandable.
        if emmet#isExpandable()
                return emmet#expandAbbrIntelligent("\<tab>")
                " return "\<C-y>,"
        endif
        " return a regular tab character
        return "\<tab>"
endfunction
" let g:user_emmet_expandabbr_key='<Tab>'
" imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

autocmd FileType html,css,scss imap <silent><buffer><expr><tab> <sid>expand_html_tab()
let g:user_emmet_mode='a'
let g:user_emmet_complete_tag = 0
let g:user_emmet_install_global = 0
autocmd FileType html,css,scss EmmetInstall

"}}}
" General Options: {{{

" tab stuff
set tabstop=4
set softtabstop=4
set expandtab
set smarttab
set shiftwidth=4
set autoindent
set smartindent
" --
set completeopt=longest,menuone
set shortmess+=c
set autochdir
let g:netrw_home=$HOME.'/.cache'
let mapleader="\<Space>"
let maplocalleader = "\\"
set expandtab "always use spaces instead of tabs
set mouse=a "ckicl
set number "show line numbers
set relativenumber "set to relative number mode
set helpheight=40 ""
set hidden "Required for operations modifying multiple buffers like rename.
set scrolloff=5
set sidescrolloff=5
set clipboard=unnamed
set nowrap
set noswapfile "vim will never chash on you
let g:python3_host_prog = '/usr/local/bin/python3' " set python3 host program location
set virtualedit=block " allow cursor to move where there is no text in visual block mode
set lazyredraw " don't bother updating screen during macro playback
set foldtext=martin#settings#foldtext() "overrides default fold design
set inccommand=nosplit "auto preview for stuff like :%s/re/place/
set synmaxcol=200 "don't bother syntax highlighting long lines
set noshowmode " as lightline shows that already

"}}}
" Design, theming {{{

let g:phpactorPhpBin = 'php'
let g:phpactorBranch = 'develop'
let g:phpactorOmniError = v:false

set termguicolors
" almost default but using horizonal cursor instead of block
set guicursor=n-v-c-sm:hor20,i-ci-ve:ver25,r-cr-o:block
" http://xahlee.info/comp/unicode_drawing_shapes.html
set list " display unprintable characters
set listchars=nbsp:⦸, " hazard character  
set listchars+=tab:⇥─, " tab example	 here
set listchars+=extends:⦢, " if nowrap overflows rigth
set listchars+=precedes:⦑, " if nowrap overflows left
set listchars+=space:⋅, " U+22C5 dot operator
set listchars+=trail:• " bullet (U+2022, UTF-8: E2 80 A2)
set listchars+=eol:¬

set fillchars+=fold:┄

syntax on
colorscheme deus

set cursorline

" no intro window for professionals
set shortmess+=I

" }}}
" Leader Maps {{{

" edit vimrc in vertical split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" source vimrc
nnoremap <leader>sv :so $MYVIMRC<cr>
" distraction free mode toggle
nnoremap <leader>G :Goyo<cr>
" FZF most recent commands
nnoremap <leader>c :call fzf#vim#command_history()<cr>
" FZF most recently used files with mini preview
nnoremap <leader>u :call fzf#vim#history(fzf#vim#with_preview('right'))<cr>
" FZF git files list +untracked -gitignored +others
nnoremap <leader>f :GFiles --others --exclude-standard --cached<cr>
" FZF cwd files list
nnoremap <leader>F :Files<cr>
" FZF buffer list
nnoremap <leader>b :Buffers<cr>
" FZF all commands list
nnoremap <leader>C :Commands<cr>
" remove highlight AND close preview window
nnoremap <silent> <leader>, :nohl<cr>:pclose<cr>
" go to previously visited buffer
nnoremap <leader><leader> <c-^>
" quit buffer (buffer-delete)
nnoremap <silent> <leader>q :bd<cr>
" write buffer
nnoremap <leader>w :write<cr>
" focus current window only, hide others
nnoremap <leader>o :only<cr>
" trim trailing whitespace
nnoremap <silent> <leader>zz :call martin#functions#substitute('\s\+$', '', '')<cr>
" show full file path
nnoremap <leader>p :echo expand('%')<cr>
" TODO yank full file path
nnoremap <leader>pp :echo expand('%')<cr>

" }}}
" Local Leader Maps {{{

" switch cursor accoss parentasies
nnoremap <localleader><localleader> %
" toggle mode that keeps cursor centered
nnoremap <localleader>c :call martin#functions#togglecenteredcursor()<cr>

" }}}
" Just Maps {{{

" tab to toggle one fold
nnoremap <tab> za
" shift-tab to focus on one fold, close others
nnoremap <s-tab> zMza
" yank to the end of line (Y is alias of yy)
nnoremap Y y$
" creates a markers when performing jumps larger than 5 (use <c-o> to move jumplist)
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'
" cheap move across splits (alt+<hjkl>) set left alt to be esc+ at iterm2 profile keys
nnoremap <a-l> <c-w>l
nnoremap <a-k> <c-w>k
nnoremap <a-h> <c-w>h
nnoremap <a-j> <c-w>j
" it's an ex mode hotkey
nnoremap Q <nop>
" jump to bottom and center for me
nnoremap G Gzz

" }}}
" Terminal Mappings {{{
"
" cheap move across splits support
tnoremap <a-h> <c-\><c-n><c-w><c-h>
tnoremap <a-j> <c-\><c-n><c-w><c-j>
tnoremap <a-k> <c-\><c-n><c-w><c-k>
tnoremap <a-l> <c-\><c-n><c-w><c-l>
tnoremap <space> <cr>
"
" }}}

let g:phpactorPhpBin = "/usr/local/bin/php"

let g:cm_matcher = {'module': 'cm_matchers.fuzzy_matcher', 'case': 'smartcase'}

" augroup remember_folds
"   autocmd!
"   autocmd BufWinLeave * mkview
"   autocmd BufWinEnter * silent! loadview
" augroup END


" " -------- Vdebug ---------
" let g:vdebug_options={
"       \   'debug_file': '~/vdebug.log',
"       \   'debug_file_level': 0,
"       \   'watch_window_style': 'compact',
"       \   'marker_default': '⬦',
"       \   'continuous_mode': 1,
"       \   'ide_key': '',
"       \   'break_on_open': 0,
"       \   'window_commands': {
"       \     'DebuggerStack': 'belowright new',
"       \     'DebuggerWatch': 'vertical belowright new',
"       \     'DebuggerStatus': 'belowright new'
"       \   },
"       \   'on_close': 'stop',
"       \   'path_maps': {},
"       \   'auto_start': 1,
"       \   'window_arrangement': ['DebuggerWatch', 'DebuggerStack', 'DebuggerStatus'],
"       \   'marker_closed_tree': '▸',
"       \   'background_listener': 1,
"       \   'timeout': 20,
"       \   'port': 9000,
"       \   'marker_open_tree': '▾',
"       \   'debug_window_level': 0,
"       \   'server': ''
"       \ }

" command! RunDebugger packadd vdebug | VdebugStart

" :help VdebugCommands
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '•'
let g:ale_sign_warning = '•'
let g:ale_sign_column_always = 1

let g:lightline = {}

let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component = {
\  	'lineinfo': '%3l:%-2v',
\ }
let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }

let g:lightline.active = { 'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]] }
let g:lightline.tabline = {
  \   'left': [ ['tabs'] ],
  \   'right': [ ['close'] ]
  \ }
set showtabline=2  " Show tabline
set guioptions-=e  " Don't use GUI tabline

let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"

let g:pad#dir="~/notes"
let g:pad#default_format = "markdown"

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsSnippetsDir = $HOME."/.config/UltiSnips"
let g:UltiSnipsSnippetDirectories = ['UltiSnips', $HOME.'/.config/UltiSnips']
let g:UltiSnipsEnableSnipMate = 0

let g:deoplete#enable_at_startup = 1

let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsEditSplit='vertical'

function! EditFtPluginFile()
    exec ":e ~/.config/nvim/ftplugin/".expand('%:e').".vim"
  endfunction
nnoremap <F12> :call EditFtPluginFile()<cr>

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
