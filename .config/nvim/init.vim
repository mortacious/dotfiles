set shell=/bin/bash


" Leader key {{{
  let maplocalleader = ','
  let mapleader = ' '
  let g:mapleader = ' '
"}}}

" functions {{{
  function! Preserve(command) " {{{
	    " preparation: save last search and cursor position
	    let _s = @/
	    let l = line(".")
  endfunction " }}}

  function! GetDir(suffix) " {{{
    return resolve(expand(s:nvim_dir . g:path_separator . a:suffix))
  endfunction "}}}

  function! GetCacheDir(suffix) " {{{
    return resolve(expand(s:cache_dir . g:path_separator . a:suffix))
  endfunction "}}}

  function! StripTrailingWhitespace() " {{{
    call Preserve("%s/\\s\\+$//e")
  endfunction "}}}

  function! s:EnsureExists(path) " {{{
    if !isdirectory(expand(a:path))
      call mkdir(expand(a:path))
    endif
  endfunction "}}}

  function! s:AddTags(path) " {{{
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

    function! s:filtered_lightline_call(funcname)
        if bufname('%') == '__CS__'
            return
        endif
        execute 'call lightline#' . a:funcname . '()'
    endfunction

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
    "call dein#add('arakashic/chromatica.nvim', {'on_ft': ['c', 'cpp', 'cc', 'h', 'hh', 'hpp']}) " {{{
    "    let g:chromatica#enable_at_startup = 1
    "    let g:chromatica#dotclangfile_search_path = 'build'
    "    let g:chromatica#responsive_mode = 1 " auto update syntax on buffer change instead on return to normal mode
    "    "let g:chromatica#libclang_path='/usr/lib/libclang.so'
    " }}}

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

"C/C++ Stuff {{{
    call dein#add('vim-scripts/a.vim', {'on_ft': ['c', 'cpp', 'cc', 'h', 'hh', 'hpp']})
    call dein#add('vim-scripts/c.vim', {'on_ft': ['c', 'cpp', 'cc', 'h', 'hh', 'hpp']}) " {{{
        "<http://stackoverflow.com/questions/736701/class-function-names-highlighting-in-vim>
        "highlight class and function names
        syn match    cCustomParen    "(" contains=cParen,cCppParen
        syn match    cCustomFunc     "\w\+\s*(" contains=cCustomParen
        syn match    cCustomScope    "::"
        syn match    cCustomClass    "\w\+\s*::" contains=cCustomScope

        hi def link cCustomFunc  Function
        hi def link cCustomClass CTagsClass
    " }}}
    call dein#add('vim-scripts/STL-improved', {'on_ft': ['c', 'cpp', 'cc', 'h', 'hh', 'hpp']})
    call dein#add('octol/vim-cpp-enhanced-highlight', {'on_ft': ['c', 'cpp', 'cc', 'h', 'hh', 'hpp']}) " {{{
        let g:cpp_class_scope_highlight = 1
        let g:cpp_member_variable_highlight = 1
        let g:cpp_class_decl_highlight = 1
        let g:cpp_experimental_template_highlight = 1
        let g:cpp_concepts_highlight = 1
    " }}}
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
    let g:indent_guides_exclude_filetypes = ['help', 'startify', 'man', 'rogue', 'fzf']

    " let g:indent_guides_color_change_percent = 3
  " }}}
" }}}

" Tags & GDB {{{
  " run `:UpdateTypesFile` to highlight ctags symbols
  call dein#add('vim-scripts/TagHighlight')
  call dein#add('vim-scripts/gtags.vim')
  " call dein#add('vim-scripts/gdbmgr')
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
  call dein#add('mbbill/fencview', {'on_cmd': ['FencView','FencAutoDetect']}) " {{{
   let g:fencview_autodetect = 0
   let g:fencview_checklines = 100
   let g:fencview_auto_patterns = '*'
  " }}}
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

  "call dein#add('vim-scripts/Conque-GDB', {'on_cmd': ['ConqueGdb','ConqueGdbTab',
  ""     \ 'ConqueGdbVSplit','ConqueGdbSplit','ConqueTerm','ConqueTermTab',
  ""     \ 'ConqueTermVSplit','ConqueTermSplit']}) "{{{
  ""   let g:ConqueGdb_Leader = '\'
  " }}}

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

  call dein#add('kshenoy/vim-signature') " {{{
    let g:SignatureMarkerTextHL = 'Typedef'
    let g:SignatureMap = {
      \ 'Leader'             :  "m",
      \ 'PlaceNextMark'      :  "m,",
      \ 'ToggleMarkAtLine'   :  "m.",
      \ 'PurgeMarksAtLine'   :  "m-",
      \ 'DeleteMark'         :  "dm",
      \ 'PurgeMarks'         :  "m<Space>",
      \ 'PurgeMarkers'       :  "m<BS>",
      \ 'GotoNextLineAlpha'  :  "",
      \ 'GotoPrevLineAlpha'  :  "",
      \ 'GotoNextSpotAlpha'  :  "",
      \ 'GotoPrevSpotAlpha'  :  "",
      \ 'GotoNextLineByPos'  :  "]'",
      \ 'GotoPrevLineByPos'  :  "['",
      \ 'GotoNextSpotByPos'  :  "]`",
      \ 'GotoPrevSpotByPos'  :  "[`",
      \ 'GotoNextMarker'     :  "[+",
      \ 'GotoPrevMarker'     :  "[-",
      \ 'GotoNextMarkerAny'  :  "]=",
      \ 'GotoPrevMarkerAny'  :  "[=",
      \ 'ListLocalMarks'     :  "m/",
      \ 'ListLocalMarkers'   :  "m?"
      \ }
  " }}}
  
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

  call dein#add('sunaku/vim-shortcut', { 'depends': 'fzf.vim' }) " {{{

  " }}}

  call dein#add('majutsushi/tagbar', {'on_cmd': 'TagbarToggle'}) " {{{
    let g:tagbar_left = 1
    let g:tagbar_width = 30
    let g:tagbar_autoclose = 0

    let g:tagbar_status_func = 'TagbarStatusFunc'

    function! TagbarStatusFunc(current, sort, fname, ...) abort
      let g:lightline.fname = a:fname
      return lightline#statusline(0)
    endfunction
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
  call dein#add('airblade/vim-gitgutter')
