set runtimepath=$XDG_DATA_HOME/nvim/,$XDG_CONFIG_HOME/nvim,$VIMRUNTIME,$XDG_CONFIG_HOME/nvim/after

if !has('nvim')
  set viminfo+='1000,n$XDG_DATA_HOME/nvim/viminfo
else
  " Do nothing here to use the neovim default
  " or do soemething like:
  set viminfo+=n~/.shada
endif

let mapleader = "-"
let maplocalleader= ","

autocmd FileType tex setlocal nosmarttab

let g:python3_host_prog = "~/.local/share/nvim/nvim-env/bin/python3"

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.config/nvim/plugged')

" TODO maybe interesting: telescope,treesitter,nvim-dap(-ui)
" TODO switch to packer? https://discord.com/channels/694667287214555158/820378480990224424/951195309848023102

" Declare the list of plugins.
Plug 'tpope/vim-surround'
Plug 'numToStr/Comment.nvim'
Plug 'andymass/vim-matchup'
" Plug 'tpope/vim-commentary'
" Plug 'luochen1990/rainbow'

Plug 'L3MON4D3/LuaSnip'
" Plug '~/coding/luaSnip_fork'

Plug 'lervag/vimtex'
Plug 'gisraptor/vim-lilypond-integrator'
" Plug 'arcticicestudio/nord-vim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'itchyny/lightline.vim'
Plug 'josa42/nvim-lightline-lsp'

Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
Plug 'nvimdev/lspsaga.nvim'
Plug 'simrat39/rust-tools.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-calc'
Plug 'f3fora/cmp-spell'
Plug 'micangl/cmp-vimtex'
" Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'saadparwaiz1/cmp_luasnip'
" Plug '/home/lukas/coding/cmp_luasnip'
Plug 'hrsh7th/nvim-cmp'

" Plug 'HE7086/cyp-vim-syntax'
Plug 'junegunn/vim-easy-align'

Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

" Plug 'vigoux/LanguageTool.nvim'
" Plug 'rhysd/vim-grammarous'

" Plug 'mfussenegger/nvim-dap'
" Plug 'leoluz/nvim-dap-go'
" Plug 'rcarriga/nvim-dap-ui'

Plug 'jakewvincent/mkdnflow.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'teal-language/vim-teal'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" We're going to define single-letter keymaps, so don't try to define them
" in the terminal window.  The debugger CLI should continue accepting text commands.
function! NvimGdbNoTKeymaps()
  tnoremap <silent> <buffer> <esc> <c-\><c-n>
endfunction

" let g:nord_cursor_line_number_background = 1
" let g:nord_bold_vertical_split_line = 1
" let g:nord_uniform_diff_background = 1
" let g:nord_bold = 1
" let g:nord_italic = 1
" let g:nord_italic_comments = 1
" let g:nord_underline = 1
" colorscheme nord
set termguicolors
luafile ~/.config/nvim/plugins/catppuccin.lua
colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
" highlight Normal guibg=000000
" highlight NvimTreeNormal guibg=000000
syntax enable

" " Disabled by default, and only enabled for .scm files.
let g:rainbow_active = 0
" autocmd BufRead,BufNewFile *.scm :RainbowToggleOn

let g:tex_flavor = "latex"

" set foldmethod=manual
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=1
set foldlevel=99
" set nofoldenable

" easy align
source ~/.config/nvim/plugins/e_align.vim

" vimtex
source ~/.config/nvim/plugins/vimtex.vim

" comment
luafile ~/.config/nvim/plugins/comment.lua

" snippets
" source ~/.config/nvim/plugins/ultisnips.vim
luafile ~/.config/nvim/plugins/luasnip.lua
" luafile ~/.config/nvim/plugins/luasnip_dbg.lua
luafile ~/.config/nvim/plugins/treesitter.lua

" languagetool/grammarous
" source ~/.config/nvim/plugins/language.vim

" dap
" luafile ~/.config/nvim/plugins/dap.lua

" lsp
luafile ~/.config/nvim/plugins/lsp.lua
luafile ~/.config/nvim/plugins/lsp_signature.lua
luafile ~/.config/nvim/plugins/lspsaga.lua
set scl=yes
source ~/.config/nvim/plugins/cmp.vim

