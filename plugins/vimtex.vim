
" vimtex start
let g:vimtex_view_method = "zathura"

" compiler options
let g:vimtex_compiler_latexmk = {
    \ 'backend' : 'nvim',
    \ 'background' : 1,
    \ 'build_dir' : '',
    \ 'callback' : 0,
    \ 'continuous' : 0,
    \ 'executable' : 'latexmk',
    \ 'hooks' : [],
    \ 'options' : [
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}
let g:vimtex_compiler_method='generic'
" Makefile based workflow
let g:vimtex_compiler_generic = {
      \ 'command': 'make',
      \}

call vimtex#imaps#add_map({
      \ 'lhs' : '<cr>',
      \ 'rhs' : "\r\\item ",
      \ 'leader'  : ';',
      \ 'wrapper' : 'vimtex#imaps#wrap_environment',
      \ 'context' : [
      \   'itemize',
      \   'enumerate',
      \ ],
      \})

" detect latex file
let g:tex_flavor = "latex"

" default input when changing an env with cse
let g:vimtex_env_change_autofill = 1

let g:vimtex_imaps_leader=";"

" set conceallevel=1
" set concealcursor=nc
" set lcs=conceal:$
" :syntax match Entity "$" conceal cchar=$
let g:vimtex_quickfix_mode=0

    let g:vimtex_syntax_conceal = {
          \ 'accents': 1,
          \ 'cites': 1,
          \ 'fancy': 1,
          \ 'greek': 1,
          \ 'math_bounds': 0,
          \ 'math_delimiters': 1,
          \ 'math_fracs': 1,
          \ 'math_super_sub': 1,
          \ 'math_symbols': 1,
          \ 'sections': 1,
          \ 'styles': 0,
          \}
let g:vimtex_indent_on_ampersands = 0


" let g:vimtex_fold_enabled=1
" let  g:vimtex_fold_types = {
" 	   \ 'preamble' : {'enabled' : 1},
" 	   \ 'envs' : {
" 	   \   'blacklist' : ['figure', 'table'],
" 	   \ },
" 	   \}

" let g:vimtex_complete_ref = { 'custom_patterns' : ['\\figref{'] }
" let g:vimtex_complete_ref = {}
" let g:vimtex_complete_ref.custom_patterns = ['\\[esftESFT]ref\*\?{[^}]*$']

let g:vimtex_complete_ref = {
			\ 'custom_patterns': ['\\ref\*\?{[^}]*$']
			\ }
let $VIMTEX_OUTPUT_DIRECTORY = 'tex-aux'

" spelling
let g:vimtex_syntax_nospell_comments = 1