" }}}

call dein#end()
if dein#check_install()
  call dein#install()
endif

runtime plugin/shortcut.vim

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
  augroup end
" }}}

" useful functions {{{

  function! <SID>CloseWindowOrKillBuffer() " {{{
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
    " <http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle>
    function! AutoHighlightToggle()
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
    endfunction

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


  " Relative numbering
  function! NumberToggle() " {{{
    if(&relativenumber == 1)
        set nornu
        set number
    else
        set rnu
    endif
  endfunction " }}}

" }}}

" mappings {{{
  " Map shortcuts
  Shortcut show shortcut menu and run chosen shortcut
      \ noremap <silent> <Leader><Leader> :Shortcuts<Return>

  " maximize or restore current window in split structure
  Shortcut maximize or restore current window in split structure 
      \ noremap <C-w>O :call <SID>MaximizeToggle()<CR>
  " noremap <C-w><C-o> :call <SID>MaximizeToggle()<CR>

  " remap arrow keys
  "nmap h :bprev<CR>
  Shortcut switch to previous buffer 
      \ nmap <S-Left> :bprev<CR>
  " :call LightLineBufferline()<CR>:call lightline#update()<CR>
  "nmap l :bnext<CR>
  Shortcut switch to next buffer 
      \ nmap <S-Right> :bnext<CR>
  " :call LightLineBufferline()<CR>:call lightline#update()<CR>

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

  " make Y consistent with C and D. See :help Y.
  "nnoremap Y y$

  " hide annoying quit message
  "nnoremap <C-c> <C-c>:echo<CR>

  " window killer
    Shortcut close window or kill buffer 
        \ nnoremap <silent> Q :call <SID>CloseWindowOrKillBuffer()<CR>

  " applications {{{
    Shortcut (undotree) toggle undotree 
        \ nnoremap <silent>  <Leader>au :UndotreeToggle<CR>
  " }}}

  " buffers {{{
    Shortcut (fzf) open buffer
        \ nnoremap <silent> <Leader>bb :Buffers<CR>

  " }}}

  " files {{{
    Shortcut (fzf) open file in/under working directory 
      \ nnoremap <silent> <Leader>ff :Files<CR>

    Shortcut (fzf) open file relative to current file
        \ nnoremap <silent> <Leader>fF :execute 'Files' expand('%:h')<CR>

    Shortcut (fzf) open file from history
        \ nnoremap <silent> <Leader>fr :History<CR>

    Shortcut (nerdtree) open/close nerdtree in working directory
        \ nnoremap <silent> <Leader>ft :NERDTreeToggle<CR>

    Shortcut (nerdtree) open nerdtree in current buffer's directory
        \ nnoremap <silent> <Leader>fT :NERDTreeFind<CR>

    Shortcut (fzf) open file in git repository
        \ nnoremap <silent> <Leader>fg :GFiles<CR>

    Shortcut (fzf) open file in git status
        \ nnoremap <silent> <Leader>fG :GFiles?<CR>

  " }}}

  " " git/versions-control {{{

    Shortcut (fugitive) git blame 
        \ nnoremap <silent> <Leader>gb :Gblame<CR>

    Shortcut (fugitive) git commit 
        \ nnoremap <silent> <Leader>gc :Gcommit<CR>

    Shortcut (fugitive) git diff 
        \ nnoremap <silent> <Leader>gd :Gvdiff<CR>

    Shortcut (fugitive) git log 
        \ nnoremap <silent> <Leader>gl :Glog<CR>

    Shortcut (fugitive) git push 
        \ nnoremap <silent> <Leader>gp :Git push<CR>

    Shortcut (fugitive) git remove 
        \ nnoremap <silent> <Leader>gr :Gremove<CR>

    Shortcut (fugitive) git status 
        \ nnoremap <silent> <Leader>gs :Gstatus<CR>

    Shortcut (fzf) git commit history 
        \ nnoremap <silent> <Leader>gv :Commits<CR>

    Shortcut (fzf) git commit history of current buffer 
        \ nnoremap <silent> <Leader>gV :BCommits<CR>

    Shortcut (fugitive) git commit/write 
        \ nnoremap <silent> <Leader>ga :Gwrite<CR>

  " search/symbol {{{

    " search current word in current directory
    Shortcut (fzf) search word under cursor in current directory 
        \ nnoremap <silent> <Leader>sd :call fzf#vim#lines(expand('<cword>'))<CR>

    " search current word in current file
    Shortcut (fzf) search word under cursor in current file 
        \ nnoremap <silent> <Leader>sf :call fzf#vim#buffer_lines(expand('<cword>'))<CR>

    " search the selected text in current directory
    Shortcut (fzf) search selected text in current directory 
        \ vnoremap <silent> <Leader>sd :call fzf#vim#lines(<SID>GetVisualSelection())<CR>

    " search the selected text in current file
    Shortcut (fzf) search selected text in current file 
        \ vnoremap <silent> <Leader>sf :call fzf#vim#buffer_lines(<SID>GetVisualSelection())<CR>

    Shortcut (fzf) go to line in any file in directory
        \ nnoremap <silent> <Space>'F :Ag<Return>


    " " search specific content in current directory
    " nnoremap <SID>grep-in-directory :vimgrep /\<<C-r>=expand("<cword>")<CR>\>/j **/*<Left><Left><Left><Left><Left><Left><Left><Left><Left>
    " nmap <Leader>sgd <SID>grep-in-directory

    " " search specific content in current file
    " nnoremap <SID>grep-in-file :vimgrep /\<<C-r>=expand("<cword>")<CR>\>/j <C-r>%
    " nmap <Leader>sgf <SID>grep-in-file

    " " repeat last search
    " nnoremap <SID>grep-last :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>
    " nmap <Leader>sl <SID>grep-last

    "  replace specific content
    Shortcut search and replace word under cursor 
        \ nnoremap <Leader>sr :%s/\<<C-r>=expand("<cword>")<CR>\>/<C-r>=expand("<cword>")<CR>/g<Left><Left>

    " replace the selected text
    Shortcut search and replace selected text 
        \ vnoremap <silent> <Leader>sr :call <SID>VisualSelection('replace')<CR>

    Shortcut search and replace 
        \ nnoremap <Leader>sR :%s///g<Left><Left><Left>

    if dein#is_sourced('asyncrun.vim')
      Shortcut create ctags 
          \ nnoremap <silent> <Leader>sta :AsyncRun! gtags;cscope -Rbq;ctags -R<CR>
      Shortcut remove ctags 
          \ nnoremap <silent> <Leader>stv :AsyncRun! rm tags;rm cscope.in.out;rm cscope.out;rm cscope.po.out;rm GTAGS;rm GRTAGS;rm GPATH<CR>
    endif

    " cscope
    if has("cscope")
        " go to definition
        "vnoremap <SID>gtags-definition <Esc>:execute 'Gtags ' . <SID>GetVisualSelection()
        Shortcut go to definition 
            \ nnoremap <Leader>std :Gtags -d <C-r>=expand("<cword>")<CR>

        " locate strings
        "nnoremap <SID>gtags-strings :execute 'Gtags -g ' . expand('<cword>')
        "vnoremap <SID>gtags-strings <Esc>:execute 'Gtags -g ' . <SID>GetVisualSelection()
        Shortcut locate word under cursor
            \ noremap <Leader>ste :Gtags -g <C-r>=expand("<cword>")<CR>

        " get a list of tags in specified files
        "vnoremap <SID>gtags-files <Esc>:execute 'Gtags -f ' . <SID>GetVisualSelection()
        Shortcut get list of tags in specified files 
            \ nnoremap <Leader>stf :Gtags -f %<CR>

        " go to definition or reference
        Shortcut go to definition of reference 
            \ nnoremap <Leader>stg :GtagsCursor<CR>

        " find reference
        "vnoremap <SID>gtags-reference <Esc>:execute 'Gtags -r ' . <SID>GetVisualSelection()
        Shortcut find reference 
            \ nnoremap <Leader>str :Gtags -r <C-r>=expand("<cword>")<CR>

        " locate symbols which are not defined in `GTAGS`
        "vnoremap <SID>gtags-symbols <Esc>:execute 'Gtags -s ' . <SID>GetVisualSelection()
        Shortcut locate symbols which are not defined in GTAGS 
            \ nnoremap <Leader>sts :Gtags -s <C-r>=expand("<cword>")<CR>
    endif

  "}}}

  " toggles {{{
    Shortcut toggle automatic symbol highlight 
        \ nnoremap <silent> <Leader>th :call AutoHighlightToggle()<CR>
    call AutoHighlightToggle() " enable default autohighlighting

    Shortcut (indent-guides) toggle indent guides 
        \ nnoremap <silent> <Leader>ti <Plug>IndentGuidesToggle

    Shortcut (tagbar) toggle tagbar 
        \ nnoremap <silent> <Leader>tt :TagbarToggle<CR>


    " Toggle between normal and relative numbering.
    Shortcut toggle between relative and normal numbering 
        \ nnoremap <leader>tr :call NumberToggle()<CR>

    
    Shortcut toggle chromatica syntax highlighting
        \ nnoremap <leader>tc :ChromaticaToggle<CR>

    " nnoremap <silent> <SID>quickfix :call <SID>ListToggle("Quickfix List", 'c')<CR>
    " nmap <Leader>tq <SID>quickfix

    " nnoremap <silent> <SID>whitespace :set list!<CR>
    " nmap <Leader>tw <SID>whitespace

  "}}}

  "  jump {{{

      " Jump to line in current buffer
      Shortcut (fzf) jump to line in current buffer 
          \ nnoremap <silent> <Leader>jl :BLines<CR>

      " Jump to line in all open buffers
      Shortcut (fzf) jump to line in all open buffers 
          \ nnoremap <silent> <Leader>jd :Lines <CR>

      Shortcut (fzf) jump to ctag in all open buffers
          \ nnoremap <silent> <Leader>jT :Tags<CR>

      Shortcut (fzf) jump to ctag in current buffer
          \ nnoremap <silent> <Leader>jt :BTags<CR>

      Shortcut (fzf) jump to mark in current buffer
          \ nnoremap <silent> <Leader>jm :Marks<CR>

      Shortcut (fzf) open file in filesystem
          \ nnoremap <Space>oF :Locate<Space>

  " history {{{
      Shortcut (fzf) repeat command from history
          \ nnoremap <silent> <Space>:. :History:<Return>

      Shortcut (fzf) repeat search from history
            \ nnoremap <silent> <Space>:/ :History/<Return>
  " }}}

  " windows {{{

    Shortcut balance windows 
        \ nnoremap <silent> <Leader>w= <C-w>=

    Shortcut toggle maximize 
        \ nnoremap <Leader>wm :call <SID>MaximizeToggle()<CR>

  " }}}

  " text {{{
    Shortcut format file 
        \ nnoremap <Leader>xf :call <SID>Preserve("normal gg=G")<CR>

    " repeatable copy and paste. fake the behavior in windows
    Shortcut repeatable paste 
        \ nnoremap <Leader>xp viw"zp

    Shortcut repeatable copy 
        \ nnoremap <Leader>xy "zyiw

    Shortcut repeatable paste (visual mode)
        \ vnoremap <Leader>xp "zp

    Shortcut repeatable copy (visual mode) 
        \ vnoremap <Leader>xy "zy

    " reselect last paste
    Shortcut reselect last paste 
        \ nnoremap <expr> <Leader>xr '`[' . strpart(getregtype(), 0, 1) . '`]'

    " formatting
    Shortcut strip trailing whitespaces 
        \ nnoremap <Leader>xt :call StripTrailingWhitespace()<CR>

    Shortcut sort selected lines 
        \ vnoremap <Leader>xls :sort<CR>

  " }}}
