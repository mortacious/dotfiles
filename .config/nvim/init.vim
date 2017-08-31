set shell=/bin/bash


" Leader key {{{
  let maplocalleader = ','
  let mapleader = ' '
  let g:mapleader = ' '
"}}}

" functions {{{

  function! GetDir(suffix) "{{{
    return resolve(expand(s:nvim_dir . g:path_separator . a:suffix))
  endfunction "}}}

  function! GetCacheDir(suffix) "{{{
    return resolve(expand(s:cache_dir . g:path_separator . a:suffix))
  endfunction "}}}

  function! StripTrailingWhitespace() "{{{
    call Preserve("%s/\\s\\+$//e")
  endfunction "}}}

  function! s:EnsureExists(path) "{{{
    if !isdirectory(expand(a:path))
      call mkdir(expand(a:path))
    endif
  endfunction "}}}

  function! s:AddTags(path) "{{{
    for f in split(glob(a:path . g:path_separator . '*.tags'), '\n')
      execute 'set tags+=' . f
    endfor
  endfunction "}}}

"}}}

" init {{{
  let g:path_separator = '/'
  let s:nvim_dir = fnamemodify(resolve(expand('<sfile>')), ':p:h')
  let s:cache_dir = s:nvim_dir . g:path_separator . '.cache'
  let s:github_path = GetDir('plugins') . g:path_separator .
      \ 'repos' . g:path_separator . 'github.com'
  let s:dein_path = s:github_path . g:path_separator .
      \ 'Shougo' . g:path_separator . 'dein.vim'
  execute 'set runtimepath+=' . s:dein_path
  let s:ale_path = s:github_path . g:path_separator .
        \ 'w0rp' . g:path_separator . 'ale'
  execute 'set runtimepath+=' . s:ale_path
" }}}

" General Setup and dein {{{
  set nocompatible
  filetype off
  set all& " reset everything to defaults

  " cscopeprg
  set cscopeprg=gtags-cscope  

" append to runtime path
  set rtp+=/usr/share/vim/vimfiles

" start dein
  call dein#begin(GetDir('plugins'))
" }}}

" base configuration {{{
  " filetype plugin on
  filetype plugin indent on
  " encoding
  set encoding=utf-8
  set fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,gb2312,gbk,gb18030,big5,latin1
  set fileformats=unix,mac,dos
  set termencoding=utf-8
  set listchars=extends:>,precedes:<,tab:▶\ ,trail:•
  set showbreak&

  set timeoutlen=1000 " mapping timeout
  set ttimeoutlen=-1  " keycode timeout

  " Mouse Settings 
  set mouse=a " enable mouse
  set mousehide " hide mouse when typing

  set history=1000
  set ttyfast " Assume fast terminal

  set clipboard=unnamedplus
  set hidden
  set autoread
  set nrformats-=octal
  set showcmd

  " tags
  set tags=./tags,tags
  " add all tags, which should be done before set wildignore
  call s:AddTags(GetDir('tags'))
  
  set showfulltag
  set modeline
  set modelines=5

  "if $SHELL =~ '/fish$'
    " vim expects to be run from a POSIX shell.
  ""  set shell=sh
  "endif

  set noshelltemp  " use pipes
  " whitespace
  set backspace=indent,eol,start  " allow backspacing everything in insert mode

  " indents
  set expandtab
  set autoindent
  set smarttab
  set tabstop=4
  set shiftwidth=4

  set list  "highlight whitespace
  set shiftround
  set linebreak

  set scrolloff=10  " minimum number of lines above and below cursor
  set scrolljump=1  "minimum number of lines to scroll
  set sidescrolloff=5  " minimum number of columns to left and right of cursor
  set display+=lastline

  set wildmenu  "show list for autocomplete
  set wildmode=list:full
  set wildignore+=*~,*.o,core.*,*.exe,.git/,.hg/,.svn/,.DS_Store,*.pyc
  set wildignore+=*.swp,*.swo,*.class,*.tags,tags,tags-*,cscope.*,*.taghl
  set wildignore+=.ropeproject/,__pycache__/,venv/,*.min.*,images/,img/,fonts/
  set wildignorecase

  " set autowrite
  " set background=dark
  
  set inccommand=nosplit
  set linebreak

  set nojoinspaces
  set pastetoggle=
  set ruler
  "set showmode
  set spell
  set title
  set textwidth=0
  set formatoptions+=o
  
  
  set noerrorbells
  set linespace=0

  " always split below or right of current buffer
  set splitbelow
  set splitright

  " disable sounds
  set noerrorbells
  set novisualbell
  set t_vb=

  " searching
  set hlsearch  " highlight searches
  set incsearch  " incremental searching
  set ignorecase  " ignore case for searching
  set smartcase  " do case-sensitive if there's a capital letter

  set nostartofline       " Do not jump to first character with page commands.


  " Tell Vim which characters to show for expanded TABs,
  " trailing whitespace, and end-of-lines. VERY useful!
  " if &listchars ==# 'eol:$'
  ""  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  " endif

  " Also highlight all tabs and trailing whitespace characters.
  " highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
  " match ExtraWhitespace /\s\+$\|\t/

  set gdefault            " Use 'g' flag by default with :s/foo/bar/.
  set magic               " Use 'magic' patterns (extended regular expressions).

  if executable('ack')
    set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
    set grepformat=%f:%l:%c:%m
  endif
  if executable('ag')
    set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
    set grepformat=%f:%l:%c:%m
  endif

  " directory management {{{

    " persistent undo
    if exists('+undofile')
      set undofile
      let &undodir = GetCacheDir('undo')
    endif

    " backups
    set backup
    let &backupdir = GetCacheDir('backup')

    " swap files
    let &directory = GetCacheDir('swap')
    set noswapfile

    call s:EnsureExists(s:cache_dir)
    call s:EnsureExists(&undodir)
    call s:EnsureExists(&backupdir)
    call s:EnsureExists(&directory)

  "}}}
" }}}

" ui configuration {{{

  set showmatch  " automatically highlight matching braces/brackets/etc.
  set matchtime=2  " tens of a second to show matching parentheses
  set number
  set lazyredraw
  set laststatus=2
  set noshowmode
  set foldenable  " enable folds by default
  set foldmethod=syntax  " fold via syntax of files
  set foldlevelstart=99  " open all folds by default
  let g:xml_syntax_folding = 1  " enable xml folding

  set cursorline
  autocmd WinLeave * setlocal nocursorline
  autocmd WinEnter * setlocal cursorline
  "let &colorcolumn = g:navim_settings.max_column

  " set cursorcolumn
  " autocmd WinLeave * setlocal nocursorcolumn
  " autocmd WinEnter * setlocal cursorcolumn

  set t_Co=256  " why you no tell me correct colors?!?!

" }}}

