let g:lightline = {
	\ 'colorscheme': 'catppuccin',
	\	'active' : {
		    \ 'left': [ [ 'mode', 'paste' ],
		    \           [ 'readonly', 'filename', 'modified' ], [ 'charvaluehex' ],
			\         ],
		    \ 'right': [ [ 'lineinfo' ],
		    \            [ 'percent' ],
		    \            [ 'fileformat', 'fileencoding', 'filetype', 'spell' ] ]
			\ },
	\	'inactive' : {
		    \ 'left': [ [ 'filename' ] ],
		    \ 'right': [ [ 'lineinfo' ],
		    \            [ 'percent' ] ] 
			\ },
	\ 'tabline' : {
		    \ 'left': [ [ 'tabs' ] ],
		    \ 'right': [ [ 'close' ] ]
			\ },
	\ 'lightline.component' : {
		    \ 'mode': '%{lightline#mode()}',
		    \ 'absolutepath': '%F',
		    \ 'relativepath': '%f',
		    \ 'filename': '%t',
		    \ 'modified': '%M',
		    \ 'bufnum': '%n',
		    \ 'paste': '%{&paste?"PASTE":""}',
		    \ 'readonly': '%R',
		    \ 'charvalue': '%b',
		    \ 'charvaluehex': '%B',
		    \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
		    \ 'fileformat': '%{&ff}',
		    \ 'filetype': '%{&ft!=#""?&ft:"no ft"}',
		    \ 'percent': '%3p%%',
		    \ 'percentwin': '%P',
		    \ 'spell': '%{&spell?&spelllang:""}',
		    \ 'lineinfo': '%3l:%-2c',
		    \ 'line': '%l',
		    \ 'column': '%c',
		    \ 'close': '%999X X ',
		    \ 'winnr': '%{winnr()}' 
			\ },
	\ 'component_function' : {
	  \   'lsp_warnings': 'lightline#lsp#warnings',
	  \   'lsp_errors': 'lightline#lsp#errors',
	  \   'lsp_info': 'lightline#lsp#info',
	  \   'lsp_hints': 'lightline#lsp#hints',
	  \   'lsp_ok': 'lightline#lsp#ok',
	  \   'status': 'lightline#lsp#status',
	  \ },
	\ }
