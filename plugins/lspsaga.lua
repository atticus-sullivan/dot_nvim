local lspsaga = require 'lspsaga'
lspsaga.setup {
	ui = {
		title = true,
		border = "single",
		kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
		devicon = true,
		code_action = '',
	},
	preview = {
		lines_above = 0,
		lines_below = 10,
	},
	scroll_preview = {
		scroll_down = "<C-f>",
		scroll_up = "<C-b>",
	},
	request_timeout = 2000,
	finder = {
		max_height = 0.5,
		min_width = 30,
		force_max_height = false,
		keys = {
			shuttle = '[w',
			toggle_or_open = '<CR>',
			vsplit = 'v',
			split = 's',
			tabe = 't',
			tabnew = 'r',
			quit = { 'q', '<ESC>' },
			close = '<ESC>',
		},
	},
	definition = {
		edit = "i",
		vsplit = "v",
		split = "s",
		tabe = "t",
		quit = "q",
	},
	code_action = {
		num_shortcut = true,
		show_server_name = false,
		extend_gitsigns = true,
		keys = {
			-- string | table type
			quit = "q",
			exec = "<CR>",
		},
	},
	lightbulb = {
		enable = true,
		enable_in_insert = true,
		sign = true,
		sign_priority = 40,
		virtual_text = false,
	},
	hover = {
		max_width = 0.6,
	},
	diagnostic = {
		on_insert = false,
		on_insert_follow = false,
		insert_winblend = 0,
		show_code_action = true,
		show_source = true,
		jump_num_shortcut = true,
		max_width = 0.7,
		max_height = 0.6,
		max_show_width = 0.9,
		max_show_height = 0.6,
		text_hl_follow = true,
		border_follow = true,
		extend_relatedInformation = false,
		keys = {
			exec_action = 'o',
			quit = 'q',
			expand_or_jump = '<CR>',
			quit_in_show = { 'q', '<ESC>' },
		},
	},
	rename = {
		quit = "<C-c>",
		exec = "<CR>",
		select = "x",
		confirm = "<CR>",
		in_select = true,
	},
	outline = {
		win_position = "right",
		win_with = "",
		win_width = 30,
		preview_width= 0.4,
		show_detail = true,
		auto_preview = true,
		auto_refresh = true,
		auto_close = true,
		custom_sort = nil,
		keys = {
			expand_or_jump = 'o',
			quit = "q",
		},
	},
	symbol_in_winbar = {
		enable = true,
		separator = " ",
		ignore_patterns={},
		hide_keyword = true,
		show_file = true,
		folder_level = 2,
		respect_root = false,
		color_mode = true,
	},
	beacon = {
		enable = true,
		frequency = 7,
	},
}

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { noremap = true, silent = true, buffer = event.buf }

		-- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

		-- vim.keymap.set('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',                       opts)
		-- vim.keymap.set('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',                    opts)
		-- vim.keymap.set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)


		vim.keymap.set("n", "gh", "<cmd>Lspsaga finder def+ref<cr>",    opts)
		vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<cr>",    opts)
		vim.keymap.set("n", "gD", "<cmd>Lspsaga goto_definition<cr>",    opts)
		vim.keymap.set("n", "gr", "<cmd>Lspsaga rename ++project<cr>",                opts)
		vim.keymap.set("n", "gx", "<cmd>Lspsaga code_action<cr>",           opts)
		vim.keymap.set("x", "gx", ":<c-u>Lspsaga range_code_action<cr>",    opts)
		vim.keymap.set("n", "K",  "<cmd>Lspsaga hover_doc<cr>",             opts)
		-- vim.keymap.set("n", "K",  "<cmd>Lspsaga hover_doc<cr>",             vim.tbl_deep_extend('force', opts, {noremap=false}))
		vim.keymap.set("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
		vim.keymap.set("n", "gJ", "<cmd>Lspsaga diagnostic_jump_next<cr>",  opts)
		vim.keymap.set("n", "gK", "<cmd>Lspsaga diagnostic_jump_prev<cr>",  opts)
		--
		vim.keymap.set("n", "gO", "<cmd>Lspsaga outgoing_calls<cr>", opts)
		vim.keymap.set("n", "gI", "<cmd>Lspsaga incoming_calls<cr>", opts)
		-- vim.keymap.set("n", "<C-j>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-j>')<cr>", {})
		-- vim.keymap.set("n", "<C-k>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-k>')<cr>",  {})

		-- Set some keybinds conditional on server capabilities
		-- if client.server_capabilities.document_formatting then
		-- 	vim.keymap.set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
		-- end
		-- if client.server_capabilities.document_range_formatting then
		-- 	vim.keymap.set("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
		-- end
	end
})

vim.keymap.set('n', '<C-j>', function() require('lspsaga.action').smart_scroll_with_saga(1) end)
vim.keymap.set('n', '<C-k>', function() require('lspsaga.action').smart_scroll_with_saga(-1) end)

vim.cmd("hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow")
vim.cmd("hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow")
vim.cmd("hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow")