" Plugin Configuration {{{
  "call dein#add('taohex/vim-leader-guide')

  " Lightline
  call dein#add('itchyny/lightline.vim') " {{{
    set showtabline=2  " always show tabline


    let g:lightline = {
    \ 'colorscheme': 'onedark',
    \ 'active': {
    \ 'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], [ 'buffertag' ], ],
    \ 'right': [ [ 'lineinfo', 'syntaxcheck' ], [ 'fileinfo' ], [ 'filetype' ], ],
    \ },
    \ 'inactive': {
    \ 'left': [ [ 'filename' ], ],
    \ 'right': [ [ 'lineinfo' ], ],
    \ },
    \ 'tabline': {
    \ 'left': [ [ 'bufferinfo' ], [ 'bufferbefore', 'buffercurrent', 'bufferafter' ], ],
    \ 'right': [ [ 'close' ], ],
    \ },
    \ 'component_expand': {
    \ 'buffercurrent': 'lightline#buffer#buffercurrent2',
    \ 'bufferall': 'lightline#buffer#bufferall',
    \ },
    \ 'component_type': {
    \ 'buffercurrent': 'tabsel',
    \ 'bufferall': 'tabsel',
    \ },
    \ 'component_function': {
    \ 'bufferbefore': 'lightline#buffer#bufferbefore',
    \ 'bufferafter': 'lightline#buffer#bufferafter',
    \ 'bufferinfo': 'lightline#buffer#bufferinfo',
    \ 'buffertag': 'LightlineTag',
    \ 'fugitive': 'LightlineFugitive',
    \ 'fileinfo': 'LightlineFileinfo',
    \ 'filename': 'LightlineFilename',
    \ 'fileformat': 'LightlineFileformat',
    \ 'filetype': 'LightlineFiletype',
    \ 'fileencoding': 'LightlineFileencoding',
    \ 'mode': 'LightlineMode',
    \ 'syntaxcheck': 'LightlineSyntaxcheck',
    \ },
    \ 'component': {
    \ 'lineinfo': '%3p%% %3l:%-2v',
    \ 'readonly': '%{&readonly?"":""}',
    \ 'modified': '%{&filetype=="help"?"":&modified?"✭":&modifiable?"":"-"}',
    \ 'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
    \ },
    \ 'component_visible_condition': {
    \ 'readonly': '(&filetype!="help"&& &readonly)',
    \ 'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
    \ 'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
    \ },
    \ 'separator': { 'left': '▶', 'right': '◀' },
    \ 'subseparator': { 'left': '>', 'right': '<' },
    \ 'tabline_separator': { 'left': '▶', 'right': '◀' },
    \ 'tabline_subseparator': { 'left': '>', 'right': '<' },
    \ }


    let g:lightline_buffer_logo = '' " ' '
    let g:lightline_buffer_readonly_icon = ''
    let g:lightline_buffer_modified_icon = '✭'
    let g:lightline_buffer_git_icon = ' '
    let g:lightline_buffer_ellipsis_icon = '..' " '…'
    let g:lightline_buffer_expand_left_icon = '◀ '  " '… '
    let g:lightline_buffer_expand_right_icon = ' ▶' " ' …'
    let g:lightline_buffer_progress_icon = '░'
    let g:lightline_buffer_wait_animate = '⠇⠏⠋⠙⠹⠸⠼⠴⠦⠧'

    let g:lightline.separator.left = "\uE0B0"
    let g:lightline.subseparator.left = "\uE0B1"
    let g:lightline.separator.right = "\uE0B2"
    let g:lightline.subseparator.right = "\uE0B3"
    let g:lightline.tabline_separator.left = "\uE0B0"
    let g:lightline.tabline_subseparator.left = "\uE0B1"
    let g:lightline.tabline_separator.right = "\uE0B2"
    let g:lightline.tabline_subseparator.right = "\uE0B3"

    let g:lightline.mode_map = {
    \ 'n' : 'N',
    \ 'i' : 'I',
    \ 'R' : 'R',
    \ 'v' : 'V',
    \ 'V' : 'V',
    \ 'c' : 'C',
    \ "\<C-v>": 'V',
    \ 's' : 'S',
    \ 'S' : 'S',
    \ "\<C-s>": 'S',
    \ '?': ' ',
    \ }

    function! LightlineTag()
      " :help tagbar-statusline
      let line = tagbar#currenttag('%s', '')
      return line
    endfunction

    function! LightlineSyntaxcheck()
        return '' " ALEGetStatusLine()
    endfunction

    function! LightlineModified()
      return &ft =~? 'help' ? '' : &modified ?
          \ g:lightline_buffer_modified_icon : &modifiable ? '' : '-'
    endfunction

    function! LightlineReadonly()
      return &ft !~? 'help' && &readonly ? g:lightline_buffer_readonly_icon : ''
    endfunction

    function! LightlineFugitive()
      if exists('*fugitive#head')
        let _ = fugitive#head()
        return strlen(_) ? g:lightline_buffer_git_icon . _ : ''
      endif
      return ''
    endfunction

    function! LightlineFileinfo()
      return winwidth(0) > 70 ?
          \ (LightlineFileencoding() . ' ' . LightlineFileformat()) : ''
    endfunction

    function! LightlineFilename()
      let fname = expand('%:.') "TODO add symbol
      return fname ==# '__Tagbar__' ? g:lightline.fname :
          \ fname =~# '__Gundo\|NERD_tree' ? '' :
          \ &ft ==# 'fzf' ? '' :
          \ ('' !=# LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
          \ ('' !=# fname ? fname : '[No Name]') .
          \ ('' !=# LightlineModified() ? ' ' . LightlineModified() : '')
    endfunction

    function! LightlineFileformat()
      if exists('*WebDevIconsGetFileFormatSymbol')  " support for vim-devicons
        return WebDevIconsGetFileFormatSymbol()
      endif
      return &fileformat
    endfunction

    function! LightlineFiletype()
      if exists('*WebDevIconsGetFileTypeSymbol')  " support for vim-devicons
        return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' .
            \ WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
      endif
      return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
    endfunction

    function! LightlineFileencoding()
      return strlen(&fenc) ? &fenc : &enc
    endfunction

    function! LightlineMode()
      let fname = expand('%:t')
      return fname ==# '__Tagbar__' ? 'Tagbar' :
          \ fname ==# '__Gundo__' ? 'Gundo' :
          \ fname ==# '__Gundo_Preview__' ? 'Gundo Preview' :
          \ fname =~# 'NERD_tree' ? 'NERDTree' :
          \ &ft ==# 'fzf' ? 'fzf' :
          \ &ft ==# 'unite' ? 'Unite' :
          \ &ft ==# 'vimfiler' ? 'VimFiler' :
          \ &ft ==# 'vimshell' ? 'VimShell' :
          \ winwidth(0) > 60 ? lightline#mode() : ''
    endfunction

    function! CtrlPMark()
      if expand('%:t') =~# 'ControlP'
        call lightline#link('iR'[g:lightline.ctrlp_regex])
        return lightline#concatenate([g:lightline.ctrlp_prev,
            \ g:lightline.ctrlp_item, g:lightline.ctrlp_next], 0)
      else
        return ''
      endif
    endfunction

    let g:ctrlp_status_func = {
        \ 'main': 'CtrlPStatusFunc_1',
        \ 'prog': 'CtrlPStatusFunc_2',
        \ }

    function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
      let g:lightline.ctrlp_regex = a:regex
      let g:lightline.ctrlp_prev = a:prev
      let g:lightline.ctrlp_item = a:item
      let g:lightline.ctrlp_next = a:next
      return lightline#statusline(0)
    endfunction

    function! CtrlPStatusFunc_2(str)
      return lightline#statusline(0)
    endfunction

    function! s:filtered_lightline_call(funcname)
        if bufname('%') == '__CS__'
            return
        endif
        execute 'call lightline#' . a:funcname . '()'
    endfunction


    "let g:tagbar_status_func = 'TagbarStatusFunc'

    "function! TagbarStatusFunc(current, sort, fname, ...) abort
    ""  let g:lightline.fname = a:fname
    ""  return lightline#statusline(0)
    "endfunction

    " augroup AutoSyntastic
    "   autocmd!
    "   autocmd BufWritePost *.c,*.cpp call s:syntastic()
    " augroup END
    " function! s:syntastic()
    "   if g:navim_settings.syntaxcheck_plugin ==# 'syntastic'
    "     SyntasticCheck
    "   endif
    "   if g:navim_settings.statusline_plugin ==# 'lightline'
    "     call lightline#update()
    "   endif
    " endfunction

    " disable overwriting the statusline forcibly by other plugins
    "let g:unite_force_overwrite_statusline = 0
    "let g:vimfiler_force_overwrite_statusline = 0
    "let g:vimshell_force_overwrite_statusline = 0
  " }}}

  call dein#add('taohex/lightline-buffer', {'depends': 'itchyny/lightline.vim'})



  call dein#add('ryanoasis/vim-devicons')
  call dein#add('tpope/vim-surround')
  " call dein#add('tpope/vim-repeat')

  call dein#add('skywind3000/asyncrun.vim')
  " call dein#add('tpope/vim-eunuch')
  " call dein#add('tpope/vim-unimpaired') " {{{
  "   nmap <C-Up> [e
  "   nmap <C-Down> ]e
  "   vmap <C-Up> [egv
  "   vmap <C-Down> ]egv
  " " }}}

" color schemes {{{
  call dein#add('joshdick/onedark.vim')
" }}}

" syntax highlighting {{{
  " call dein#add('PotatoesMaster/i3-vim-syntax')
    call dein#add('rust-lang/rust.vim')

  " color
  set t_Co=256
  set background=dark
  colorscheme onedark
  if (has("termguicolors"))
      set termguicolors
  endif
  " let base16colorsapce=256
  set ts=4 sw=4 et

  highlight Normal ctermbg=none
  highlight NonText ctermbg=none

" }}}


" NERDTree"
  call dein#add('scrooloose/nerdtree')
    let g:NERDTreeDirArrows = 1
    let g:NERDTreeDirArrowExpandable = '▸'
    let g:NERDTreeDirArrowCollapsible = '▾'

    let g:NERDTreeIndicatorMapCustom = {
    \ 'Modified'  : '✹',
    \ 'Staged'    : '✚',
    \ 'Untracked' : '✭',
    \ 'Renamed'   : '➜',
    \ 'Unmerged'  : '═',
    \ 'Deleted'   : '✖',
    \ 'Dirty'     : '⚠',
    \ 'Clean'     : '✔︎',
    \ 'Unknown'   : '?'
    \ }

    let NERDTreeAutoDeleteBuffer = 1
    let NERDTreeMinimalUI = 1
    let g:NERDTreeFileExtensionHighlightFullName = 1
    let g:NERDTreeExactMatchHighlightFullName = 1
    let g:NERDTreePatternMatchHighlightFullName = 1

    let g:NERDTreeShowHidden = 1
    let g:NERDTreeQuitOnOpen = 0
    let g:NERDTreeShowLineNumbers = 0
    let g:NERDTreeChDirMode = 0
    let g:NERDTreeShowBookmarks = 1
    let g:NERDTreeIgnore = ['\.git','\.hg','\.svn','\.DS_Store']
    let g:NERDTreeWinPos = 'right'
    let g:NERDTreeWinSize = 40
    let g:NERDTreeBookmarksFile = GetCacheDir('nerdtreebookmarks')
    " close vim if the only window left open is a nerdtree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType ==# "primary") | q | endif

  call dein#add('Xuyuanp/nerdtree-git-plugin')
  call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')
" }}}  





" " C/C++ Stuff {{{
"   call dein#add('vim-scripts/a.vim', {'on_ft': ['c','cpp','cc']})
"   call dein#add('vim-scripts/c.vim', {'on_ft': ['c','cpp','cc']}) " {{{
"     " <http://stackoverflow.com/questions/736701/class-function-names-highlighting-in-vim>
"     " highlight class and function names
"     syn match    cCustomParen    "(" contains=cParen,cCppParen
"     syn match    cCustomFunc     "\w\+\s*(" contains=cCustomParen
"     syn match    cCustomScope    "::"
"     syn match    cCustomClass    "\w\+\s*::" contains=cCustomScope

"     hi def link cCustomFunc  Function
"     hi def link cCustomClass CTagsClass
"   " }}}
"   call dein#add('vim-scripts/echofunc.vim', {'on_ft': ['c','cpp','cc']})
"   call dein#add('vim-scripts/google.vim', {'on_ft': ['c','cpp','cc']})
"   call dein#add('vim-scripts/STL-improved', {'on_ft': ['c','cpp','cc']})
"   call dein#add('octol/vim-cpp-enhanced-highlight', {'on_ft': ['c','cpp','cc']})
" " }}}

" Completition {{{
  call dein#add('honza/vim-snippets')
  call dein#add('oblitum/youcompleteme') " {{{
    set completeopt=longest,menu
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1
    let g:ycm_seed_identifiers_with_syntax = 1
    let g:ycm_min_num_of_chars_for_completition = 1
    let g:ycm_collect_identifiers_from_tags_file = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    " let g:ycm_goto_buffer_command = 'new-tab'

    noremap gd :YcmCompleter GoToDefinitionElseDeclaration<cr>
    let g:ycm_python_binary_path='python'
    " Global ycm extra conf that searches and parses a compile_commands.json automatically
    let g:ycm_global_ycm_extra_conf = GetDir('ycm') . g:path_separator . '.ycm_extra_conf.py'
    let g:ycm_add_preview_to_completeopt = 1
    let g:ycm_autoclose_preview_window_after_completion = 0
    let g:ycm_autoclose_preview_window_after_insertion = 1

    let g:ycm_key_list_select_completion = ['<C-n>','<Down>']
    let g:ycm_key_list_previous_completion = ['<C-p>','<Up>']
    let g:ycm_filetype_blacklist = {'unite': 1}
  " }}}
  call dein#add('IngoHeimbach/neco-vim')
  call dein#add('SirVer/ultisnips') " {{{
    let g:UltiSnipsExpandTrigger = "<Tab>"
    let g:UltiSnipsJumpForwardTrigger = "<Tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
    let g:UltiSnipsSnippetsDir = GetDir('snippets')
  " }}}
" }}} 

" Editing {{{
  " call dein#add('editorconfig/editorconfig-vim', {'on_i': 1})
  " call dein#add('tpope/vim-speeddating')
  " call dein#add('thinca/vim-visualstar')
  call dein#add('tomtom/tcomment_vim')
  " call dein#add('terryma/vim-expand-region')
  call dein#add('terryma/vim-multiple-cursors')
  "call dein#add('godlygeek/tabular', {'on_cmd': 'Tabularize'})
  call dein#add('jiangmiao/auto-pairs')
  " call dein#add('justinmk/vim-sneak') "{{{
  "   let g:sneak#streak = 1
  " "}}}
" }}}

" Indents {{{
  call dein#add('nathanaelkane/vim-indent-guides') " {{{
    let g:indent_guides_start_level = 1
    let g:indent_guides_guide_size = 1
    let g:indent_guides_enable_on_vim_startup = 1
    " let g:indent_guides_color_change_percent = 3
  "}}}
" }}}

" Tags & GDB {{{
" run `:UpdateTypesFile` to highlight ctags symbols
  " call dein#add('vim-scripts/TagHighlight')
  " call dein#add('vim-scripts/gtags.vim')
  " call dein#add('vim-scripts/gdbmgr')
  " call dein#add('majutsushi/tagbar')
" }}}

" tmux {{{
  call dein#add('christoomey/vim-tmux-navigator') " {{{
    " Disable tmux navigator when zooming the Vim pane
    let g:tmux_navigator_disable_when_zoomed = 1
    let g:tmux_navigator_no_mappings = 1
    nnoremap <silent> <C-Left> :TmuxNavigateLeft<CR>
    nnoremap <silent> <C-Down> :TmuxNavigateDown<CR>
    nnoremap <silent> <C-Up> :TmuxNavigateUp<CR>
    nnoremap <silent> <C-Right> :TmuxNavigateRight<CR>
    "nnoremap <silent> <C-\> :TmuxNavigatePrevious<cr>
  " }}}
  call dein#add('melonmanchan/vim-tmux-resizer') " {{{
    let g:tmux_resizer_no_mappings = 1
    nnoremap <silent> <M-h> :TmuxResizeLeft<cr>
    nnoremap <silent> <M-j> :TmuxResizeDown<cr>
    nnoremap <silent> <M-k> :TmuxResizeUp<cr>
    nnoremap <silent> <M-l> :TmuxResizeRight<cr>
  " }}}
" }}}

" Misc {{{
  " call dein#add('xolox/vim-misc')
  " call dein#add('xolox/vim-session') "{{{
  "   let g:session_directory = GetCacheDir('sessions')
  "   let g:session_autoload = 'no'
  "   let g:session_autosave = 'no'
  " " }}}
  " call dein#add('mbbill/fencview', {'on_cmd': ['FencView','FencAutoDetect']}) " {{{
  " let g:fencview_autodetect = 0
  " let g:fencview_checklines = 100
  " let g:fencview_auto_patterns = '*'
  " }}}

  " call dein#add('kana/vim-vspec')
  " call dein#add('tpope/vim-scriptease', {'on_ft': 'vim'})
  call dein#add('jtratner/vim-flavored-markdown', {'on_ft': ['markdown','ghmarkdown']})
  if executable('instant-markdown-d')
    call dein#add('suan/vim-instant-markdown', {'on_ft': ['markdown','ghmarkdown']})
  endif
  call dein#add('guns/xterm-color-table.vim', {'on_cmd': 'XtermColorTable'})

  " call dein#add('vim-scripts/bufkill.vim')
  call dein#add('mhinz/vim-startify') "{{{
    let g:startify_session_dir = GetCacheDir('sessions')
    let g:startify_change_to_vcs_root = 1
    let g:startify_show_sessions = 1

    let g:startify_custom_header = [
        \ ' Neovim',
        \ '',
        \ ' <Space>ff   go to files',
        \ ' <Space>bb   select from buffers',
        \ ' <Space>ss   recursively search all files for matching text',
        \ ' <Space>fr   select from MRU',
        \ ' <Space>fm   go to anything (files, buffers, MRU, bookmarks)',
        \ ' <Space>jc   lists the references or definitions of a word',
        \ ' <Space>ft   toggle file explorer',
        \ ' <Space>tt   toggle tagbar',
        \ ' <Space>tl   toggle quickfix list',
        \ ' <Space>au   toggle undo tree',
        \ ' <Space>ag   gdb',
        \ '',
        \ ]
    let g:startify_custom_footer = [
        \ ]

    let g:startify_list_order = [
        \ ['   Sessions:'],
        \ 'sessions',
        \ ['   Bookmarks:'],
        \ 'bookmarks',
        \ ['   MRU:'],
        \ 'files',
        \ ['   MRU within this dir:'],
        \ 'dir',
        \ ]
  " }}}
  " " Ale {{{
     call dein#add('w0rp/ale')
     let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '✔︎']
     let g:ale_sign_error = '⨉'
     let g:ale_sign_warning = '⚠'
  " }}}
  "}}}

  call dein#add('vim-scripts/Conque-GDB', {'on_cmd': ['ConqueGdb','ConqueGdbTab',
       \ 'ConqueGdbVSplit','ConqueGdbSplit','ConqueTerm','ConqueTermTab',
       \ 'ConqueTermVSplit','ConqueTermSplit']}) "{{{
     let g:ConqueGdb_Leader = '\'
  "}}}

  call dein#add('yonchu/accelerated-smooth-scroll')
" }}}

" Navigation {{{
  " call dein#add('easymotion/vim-easymotion')
  " call dein#add('mileszs/ack.vim') " {{{
  "   if executable('ag')
  "     let g:ackprg = "ag --nogroup --column --smart-case --follow"
  "   endif
  " " }}}

  call dein#add('mbbill/undotree', {'on_cmd': 'UndotreeToggle'}) " {{{
     let g:undotree_WindowLayout = 2
     let g:undotree_SetFocusWhenToggle = 1
  " }}}

  " call dein#add('vim-scripts/EasyGrep', {'on_cmd': 'GrepOptions'}) " {{{
  "   let g:EasyGrepRecursive = 1
  "   let g:EasyGrepAllOptionsInExplorer = 1
  "   let g:EasyGrepCommand = 1
  " " }}}

  " call dein#add('ctrlpvim/ctrlp.vim') " {{{
  "   let g:ctrlp_clear_cache_on_exit = 1
  "   let g:ctrlp_max_height = 40
  "   let g:ctrlp_show_hidden = 1
  "   let g:ctrlp_follow_symlinks = 1
  "   let g:ctrlp_max_files = 20000
  "   let g:ctrlp_cache_dir = GetCacheDir('ctrlp')
  "   let g:ctrlp_reuse_window = 'startify'
  "   let g:ctrlp_extensions = ['funky']
  "   let g:ctrlp_custom_ignore = {
  "       \ 'dir': '\v[\/]\.(git|hg|svn|idea)$',
  "       \ 'file': '\v\.DS_Store$'
  "       \ }

  "   if executable('ag')
  "     let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  "   endif

  "   nmap \ [ctrlp]
  "   nnoremap [ctrlp] <Nop>

  "   nnoremap [ctrlp]t :CtrlPBufTag<CR>
  "   nnoremap [ctrlp]T :CtrlPTag<CR>
  "   nnoremap [ctrlp]l :CtrlPLine<CR>
  "   nnoremap [ctrlp]o :CtrlPFunky<CR>
  "   nnoremap [ctrlp]b :CtrlPBuffer<CR>
  "   let g:ctrlp_prompt_mappings = {
  "   \ 'AcceptSelection("e")': ['<c-t>'],
  "   \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
  "   \ }
  " " }}}
  
  " ./install --all so the interactive script doesn't block
  " you can check the other command line options  in the install file
  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0, 'rtp': '' }) 
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' }) " {{{
    let $FZF_DEFAULT_COMMAND = 'ag -g "" --one-device --skip-vcs-ignores --smart-case '
    function! s:update_fzf_colors()
      let rules =
      \ { 'fg':      [['Normal',       'fg']],
        \ 'bg':      [['Normal',       'bg']],
        \ 'hl':      [['Comment',      'fg']],
        \ 'fg+':     [['CursorColumn', 'fg'], ['Normal', 'fg']],
        \ 'bg+':     [['CursorColumn', 'bg']],
        \ 'hl+':     [['Statement',    'fg']],
        \ 'info':    [['PreProc',      'fg']],
        \ 'prompt':  [['Conditional',  'fg']],
        \ 'pointer': [['Exception',    'fg']],
        \ 'marker':  [['Keyword',      'fg']],
        \ 'spinner': [['Label',        'fg']],
        \ 'header':  [['Comment',      'fg']] }
      let cols = []
      for [name, pairs] in items(rules)
        for pair in pairs
          let code = synIDattr(synIDtrans(hlID(pair[0])), pair[1])
          if !empty(name) && code > 0
            call add(cols, name.':'.code)
            break
          endif
        endfor
      endfor
      let s:orig_fzf_default_opts = get(s:, 'orig_fzf_default_opts', $FZF_DEFAULT_OPTS)
      let $FZF_DEFAULT_OPTS = s:orig_fzf_default_opts .
            \ empty(cols) ? '' : (' --color='.join(cols, ','))
    endfunction

    augroup _fzf
      autocmd!
      autocmd VimEnter,ColorScheme * call s:update_fzf_colors()
    augroup END

    " Files + devicons <https://github.com/ryanoasis/vim-devicons/issues/106>
    " function! Fzf_dev()
    "   function! s:files()
    "     let files = split(system($FZF_DEFAULT_COMMAND), '\n')
    "     return s:prepend_icon(files)
    "   endfunction

    "   function! s:prepend_icon(candidates)
    "     let result = []
    "     for candidate in a:candidates
    "       let filename = fnamemodify(candidate, ':p:t')
    "       let icon = WebDevIconsGetFileTypeSymbol(filename, isdirectory(filename))
    "       call add(result, printf("%s %s", icon, candidate))
    "     endfor

    "     return result
    "   endfunction

    "   function! s:edit_file(item)
    "     let parts = split(a:item, ' ')
    "     let file_path = get(parts, 1, '')
    "     execute 'silent e' file_path
    "   endfunction
    "   let options = '-m -x +s' . fzf#vim#with_preview()['options']
    "   call fzf#run({
    "         \ 'source': <sid>files(),
    "         \ 'sink':   function('s:edit_file'),
    "         \ 'options': options,
    "         \ 'down':    '40%' })
    " endfunction

    "command! -bang -nargs=? -complete=dir Files
    "   \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    "fzf#vim#with_preview()['options']
      let g:fzf_files_options = 
        \ '--preview "highlight -O ansi -l {} 2> /dev/null ;or cat {} 2> /dev/null | head -'.&lines.'"'
  " "}}}

  call dein#add('majutsushi/tagbar', {'on_cmd': 'TagbarToggle'}) " {{{
    let g:tagbar_left = 1
    let g:tagbar_width = 30
    let g:tagbar_autoclose = 0
  " }}}
  " call dein#add('jeetsukumaran/vim-buffergator') " {{{
  "   let g:buffergator_suppress_keymaps = 1
  "   let g:buffergator_suppress_mru_switch_into_splits_keymaps = 1
  "   let g:buffergator_viewport_split_policy = "B"
  "   let g:buffergator_split_size = 10
  "   let g:buffergator_sort_regime = "mru"
  "   let g:buffergator_mru_cycle_loop = 0
  " "}}}
  " }}}
  "call dein#add('vim-ctrlspace/vim-ctrlspace') " {{{
  "  if executable("ag")
  "      let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
  "  endif
  "  let g:CtrlSpaceDefaultMappingKey = "<Leader>c"
    "let g:CtrlSpaceUseMouseAndArrowsInTerm = 1
  "  let g:CtrlSpaceUseTabline = 0
  " }}}
" }}}

" Python {{{
  "call dein#add('klen/python-mode', {'on_ft': 'python'}) " {{{
  "   let g:pymode_rope = 0
  " }}}
  "call dein#add('davidhalter/jedi-vim', {'on_ft': 'python'}) " {{{
  "   let g:jedi#popup_on_dot = 0
  " }}}
" }}}

" SCM {{{
  call dein#add('mhinz/vim-signify') " {{{
   let g:signify_update_on_bufenter = 0
   let g:signify_sign_add               = '+'
   let g:signify_sign_delete            = '_'
   let g:signify_sign_delete_first_line = '‾'
   let g:signify_sign_change            = '!'
   let g:signify_sign_changedelete      = g:signify_sign_change
  " }}}
  call dein#add('tpope/vim-fugitive') " {{{
     autocmd BufReadPost fugitive://* set bufhidden=delete
  " }}}
  "call dein#add('gregsexton/gitv', {'depends': 'vim-fugitive', 'on_cmd': 'Gitv'}) " {{{
  " }}}
  call dein#add('airblade/vim-gitgutter')
" }}}

  call dein#add('Shougo/denite.nvim') " {{{
    set rtp+=~/.config/nvim/plugins/repos/github.com/Shougo/denite.nvim/
    call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>', 'noremap')
    call denite#custom#map('insert', '<Up>', '<denite:move_to_previous_line>', 'noremap')
    let s:menus = {}
    call denite#custom#var('menu', 'menus', s:menus)
  " }}}
" }}}

" Building {{{
  " call dein#add('neomake/neomake')
" }}}
call dein#end()
if dein#check_install()
  call dein#install()
endif


" Autocommands {{{
 augroup nvim_edit
         autocmd!

         " go back to previous position of cursor if any
         autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe 'normal! g`"zvzz' |
            \ endif
  " quickfix window always on the bottom taking the whole horizontal space
     autocmd FileType qf wincmd J
 augroup end


  augroup nvim_map
    autocmd!

    " a.vim
    autocmd FileType c,cpp silent! unmap <Leader>ih
    autocmd FileType c,cpp silent! unmap <Leader>is
    autocmd FileType c,cpp silent! unmap <Leader>ihn
  augroup end


  augroup nvim_filetype
    autocmd!

    autocmd BufRead,BufNewFile *.md,*.markdown set filetype=ghmarkdown
    autocmd BufRead,BufNewFile *.editorconfig set filetype=dosini
  augroup end


  augroup nvim_format
    autocmd!

    autocmd FileType js,scss,css autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
    autocmd FileType css,scss nnoremap <silent> <SID>sort vi{:sort<CR>
    autocmd FileType css,scss nmap <LocalLeader>s <SID>sort
    autocmd FileType python autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType python setlocal foldmethod=indent
    autocmd FileType php autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType coffee autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType vim setlocal foldmethod=indent keywordprg=:help

    " vim-jsbeautify
    if dein#is_sourced('vim-jsbeautify')
      autocmd FileType javascript nnoremap <silent> <SID>js-beautify :call JsBeautify()<CR>
      autocmd FileType javascript nmap <LocalLeader>j <SID>js-beautify
    endif
  augroup end
" }}}

" functions {{{

  " " toggle quickfix list and location list
  " function! GetBufferList()
  "   redir =>buflist
  "   silent! ls
  "   redir END
  "   return buflist
  " endfunction

  " function! s:BufInfo()
  "   echo "\n----- buffer info -----"
  "   echo "bufnr('%')=" . bufnr('%') . " // current buffer number"
  "   echo "bufnr('$')=" . bufnr('$') . " // tail buffer number"
  "   echo "bufnr('#')=" . bufnr('#') . " // previous buffer number"
  "   for i in range(1, bufnr('$'))
  "     echo "bufexists(" . i . ")=" . bufexists(i)
  "     echon " buflisted(" . i . ")=" . buflisted(i)
  "     echon " bufloaded(" . i . ")=" . bufloaded(i)
  "     echon " bufname(" . i . ")=" . bufname(i)
  "   endfor
  "   echo "// bufexists(n)= buffer n exists"
  "   echo "// buflisted(n)= buffer n listed"
  "   echo "// bufloaded(n)= buffer n loaded"
  "   echo "// bufname(n)= buffer name"

  "   echo "\n----- window info -----"
  "   echo "winnr()="    . winnr()    . " // current window number"
  "   echo "winnr('$')=" . winnr('$') . " // tail window number"
  "   echo "winnr('#')=" . winnr('#') . " // previous window number"
  "   for i in range(1, winnr('$'))
  "     echo "winbufnr(" . i . ")=" . winbufnr(i) . " // window " . i . "'s buffer number"
  "   endfor

  "   echo "\n----- tab info -----"
  "   echo "tabpagenr()="    . tabpagenr()    . ' // current tab number'
  "   echo "tabpagenr('$')=" . tabpagenr('$') . ' // tail tab number'
  "   for i in range(1, tabpagenr('$'))
  "     echo 'tabpagebuflist(' . i . ')='
  "     echon tabpagebuflist(i)
  "     echon " // tab " . i . "'s buffer list"
  "   endfor
  "   for i in range(1, tabpagenr('$'))
  "     echo "tabpagewinnr(" . i . ")=" . tabpagewinnr(i)
  "     echon " tabpagewinnr(" . i . ", '$')=" . tabpagewinnr(i, '$')
  "     echon " tabpagewinnr(" . i . ", '#')=" . tabpagewinnr(i, '#')
  "   endfor
  "   echo "// tabpagewinnr(n)     = tab n's current window number"
  "   echo "// tabpagewinnr(n, '$')= tab n's tail window number"
  "   echo "// tabpagewinnr(n, '#')= tab n's previous window number"

  " endfunction
"}}}

" other useful functions {{{

  " function! <SID>EvalVimscript(begin, end) "{{{
  "   let lines = getline(a:begin, a:end)
  "   for line in lines
  "     execute line
  "   endfor
  " endfunction "}}}

  function! <SID>CloseWindowOrKillBuffer() "{{{
    " never bdelete a nerd tree
    if matchstr(expand("%"), 'NERD') ==# 'NERD'
      wincmd c
      return
    endif

    let number_of_windows_to_this_buffer =
        \ len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

    if number_of_windows_to_this_buffer > 1
      wincmd c
    else
      bdelete
    endif
  endfunction "}}}

  " highlight all instances of word under cursor, when idle.
  " useful when studying strange source code.
   function! <SID>AutoHighlightToggle() " {{{
     let @/ = ''
     if exists('#auto_highlight')
       autocmd! auto_highlight
       augroup! auto_highlight
       setlocal updatetime=4000
       echo 'Highlight current word: off'
       return 0
     else
       augroup auto_highlight
          autocmd!
          " 3match conflicts with airline
          autocmd CursorHold * silent! execute printf('2match WarningMsg /\<%s\>/', expand('<cword>'))
          augroup end
          setlocal updatetime=20
          " echo 'Highlight current word: on'
          return 1
     endif
   endfunction " }}}

  " maximize or restore current window in split structure
  " <http://vim.wikia.com/wiki/Maximize_window_and_return_to_previous_split_structure>
   function! <SID>MaximizeToggle()
     if exists('s:maximize_session')
       exec "source " . s:maximize_session
       call delete(s:maximize_session)
       unlet s:maximize_session
       let &hidden = s:maximize_hidden_save
       unlet s:maximize_hidden_save
     else
       let s:maximize_hidden_save = &hidden
       let s:maximize_session = tempname()
       set hidden
       exec "mksession! " . s:maximize_session
       only
     endif
   endfunction

  function! s:WriteCmdLine(str)
    execute "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
  endfunction

  function! <SID>VisualSelection(direction) range " {{{
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction ==# 'backward'
      execute "normal ?" . l:pattern . "^M"
    elseif a:direction ==# 'forward'
      execute "normal /" . l:pattern . "^M"
    elseif a:direction ==# 'file'
      call s:WriteCmdLine("vimgrep " . '/' . l:pattern . '/j' . ' %')
    elseif a:direction ==# 'directory'
      call s:WriteCmdLine("vimgrep " . '/' . l:pattern . '/j' . ' **/*')
    elseif a:direction ==# 'replace'
      call s:WriteCmdLine("%s" . '/' . l:pattern . '/' . l:pattern . '/g')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
  endfunction " }}}

  function! <SID>GetVisualSelection() " {{{
    let [s:lnum1, s:col1] = getpos("'<")[1:2]
    let [s:lnum2, s:col2] = getpos("'>")[1:2]
    let s:lines = getline(s:lnum1, s:lnum2)
    let s:lines[-1] = s:lines[-1][: s:col2 - (&selection == 'inclusive' ? 1 : 2)]
    let s:lines[0] = s:lines[0][s:col1 - 1:]
    return join(s:lines, ' ')
  endfunction " }}}

" }}}

" mappings {{{
  " maximize or restore current window in split structure
  noremap <C-w>O :call <SID>MaximizeToggle()<CR>
  " noremap <C-w><C-o> :call <SID>MaximizeToggle()<CR>

  " remap arrow keys
  nmap h :bprev<CR>
  nmap <S-Left> :bprev<CR>
  " :call LightLineBufferline()<CR>:call lightline#update()<CR>
  nmap l :bnext<CR>
  nmap <S-Right> :bnext<CR>
  " :call LightLineBufferline()<CR>:call lightline#update()<CR>
  "nnoremap <Up> :tabnext<CR>
  "nnoremap <Down> :tabprev<CR>

  " smash escape
  " inoremap jk <Esc>
  " inoremap kj <Esc>

  " change cursor position in insert mode
  " use S-BS instead of BS to delete in insert mode in some terminal
  " inoremap <C-h> <Left>
  " inoremap <C-l> <Right>

  " inoremap <C-u> <C-g>u<C-u>

  " sane regex {{{
    nnoremap / /\v
    vnoremap / /\v
    nnoremap ? ?\v
    vnoremap ? ?\v
    nnoremap :s/ :s/\v
  " }}}

  " command-line window {{{
    "nnoremap q: q:i
    "nnoremap q/ q/i
    "nnoremap q? q?i
  " }}}

  " folds {{{
    "nnoremap zr zr:echo &foldlevel<CR>
    "nnoremap zm zm:echo &foldlevel<CR>
    "nnoremap zR zR:echo &foldlevel<CR>
    "nnoremap zM zM:echo &foldlevel<CR>
  " }}}

  " screen line scroll {{{
    "nnoremap <silent> j gj
    "nnoremap <silent> k gk
  " }}}

  " auto center {{{
    "nnoremap <silent> n nzz
    "nnoremap <silent> N Nzz
    "nnoremap <silent> * *zz
    "nnoremap <silent> # #zz
    "nnoremap <silent> g* g*zz
    "nnoremap <silent> g# g#zz
    "nnoremap <silent> <C-o> <C-o>zz
    "nnoremap <silent> <C-i> <C-i>zz
  "}}}

  " reselect visual block after indent {{{
    "vnoremap < <gv
    "vnoremap > >gv
  "}}}

  " shortcuts for windows {{{
    " <http://stackoverflow.com/questions/9092982/mapping-c-j-to-something-in-vim>
    "let g:C_Ctrl_j = 'off'
    "let g:BASH_Ctrl_j = 'off'
    "nnoremap <C-h> <C-w>h
    "nnoremap <C-j> <C-w>j
    "nnoremap <C-k> <C-w>k
    "nnoremap <C-l> <C-w>l
  "}}}

  " make Y consistent with C and D. See :help Y.
  "nnoremap Y y$

  " hide annoying quit message
  "nnoremap <C-c> <C-c>:echo<CR>

  " window killer
  nnoremap <silent> Q :call <SID>CloseWindowOrKillBuffer()<CR>

  " vim menu
  let s:menus.vim = {
		\ 'description': 'Edit your nvim configuration'
		\ }
  let config_file_path = s:nvim_dir . g:path_separator . 'init.vim'
	let s:menus.vim.file_candidates = [
		\ [config_file_path, config_file_path],
		\ ]

  " Global denite menu
  noremap <silent> <SID>menu-global :Denite menu<CR>
  nmap <Leader>m <SID>menu-global

  "nnoremap <silent> <SID>key-mappings :<C-u>Unite -toggle -auto-resize -buffer-name=mappings mapping<CR>
  "nmap <Leader>? <SID>key-mappings

  "nnoremap <silent> <SID>last-buffer :buffer#<CR>
  "nmap <Leader><Tab> <SID>last-buffer

  " applications {{{

    "let g:lmap.a = { 'name' : '+applications' }

    nnoremap <silent> <SID>undotree-toggle :UndotreeToggle<CR>
    nmap <Leader>au <SID>undotree-toggle

    let s:menus.applications = {
    \ 'description' : 'Applications',
    \}
    let s:menus.applications.command_candidates = [
    \['▷ Undo Tree            (UndoTree)                                ⌘ <Leader>au', 'UndotreeToggle'],
    \] " Append ' --' after log to get commit info commit buffers
    nnoremap <silent> <SID>files-menu :Denite menu:files<CR>
    "nnoremap <SID>gdb :ConqueGdbVSplit<CR>
    "nmap <Leader>ag <SID>gdb

    "let g:lmap.a.s = { 'name' : '+shell' }

    " vimshell
    "nnoremap <SID>vimshell :VimShell -split<CR>
    "nmap <Leader>asv <SID>vimshell
    "nnoremap <SID>vimshell-node :VimShellInteractive node<CR>
    "nmap <Leader>asn <SID>vimshell-node
    "nnoremap <SID>vimshell-lua :VimShellInteractive lua<CR>
    "nmap <Leader>asl <SID>vimshell-lua
    "nnoremap <SID>vimshell-irb :VimShellInteractive irb<CR>
    "nmap <Leader>asi <SID>vimshell-irb
    "nnoremap <SID>vimshell-asp :VimShellInteractive python<CR>
    "nmap <Leader>asp <SID>vimshell-asp

  "}}}

  " buffers {{{

    "let g:lmap.b = { 'name' : '+buffers' }

    "nnoremap <silent> <SID>unite-quick-match-buffer :<C-u>Unite -toggle -auto-resize -quick-match buffer<CR>
    "nmap <Leader>bm <SID>unite-quick-match-buffer

    nnoremap <silent> <SID>buffers :Buffers<CR>
    nmap <Leader>bb <SID>buffers


    "let g:lmap.b.k = { 'name' : '+buffer-kill' }

    "let g:lmap.b.k['!'] = { 'name' : '+!' }
    "nmap <silent> <SID>buffer-kill-back <Plug>BufKillBack
    "nmap <Leader>bkb <SID>buffer-kill-back
    "nmap <silent> <SID>buffer-kill-forward <Plug>BufKillForward
    "nmap <Leader>bkf <SID>buffer-kill-forward
    "nmap <silent> <SID>buffer-kill-bun <Plug>BufKillBun
    "nmap <Leader>bku <SID>buffer-kill-bun
    "nmap <silent> <SID>buffer-kill-bangbun <Plug>BufKillBangBun
    "nmap <Leader>bk!u <SID>buffer-kill-bangbun
    "nmap <silent> <SID>buffer-kill-bd <Plug>BufKillBd
    "nmap <Leader>bkd <SID>buffer-kill-bd
    "nmap <silent> <SID>buffer-kill-bangbd <Plug>BufKillBangBd
    "nmap <Leader>bk!d <SID>buffer-kill-bangbd
    "nmap <silent> <SID>buffer-kill-bw <Plug>BufKillBw
    "nmap <Leader>bkw <SID>buffer-kill-bw
    "nmap <silent> <SID>buffer-kill-bangbw <Plug>BufKillBangBw
    "nmap <Leader>bk!w <SID>buffer-kill-bangbw
    "nmap <silent> <SID>buffer-kill-undo <Plug>BufKillUndo
    "nmap <Leader>bko <SID>buffer-kill-undo
    "nmap <silent> <SID>buffer-kill-alt <Plug>BufKillAlt
    "nmap <Leader>bka <SID>buffer-kill-alt

    "if dein#is_sourced('vim-buffergator') " {{{

      " buffergator
      " nnoremap <silent> <SID>buffer-preview :BuffergatorOpen<CR>
      " nmap <Leader>bp <SID>buffer-preview
      " nnoremap <silent> <M-b> :BuffergatorMruCyclePrev<CR>
      " nnoremap <silent> <M-S-b> :BuffergatorMruCycleNext<CR>
      " nnoremap <silent> [b :BuffergatorMruCyclePrev<CR>
      " nnoremap <silent> ]b :BuffergatorMruCycleNext<CR>

    "endif "}}}

  "}}}

  " debug {{{

    " let g:lmap.d = { 'name' : '+debug' }

    " nnoremap <silent> <SID>debug-start :exe ":profile start profile.log"<CR>:exe ":profile func *"<CR>:exe ":profile file *"<CR>
    " nmap <Leader>ds <SID>debug-start
    " nnoremap <silent> <SID>profile-pause :exe ":profile pause"<CR>
    " nmap <Leader>dp <SID>profile-pause
    " nnoremap <silent> <SID>profile-continue :exe ":profile continue"<CR>
    " nmap <Leader>dc <SID>profile-continue
    " nnoremap <silent> <SID>profile-quit :exe ":profile pause"<CR>:noautocmd qall!<CR>
    " nmap <Leader>dq <SID>profile-quit

  "}}}

  " files {{{

    "let g:lmap.f = { 'name' : '+files' }
    nnoremap <silent> <SID>files :Files<CR>
    nmap <Leader>ff <SID>files
    nnoremap <silent> <SID>history :History<CR>
    nmap <Leader>fr <SID>history
    nnoremap <silent> <SID>nerdtree-toggle :NERDTreeToggle<CR>
    nmap <Leader>ft <SID>nerdtree-toggle
    nnoremap <silent> <SID>nerdtree-find :NERDTreeFind<CR>
    nmap <Leader>fT <SID>nerdtree-find
    nnoremap <silent> <SID>git-files :GFiles<CR>
    nmap <Leader>fg <SID>git-files
    nnoremap <silent> <SID>git-modified :GFiles?<CR>
    nmap <Leader>fG <SID>git-modified

    let s:menus.files = {
    \ 'description' : 'File handling',
    \}
    let s:menus.files.command_candidates = [
    \['▷ Files              (FZF)                                ⌘ <Leader>ff', 'Files'],
    \['▷ History            (FZF)                                ⌘ <Leader>fr', 'History'],
    \['▷ NerdTree           (NerdTree)                           ⌘ <Leader>ft', 'NerdTreeToggle'],
    \['▷ NerdTree-Find      (NerdTree)                           ⌘ <Leader>fT', 'NERDTreeFind'],
    \['▷ Git-Files          (FZF)                                ⌘ <Leader>fg', 'GFiles'],
    \['▷ Modified-Files     (FZF)                                ⌘ <Leader>fG', 'GFiles?'],
    \] " Append ' --' after log to get commit info commit buffers
    nnoremap <silent> <SID>files-menu :Denite menu:files<CR>
    nmap <Leader>F <SID>files-menu
    " let g:lmap.f.v = { 'name' : '+vim' }

    " let g:lmap.f.a = ['A', 'alternate-file']
    " let g:lmap.f.s = ['w', 'save-buffer']
    " let g:lmap.f.v.d = ['e ~/.unvimrc', 'edit-dotfile']
    " let g:lmap.f.v.i = ['e $MYVIMRC', 'edit-init-file']
    "let g:lmap.f.v.R = ['source $MYVIMRC', 'reload-configuration']
  "}}}

  " " git/versions-control {{{

  "   let g:lmap.g = { 'name' : '+git/versions-control' }

    nnoremap <silent> <SID>git-blame :Gblame<CR>
    nmap <Leader>gb <SID>git-blame
    nnoremap <silent> <SID>git-commit :Gcommit<CR>
    nmap <Leader>gc <SID>git-commit
    nnoremap <silent> <SID>git-diff :Gvdiff<CR>
    nmap <Leader>gd <SID>git-diff
    nnoremap <silent> <SID>git-log :Glog<CR>
    nmap <Leader>gl <SID>git-log
    nnoremap <silent> <SID>git-push :Git push<CR>
    nmap <Leader>gp <SID>git-push
    nnoremap <silent> <SID>git-remove :Gremove<CR>
    nmap <Leader>gr <SID>git-remove
    nnoremap <silent> <SID>git-status :Gstatus<CR>
    nmap <Leader>gs <SID>git-status
    nnoremap <silent> <SID>git-commits :Commits<CR>
    nmap <Leader>gv <SID>git-commits
    nnoremap <silent> <SID>git-commits-buffer :BCommits<CR>
    nmap <Leader>gV <SID>git-commits-buffer
    "nnoremap <silent> <SID>git-v! :Gitv!<CR>
    "nmap <Leader>gV <SID>git-v!
    nnoremap <silent> <SID>git-write :Gwrite<CR>
    nmap <Leader>ga <SID>git-write

    let s:menus.git = {
		\ 'description': 'Git Commands'
		\ }
    "\[' git status', 'Gstatus'],
    let s:menus.git.command_candidates = [
    \['▷ Git Diff                (Fugitive)                      ⌘ <Leader>gd', 'Gvdiff'],
    \['▷ Git Commit              (Fugitive)                      ⌘ <Leader>gc', 'Gcommit'],
    \['▷ Git Stage/Add           (Fugitive)                      ⌘ <Leader>ga', 'Gwrite'],
    \['▷ Git Checkout            (Fugitive)                                   ', 'Gread'],
    \['▷ Git Remove              (Fugitive)                      ⌘ <Leader>gr', 'Gremove'], 
    \['▷ Git Cd                  (Fugitive)                                   ', 'Gcd'],
    \['▷ Git Push                (Fugitive)                      ⌘ <Leader>gp', 'exe "Git! push " input("remote/branch: ")'],
    \['▷ Git Pull                (Fugitive)                                   ', 'exe "Git! pull " input("remote/branch: ")'],
    \['▷ Git Pull Rebase         (Fugitive)                                   ', 'exe "Git! pull --rebase " input("branch: ")'],
    \['▷ Git Checkout Branch     (Fugitive)                                   ', 'exe "Git! checkout " input("branch: ")'],
    \['▷ Git Fetch               (Fugitive)                                   ', 'Gfetch'],
    \['▷ Git Merge               (Fugitive)                                   ', 'Gmerge'],
    \['▷ Git Browse              (Fugitive)                                   ', 'Gbrowse'],
    \['▷ Git Head                (Fugitive)                                   ', 'Gedit HEAD^'],
    \['▷ Git Parent              (Fugitive)                                   ', 'edit %:h'],
    \['▷ Git Log Commit Buffers  (Fugitive)                                   ', 'Glog --'],
    \['▷ Git Log Current File    (Fugitive)                                   ', 'Glog -- %'],
    \['▷ Git Log Last n Commits  (Fugitive)                                   ', 'exe "Glog -" input("num: ")'],
    \['▷ Git Log First n Commits (Fugitive)                                   ', 'exe "Glog --reverse -" input("num: ")'],
    \['▷ Git Log Until Date      (Fugitive)                                   ', 'exe "Glog --until=" input("day: ")'],
    \['▷ Git Log Grep Commits    (Fugitive)                                   ', 'exe "Glog --grep= " input("string: ")'],
    \['▷ Git Log Pickaxe         (Fugitive)                                   ', 'exe "Glog -S" input("string: ")'],
    \['▷ Git Index               (Fugitive)                                   ', 'exe "Gedit " input("branchname\:filename: ")'],
    \['▷ Git Mv                  (Fugitive)                                   ', 'exe "Gmove " input("destination: ")'],
    \['▷ Git Grep                (Fugitive)                                   ', 'exe "Ggrep " input("string: ")'],
    \['▷ Git Prompt              (Fugitive)                                   ', 'exe "Git! " input("command: ")'],
    \] " Append ' --' after log to get commit info commit buffers

    nnoremap <silent> <SID>git-menu :Denite menu:git<CR>
    nmap <Leader>G <SID>git-menu

  " search/symbol {{{

    " let g:lmap.s = { 'name' : '+search/symbol' }

    " search current word in current directory
    nnoremap <SID>grep-word-in-directory :call fzf#vim#lines(expand('<cword>'))<CR>
    nmap <Leader>sd <SID>grep-word-in-directory

    " search current word in current file
    nnoremap <SID>grep-word-in-file :call fzf#vim#buffer_lines(expand('<cword>'))<CR>
    nmap <Leader>sf <SID>grep-word-in-file

    " search the selected text in current directory
    vnoremap <SID>grep-in-directory :call fzf#vim#lines(<SID>GetVisualSelection())<CR>
    vmap <Leader>sd <SID>grep-in-directory

    " search the selected text in current file
    vnoremap <SID>grep-in-file :call fzf#vim#buffer_lines(<SID>GetVisualSelection())<CR>
    vmap <Leader>sf <SID>grep-in-file

    " let g:lmap.s.g = { 'name' : '+grep' }

    " " search specific content in current directory
    " nnoremap <SID>grep-in-directory :vimgrep /\<<C-r>=expand("<cword>")<CR>\>/j **/*<Left><Left><Left><Left><Left><Left><Left><Left><Left>
    " nmap <Leader>sgd <SID>grep-in-directory

    " let g:lmap.s.g.e = ['GrepOptions', 'easygrep-options']

    " " search specific content in current file
    " nnoremap <SID>grep-in-file :vimgrep /\<<C-r>=expand("<cword>")<CR>\>/j <C-r>%
    " nmap <Leader>sgf <SID>grep-in-file

    " " repeat last search
    " nnoremap <SID>grep-last :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>
    " nmap <Leader>sl <SID>grep-last

    " " replace specific content
    nnoremap <SID>replace-in-file :%s/\<<C-r>=expand("<cword>")<CR>\>/<C-r>=expand("<cword>")<CR>/g<Left><Left>
    nmap <Leader>sr <SID>replace-in-file

    " replace the selected text
    vnoremap <SID>replace-in-file :call <SID>VisualSelection('replace')<CR>
    vmap <Leader>sr <SID>replace-in-file

    nmap <Leader>sR :%s///g<Left><Left><Left>
    " if dein#is_sourced('denite.nvim')
    "   nnoremap <silent> <SID>denite-cursorword :<C-u>DeniteCursorWord -no-quit -auto-resize -buffer-name=search grep:.<CR>
    "   nmap <Leader>ss <SID>denite-cursorword
    " "elseif dein#is_sourced('unite.vim')
    " ""  nnoremap <silent> <SID>unite-cursorword :<C-u>UniteWithCursorWord -no-quit -toggle -auto-resize -buffer-name=search grep:.<CR>
    " ""  nmap <Leader>ss <SID>unite-cursorword
    " endif

    " let g:lmap.s.t = { 'name' : '+tags' }

    if dein#is_sourced('asyncrun.vim')
       nnoremap <SID>create-tags :AsyncRun! gtags;cscope -Rbq;ctags -R<CR>
       nnoremap <SID>remove-tags :AsyncRun! rm tags;rm cscope.in.out;rm cscope.out;rm cscope.po.out;rm GTAGS;rm GRTAGS;rm GPATH<CR>
       nmap <Leader>sta <SID>create-tags
       nmap <Leader>stv <SID>remove-tags
    endif

    " " cscope
    " if has("cscope")
    "   "if g:navim_settings.cscopeprg ==# 'gtags-cscope'  " global

    "     " go to definition
    "     nnoremap <SID>gtags-definition :Gtags -d <C-r>=expand("<cword>")<CR>
    "     "vnoremap <SID>gtags-definition <Esc>:execute 'Gtags ' . <SID>GetVisualSelection()
    "     nmap <Leader>std <SID>gtags-definition

    "     " locate strings
    "     nnoremap [cscope]e :Gtags -g <C-r>=expand("<cword>")<CR>
    "     "nnoremap <SID>gtags-strings :execute 'Gtags -g ' . expand('<cword>')
    "     "vnoremap <SID>gtags-strings <Esc>:execute 'Gtags -g ' . <SID>GetVisualSelection()
    "     nmap <Leader>ste <SID>gtags-strings

    "     " get a list of tags in specified files
    "     nnoremap <SID>gtags-files :Gtags -f %<CR>
    "     "vnoremap <SID>gtags-files <Esc>:execute 'Gtags -f ' . <SID>GetVisualSelection()
    "     nmap <Leader>stf <SID>gtags-files

    "     " go to definition or reference
    "     nnoremap <SID>gtags-cursor :GtagsCursor<CR>
    "     nmap <Leader>stg <SID>gtags-cursor

    "     " find reference
    "     nnoremap <SID>gtags-reference :Gtags -r <C-r>=expand("<cword>")<CR>
    "     "vnoremap <SID>gtags-reference <Esc>:execute 'Gtags -r ' . <SID>GetVisualSelection()
    "     nmap <Leader>str <SID>gtags-reference

    "     " locate symbols which are not defined in `GTAGS`
    "     nnoremap <SID>gtags-symbols :Gtags -s <C-r>=expand("<cword>")<CR>
    "     "vnoremap <SID>gtags-symbols <Esc>:execute 'Gtags -s ' . <SID>GetVisualSelection()
    "     nmap <Leader>sts <SID>gtags-symbols

    "   " elseif g:navim_settings.cscopeprg ==# 'cscope'  " cscope

    "   "   " calls: find all calls to the function name under cursor
    "   "   nnoremap <SID>cscope-calls :cscope find c <C-r>=expand("<cword>")<CR>
    "   "   "vnoremap <SID>cscope-calls <Esc>:execute 'cscope find c ' . <SID>GetVisualSelection()
    "   "   nmap <Leader>stc <SID>cscope-calls

    "   "   " called: find functions that function under cursor calls
    "   "   nnoremap <SID>cscope-called :cscope find d <C-r>=expand("<cword>")<CR>
    "   "   "vnoremap <SID>cscope-called <Esc>:execute 'cscope find d ' . <SID>GetVisualSelection()
    "   "   nmap <Leader>std <SID>cscope-called

    "   "   " egrep:  egrep search for the word under cursor
    "   "   nnoremap <SID>cscope-egrep :cscope find e <C-r>=expand("<cword>")<CR>
    "   "   "vnoremap <SID>cscope-egrep <Esc>:execute 'cscope find e ' . <SID>GetVisualSelection()
    "   "   nmap <Leader>ste <SID>cscope-egrep

    "   "   " file: open the filename under cursor
    "   "   nnoremap <SID>cscope-file :cscope find f <C-r>=expand("<cword>")<CR>
    "   "   "vnoremap <SID>cscope-file <Esc>:execute 'cscope find f ' . <SID>GetVisualSelection()
    "   "   nmap <Leader>stf <SID>cscope-file

    "   "   " global: find global definition(s) of the token under cursor
    "   "   nnoremap <SID>cscope-global :cscope find g <C-r>=expand("<cword>")<CR>
    "   "   "vnoremap <SID>cscope-global <Esc>:execute 'cscope find g ' . <SID>GetVisualSelection()
    "   "   nmap <Leader>stg <SID>cscope-global

    "   "   " symbol: find all references to the token under cursor
    "   "   nnoremap <SID>cscope-symbol :cscope find s <C-r>=expand("<cword>")<CR>
    "   "   "vnoremap <SID>cscope-symbol <Esc>:execute 'cscope find s ' . <SID>GetVisualSelection()
    "   "   nmap <Leader>sts <SID>cscope-symbol

    "   "   " text: find all instances of the text under cursor
    "   "   nnoremap <SID>cscope-text :cscope find t <C-r>=expand("<cword>")<CR>
    "   "   "vnoremap <SID>cscope-text <Esc>:execute 'cscope find t ' . <SID>GetVisualSelection()
    "   "   nmap <Leader>stt <SID>cscope-text

    " includes: find files that include the filename under cursor
    "nnoremap <SID>cscope-includes :cscope find i <C-r>=expand("<cfile>")<CR>
    "   "   "vnoremap <SID>cscope-includes <Esc>:execute 'cscope find i ' . <SID>GetVisualSelection()
    "   "   "nnoremap <SID>cscope-includes :execute 'cscope find i ' . expand('<cword>')
    "   "   "nnoremap <SID>cscope-includes :cscope find i ^<C-r>=expand("<cfile>")<CR>$
    "   "   "nnoremap <SID>cscope-includes :tab split<CR>:execute "cscope find i " . expand("<cword>")
    "   "   "nnoremap <SID>cscope-includes :tab split<CR>:execute "cscope find i ^" . expand("<cword>") . "$"
    "   "   nmap <Leader>sti <SID>cscope-includes

    "   " endif
    " endif

  "}}}

  " toggles {{{

    " let g:lmap.t = { 'name' : '+toggles' }

    " let g:lmap.t.h = { 'name' : '+highlight' }

    " "nnoremap <SID>automatic-symbol-highlight :if <SID>AutoHighlightToggle()<Bar>set hlsearch<Bar>endif<CR>
     nnoremap <SID>automatic-symbol-highlight :call <SID>AutoHighlightToggle()<CR>
     nmap <Leader>th <SID>automatic-symbol-highlight
     call <SID>AutoHighlightToggle()

    " nmap <silent> <SID>indent-guides <Plug>IndentGuidesToggle
    " nmap <Leader>ti <SID>indent-guides

     nnoremap <silent> <SID>tabbar :TagbarToggle<CR>
     nmap <Leader>tt <SID>tabbar

    " nmap <silent> <SID>golden-ratio <Plug>ToggleGoldenViewAutoResize
    " nmap <Leader>tg <SID>golden-ratio

    " "let g:lmap.t.j = ['call <SID>JustTextToggle()', 'just-text']

    " nnoremap <silent> <SID>just-text :call <SID>JustTextToggle()<CR>
    " nmap <Leader>tj <SID>just-text

    " nnoremap <silent> <SID>location :call <SID>ListToggle("Location List", 'l')<CR>
    " nmap <Leader>tl <SID>location

    " nnoremap <silent> <SID>line-numbers :set number!<CR>
    " nmap <Leader>tn <SID>line-numbers

    " nnoremap <silent> <SID>quickfix :call <SID>ListToggle("Quickfix List", 'c')<CR>
    " nmap <Leader>tq <SID>quickfix

    " nnoremap <silent> <SID>whitespace :set list!<CR>
    " nmap <Leader>tw <SID>whitespace

  "}}}

  " " jump {{{

      " Jump to line in current buffer
      nnoremap <silent> <SID>jump-line :BLines<CR>
      nmap <Leader>jl <SID>jump-line

      " Jump to line in all open buffers
      nnoremap <silent> <SID>jump-buffer-line :Lines <CR>
      nmap <Leader>jd <SID>jump-buffer-line

  "     nnoremap <silent> <SID>denite-outline :<C-u>Denite -auto-resize -buffer-name=outline outline<CR>
  "     nmap <Leader>jo <SID>denite-outline
  "   " elseif dein#is_sourced('unite.vim')
  "   "   nnoremap <silent> <SID>unite-line :<C-u>Unite -toggle -auto-resize -buffer-name=line line<CR>
  "   "   nmap <Leader>jl <SID>unite-line

  "   "   nnoremap <silent> <SID>unite-outline :<C-u>Unite -toggle -auto-resize -buffer-name=outline outline<CR>
  "   "   nmap <Leader>jo <SID>unite-outline
  "   endif

  "   if dein#is_sourced('unite-gtags') "{{{

  "     " lists the references or definitions of a word
  "     " `global --from-here=<location of cursor> -qe <word on cursor>`
  "     nnoremap <silent> <SID>unite-gtags-context :execute 'Unite gtags/context'<CR>
  "     nmap <Leader>jc <SID>unite-gtags-context

  "     " lists definitions of a word
  "     " `global -qd -e <pattern>`
  "     nnoremap <silent> <SID>unite-gtags-def :execute 'Unite gtags/def:'.expand('<cword>')<CR>
  "     nmap <Leader>jd <SID>unite-gtags-def
  "     vnoremap <silent> <SID>unite-gtags-def <ESC>:execute 'Unite gtags/def:'.<SID>GetVisualSelection()<CR>
  "     vmap <Leader>jd <SID>unite-gtags-def

  "     " lists current file's tokens in GTAGS
  "     " `global -f`
  "     nnoremap <silent> <SID>unite-gtags-file :execute 'Unite gtags/file'<CR>
  "     nmap <Leader>jf <SID>unite-gtags-file

  "     " lists grep result of a word
  "     " `global -qg -e <pattern>`
  "     nnoremap <silent> <SID>unite-gtags-grep :execute 'Unite gtags/grep:'.expand('<cword>')<CR>
  "     nmap <Leader>jg <SID>unite-gtags-grep
  "     vnoremap <silent> <SID>unite-gtags-grep <ESC>:execute 'Unite gtags/grep:'.<SID>GetVisualSelection()<CR>
  "     vmap <Leader>jg <SID>unite-gtags-grep

  "     " lists all tokens in GTAGS
  "     " `global -c`
  "     nnoremap <silent> <SID>unite-gtags-completion :execute 'Unite gtags/completion'<CR>
  "     nmap <Leader>jm <SID>unite-gtags-completion

  "     " lists references of a word
  "     " `global -qrs -e <pattern>`
  "     nnoremap <silent> <SID>unite-gtags-ref :execute 'Unite gtags/ref:'.expand('<cword>')<CR>
  "     nmap <Leader>jr <SID>unite-gtags-ref
  "     vnoremap <silent> <SID>unite-gtags-ref <ESC>:execute 'Unite gtags/ref:'.<SID>GetVisualSelection()<CR>
  "     vmap <Leader>jr <SID>unite-gtags-ref

  "   endif "}}}

  "   if dein#is_sourced('unite-airline_themes') && dein#is_sourced('vim-airline')
  "     nnoremap <silent> <SID>unite-airline-themes :<C-u>Unite -toggle -winheight=10 -auto-preview -buffer-name=airline_themes airline_themes<CR>
  "     nmap <Leader>ja <SID>unite-airline-themes
  "   endif

  "   if dein#is_sourced('denite.nvim')
  "     nnoremap <silent> <SID>denite-help :<C-u>Denite -auto-resize -buffer-name=help help<CR>
  "     nmap <Leader>jh <SID>denite-help
  "   " elseif dein#is_sourced('unite-help')
  "   "   nnoremap <silent> <SID>unite-help :<C-u>Unite -toggle -auto-resize -buffer-name=help help<CR>
  "   "   nmap <Leader>jh <SID>unite-help
  "   endif

  "   if dein#is_sourced('denite.nvim')
  "     nnoremap <silent> <SID>denite-colorschemes :<C-u>Denite -winheight=10 -auto-preview -buffer-name=colorschemes colorscheme<CR>
  "     nmap <Leader>js <SID>denite-colorschemes
  "   " elseif dein#is_sourced('unite-colorscheme')
  "   "   nnoremap <silent> <SID>unite-colorschemes :<C-u>Unite -toggle -winheight=10 -auto-preview -buffer-name=colorschemes colorscheme<CR>
  "   "   nmap <Leader>js <SID>unite-colorschemes
  "   endif

  "   if dein#is_sourced('junkfile.vim')
  "     nnoremap <silent> <SID>unite-junkfile :<C-u>Unite -toggle -auto-resize -buffer-name=junk junkfile junkfile/new<CR>
  "     nmap <Leader>jj <SID>unite-junkfile
  "   endif

  "   if dein#is_sourced('unite-tag')
  "     nnoremap <silent> <SID>unite-tag :<C-u>Unite -toggle -auto-resize -buffer-name=tag tag tag/file<CR>
  "     nmap <Leader>jt <SID>unite-tag
  "   endif

  "   if dein#is_sourced('neoyank.vim')
  "     if dein#is_sourced('denite.nvim')
  "       nnoremap <silent> <SID>unite-history :<C-u>Denite -auto-resize -buffer-name=yanks history/yank<CR>
  "       nmap <Leader>jy <SID>unite-history
  "     " elseif dein#is_sourced('unite.vim')
  "     "   nnoremap <silent> <SID>unite-history :<C-u>Unite -toggle -auto-resize -buffer-name=yanks history/yank<CR>
  "     "   nmap <Leader>jy <SID>unite-history
  "     endif
  "   endif

  " "}}}

  " " windows {{{

  "   let g:lmap.w = { 'name' : '+windows' }

  "   nnoremap <silent> <SID>balance-windows <C-w>=
  "   nmap <Leader>w= <SID>balance-windows

  "   let g:lmap.w.a = ['vert sba', 'show-all-buffer']

  "   let g:lmap.w.e = { 'name' : '+sessions' }

  "   let g:lmap.w.e.s = ['SaveSession!', 'save-session']

  "   let g:lmap.w.e.r = ['OpenSession!', 'restore-session']

  "   let g:lmap.w.p = { 'name' : '+postion' }

  "   " cecutil
  "   map <SID>save-cursor-position <Plug>SaveWinPosn
  "   map <Leader>wps <SID>save-cursor-position

  "   map <SID>restore-cursor-position <Plug>RestoreWinPosn
  "   map <Leader>wpr <SID>restore-cursor-position

  "   let g:lmap.w.r = { 'name' : '+resize' }

  "   " increase the window size by a factor
  "   nnoremap <silent> <SID>increase-width :exe "vertical resize " . (winwidth(0) * 5/4)<CR>
  "   nmap <Leader>wr= <SID>increase-width

  "   " decrease the window size by a factor
  "   nnoremap <silent> <SID>decrease-width :exe "vertical resize " . (winwidth(0) * 3/4)<CR>
  "   nmap <Leader>wr- <SID>decrease-width

  "   nnoremap <SID>maximize-toggle :call <SID>MaximizeToggle()<CR>
  "   nmap <Leader>wrm <SID>maximize-toggle

  "   let g:lmap.w.s = ['split', 'split-window-below']

  "   let g:lmap.w.t = { 'name' : '+tabs' }

  "   let g:lmap.w.v = ['vsplit', 'split-window-right']

  "   " tab
  "   nnoremap <SID>tab-new :tabnew<CR>
  "   nmap <Leader>wtn <SID>tab-new

  "   nnoremap <SID>tab-close :tabclose<CR>
  "   nmap <Leader>wtc <SID>tab-close

  "   " tabular
  "   "nmap <Leader>a& :Tabularize /&<CR>
  "   "vmap <Leader>a& :Tabularize /&<CR>
  "   "nmap <Leader>a= :Tabularize /=<CR>
  "   "vmap <Leader>a= :Tabularize /=<CR>
  "   "nmap <Leader>a: :Tabularize /:<CR>
  "   "vmap <Leader>a: :Tabularize /:<CR>
  "   "nmap <Leader>a:: :Tabularize /:\zs<CR>
  "   "vmap <Leader>a:: :Tabularize /:\zs<CR>
  "   "nmap <Leader>a, :Tabularize /,<CR>
  "   "vmap <Leader>a, :Tabularize /,<CR>
  "   "nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
  "   "vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

  " "}}}

"   " text {{{

"     let g:lmap.x = { 'name' : '+text' }

"     let g:lmap.x.l = { 'name' : '+lines' }

"     nnoremap <SID>format-file :call <SID>Preserve("normal gg=G")<CR>
"     nmap <Leader>xf <SID>format-file

"     " repeatable copy and paste. fake the behavior in windows
"     nnoremap <SID>repeatable-paste viw"zp
"     nmap <Leader>xp <SID>repeatable-paste

"     nnoremap <SID>repeatable-copy "zyiw
"     nmap <Leader>xy <SID>repeatable-copy

"     vnoremap <SID>repeatable-paste "zp
"     vmap <Leader>xp <SID>repeatable-paste

"     vnoremap <SID>repeatable-copy "zy
"     vmap <Leader>xy <SID>repeatable-copy

"     " reselect last paste
"     nnoremap <expr> <SID>reselect-last-paste '`[' . strpart(getregtype(), 0, 1) . '`]'
"     nmap <Leader>xr <SID>reselect-last-paste

"     " formatting

"     " remove the windows ^M when the encodings gets messed up
"     noremap <SID>remove-windows-endl mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm
"     nmap <Leader>xm <SID>remove-windows-endl

"     nnoremap <SID>remove-trailing-whitespace :call NavimStripTrailingWhitespace()<CR>
"     nmap <Leader>xt <SID>remove-trailing-whitespace

"     " eval vimscript by line or visual selection
"     nnoremap <silent> <SID>eval-vimscript :call <SID>EvalVimscript(line('.'), line('.'))<CR>
"     nmap <Leader>xe <SID>eval-vimscript
"     vnoremap <silent> <SID>eval-vimscript :call <SID>EvalVimscript(line('v'), line('.'))<CR>
"     vmap <Leader>xe <SID>eval-vimscript

"     vnoremap <SID>sort-lines :sort<CR>
"     vmap <Leader>xls <SID>sort-lines

"   "}}}

"   function! s:my_displayfunc()
"     let g:leaderGuide#displayname =
"         \ substitute(g:leaderGuide#displayname, '\c<CR>$', '', '')
"     let g:leaderGuide#displayname =
"         \ substitute(g:leaderGuide#displayname, '^<Plug>', '', '')
"     let g:leaderGuide#displayname =
"         \ substitute(g:leaderGuide#displayname, '^<SID>', '', '')
"   endfunction
"   let g:leaderGuide_displayfunc = [function("s:my_displayfunc")]

"   let g:topdict = {}
"   let g:topdict[' '] = g:lmap
"   let g:topdict[' ']['name'] = '<Leader>'
"   let g:topdict[','] = g:llmap
"   let g:topdict[',']['name'] = '<LocalLeader>'
"   call leaderGuide#register_prefix_descriptions("", "g:topdict")

"   nnoremap <silent><nowait> <Leader> :<C-u>LeaderGuide '<Space>'<CR>
"   vnoremap <silent><nowait> <Leader> :<C-u>LeaderGuideVisual '<Space>'<CR>
"   map <Leader>. <Plug>leaderguide-global

"   nnoremap <silent><nowait> <LocalLeader> :<C-u>LeaderGuide  ','<CR>
"   vnoremap <silent><nowait> <LocalLeader> :<C-u>LeaderGuideVisual  ','<CR>
"   map <LocalLeader>. <Plug>leaderguide-buffer

" "}}}


" Search and Replace

" Relative numbering
  function! NumberToggle()
    if(&relativenumber == 1)
        set nornu
        set number
    else
        set rnu
    endif
  endfunc

" Toggle between normal and relative numbering.
  nnoremap <leader>r :call NumberToggle()<cr>
" nnoremap Q @q   " Use Q to execute default register.