" lightline
source ~/.config/nvim/plugins/lightline.vim

luafile ~/.config/nvim/plugins/nvim_tree.lua
nnoremap <C-n> :NvimTreeToggle<CR>

luafile ~/.config/nvim/plugins/mkdnflow.lua

" split navigation
nnoremap <silent> <A-Up> :wincmd k<CR>
nnoremap <silent> <A-Down> :wincmd j<CR>
nnoremap <silent> <A-Left> :wincmd h<CR>
nnoremap <silent> <A-Right> :wincmd l<CR>
nnoremap <silent> <A-k> :wincmd k<CR>
nnoremap <silent> <A-j> :wincmd j<CR>
nnoremap <silent> <A-h> :wincmd h<CR>
nnoremap <silent> <A-l> :wincmd l<CR>

nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-h> :tabprevious<CR>
nnoremap <C-l> :tabnext<CR>

set mouse=a

" go one visible line up, not one real line
" nnoremap <buffer> k gk
" nnoremap <buffer> j gj

hi Conceal ctermbg=none

set cmdheight=2 "more space at the bottom

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" encoding
set encoding=utf-8

if has("vms")
  set nobackup       " do not keep a backup file, use versions instead
else
  set backup         " keep a backup file (restore to previous version)
  set backupext=.bak "set file extension
  set backupdir=$XDG_DATA_HOME/nvim/backup//
  if has('persistent_undo')
    set undofile      " keep an undo file (undo changes after closing)
    set undodir=$XDG_DATA_HOME/nvim/undo//
  endif
endif

set directory=$XDG_DATA_HOME/nvim/swap//
set viewdir=$XDG_DATA_HOME/nvim/view//

"increase the buffer for the indention scripts (at least for tex)
let g:tex_max_scan_line = 1000

" inoremap <C-@> <C-n>
" inoremap <C-b> <C-p>

" set completeopt=menuone,longest

