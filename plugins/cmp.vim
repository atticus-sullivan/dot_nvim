set completeopt=menuone,noselect

" let g:compe.documentation = v:true
" let g:compe.source.path = v:true
" let g:compe.source.calc = v:true

highlight link CompeDocumentation NormalFloat

lua <<EOF

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Setup nvim-cmp.
local cmp = require'cmp'
local luasnip = require("luasnip")
luasnip.config.setup({store_selection_keys="<Tab>"})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}),
		['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i','c'}),
		['<C-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		['<CR>'] = cmp.mapping.confirm({ select = false }),

		['<C-J>'] = cmp.mapping(function(fallback)
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			else
			fallback()
			end
			end, {"i", "s"}),

		['<C-K>'] = cmp.mapping(function(fallback)
			if luasnip.choice_active() then
				luasnip.change_choice(-1)
			else
				fallback()
			end
			end, {"i", "s"}),


		["<Tab>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
				-- elseif cmp.visible() then
				-- cmp.select_next_item()
				-- elseif has_words_before() then
				-- cmp.complete()
			else
				fallback()
			end
			end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
				-- elseif cmp.visible() then
				-- cmp.select_prev_item()
			else
				fallback()
			end
			end, { "i", "s" }),
	},
	sources = cmp.config.sources(
		{
			{name = 'nvim_lsp'},
			{name = 'nvim_lsp_signature_help'},
			{name = 'vimtex'},
			{name = 'luasnip', option = {show_autosnippets=true}},
			{name = 'spell', option = {keep_all_entries = false, enable_in_context = function() return true end,}},
			{name = 'path'},
			{name = 'calc'},
			{name = 'buffer'},
		}
	),
})
vim.opt.spell = true
vim.opt.spelllang = { 'en_gb' }
EOF