" When After typing a bracket return, it will set place the cursor correctly
inoremap {<CR> {<CR>}<Esc>O
inoremap (<CR> (<CR>)<Esc>O
inoremap [<CR> [<CR>]<Esc>O

set hlsearch "highlight matches while searching

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!
  " For all text files set 'text width' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

set viewoptions=cursor,folds

autocmd BufWinLeave ?* mkview
autocmd BufWinEnter ?* silent! loadview

"wrapping
set whichwrap="" "no wrapping when the cursor is at the end of a line to go to the beginning of the next one

"spell checking and completion
" set complete=.,i,kspell,s
set nospell
set spelllang=de_20,en_gb "neue Rechtschreibung

"set thesaurus+=~/.local/share/nvim/thesaurus/de.txt

" linebreak if word and line is too long
set wrap
set linebreak

augroup colors
	" highlight clear SpellBad
	" highlight SpellBad ctermbg=Red
	" highlight clear SpellCap
	" highlight SpellCap cterm=bold
	" highlight clear SpellRare
	" highlight SpellRare cterm=underline
	" highlight clear SpellLocal
	" highlight SpellLocal cterm=italic

	" folding
	"default colors for the foldcolumn
	" highlight clear FoldColumn
	" highlight clear SignColumn
	" highlight clear CursorLine
	" highlight CursorLine ctermbg=242 guibg=Grey40
	" highlight clear Pmenu
	" highlight pmenu cterm=bold ctermfg=0 ctermbg=3

	" set cursorline
	" set cursorcolumn
augroup END

"line numbering
set number relativenumber
set numberwidth=3
"indention
set autoindent shiftwidth=4 tabstop=4

augroup textwidth
	autocmd!
	autocmd BufRead,BufNewFile *.md setlocal textwidth=80
augroup end

autocmd BufRead,BufNewFile *.camkes set ft=camkes " TODO remove

" begin to scrol 5 lines from the bottom/top
set scrolloff=5

noremap <silent>m //e<CR>
noremap <silent>M //<CR>

augroup gitSpaceInd "indent with spaces for these directories (git repo most often)
	autocmd!
	autocmd BufNewFile,BufRead /media/daten/education/studium/semester-02/LA/LA_git-group/* set expandtab
	autocmd BufNewFile,BufRead /media/daten/education/studium/semester-05/praktikum/* set expandtab
	autocmd BufNewFile,BufRead /media/daten/education/studium/semester-06/cpp/lukas.h_tasks/* set expandtab
	autocmd BufNewFile,BufRead /media/daten/coding/xournalpp/* set expandtab
	autocmd BufNewFile,BufRead /media/daten/programme/cluttex_fork/* set expandtab shiftwidth=2 tabstop=2
	autocmd FileType lilypond set expandtab shiftwidth=2 tabstop=2
	autocmd BufNewFile,BufRead /media/daten/education/studium/semester-09_m1/networkCoding/* set noexpandtab shiftwidth=8 tabstop=8
	autocmd BufNewFile,BufRead /media/daten/education/studium/semester-09_m1/networkCoding/project/reportOverleaf/* set expandtab shiftwidth=4 tabstop=4
	autocmd BufNewFile,BufRead /media/daten/education/studium/semester-09_m1/networkCoding/project/presentationOverleaf/* set expandtab shiftwidth=4 tabstop=4
	autocmd BufNewFile,BufRead /media/daten/education/studium/semester-09_m1/networkCoding/project/git/paper/* set expandtab shiftwidth=4 tabstop=4
	" autocmd BufNewFile,BufRead /media/daten/education/studium/semester-09_m1/networkCoding/project/git/tumposter/* set expandtab shiftwidth=4 tabstop=4
	autocmd BufNewFile,BufRead /media/daten/education/studium/semester-09_m1/networkCoding/project/git/paper/* let $VIMTEX_OUTPUT_DIRECTORY = 'build/paper.tex/paper'
augroup end

augroup spellStuff " set spell specific stuff
	autocmd!
	autocmd BufNewFile,BufRead /home/lukas/Nextcloud/BA/thesis/* set spelllang=en_us spellfile=/home/lukas/Nextcloud/BA/thesis/spell.add spell
augroup end

au BufRead,BufNewFile /home/lukas/studium/numprog/cheatsheet.tex syntax sync fromstart

set foldcolumn=2 "width of the column where folds are displayed


" deactivate cursor keys for testing
nnoremap <UP> <NOP>
nnoremap <DOWN> <NOP>
nnoremap <LEFT> <NOP>
nnoremap <RIGHT> <NOP>

" pasting with <leader>p avoids overwriting the pastebuffer
xmap <leader>p "_dp
xmap <leader>P "_dP

"showing tabs etc
set list
set listchars=tab:>·,eol:¬,trail:- "TODO which character for trailing?

""""""""""""""""
"" STATUSLINE ""
""""""""""""""""
set noshowmode
""""""""""""""""""""
"" STATUSLINE END ""
""""""""""""""""""""

" enable arrow keys when completion menu pops up too
"inoremap <Down> <Esc>ji
"inoremap <Up> <Esc>ki

"TODO map :%s/\s\+$//e to some binding to strip trailing whitespaces

"clipboad
set clipboard=unnamedplus "use the systemclipboard by default
" autocmd VimLeave * call system("xclip -o | xclip -selection c") "store the clipboard when exiting

let tex_no_error=1 "don't show errors in tex files, since vim does not know all packages

set colorcolumn=80
highlight ColorColumn ctermbg=0 ctermfg=7

" edit xournal files (see https://vi.stackexchange.com/a/10390/854)
augroup gzip_local2
    autocmd!
    autocmd BufReadPre,FileReadPre     *.xopp setlocal bin
    autocmd BufReadPost,FileReadPost   *.xopp call gzip#read("gzip -dn -S .xopp")
    autocmd BufWritePost,FileWritePost *.xopp call gzip#write("gzip -S .xopp")
    autocmd FileAppendPre              *.xopp call gzip#appre("gzip -dn -S .xopp")
    autocmd FileAppendPost             *.xopp call gzip#write("gzip -S .xopp")
augroup END
