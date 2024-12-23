require("catppuccin").setup({
	flavour = "frappe", -- latte, frappe, macchiato, mocha
	background = { -- :h background
		light = "latte",
		dark = "frappe",
	},
	transparent_background = true,
	show_end_of_buffer = true, -- show the '~' characters after the end of buffers
	term_colors = true,
	-- dim_inactive = {
	-- 	enabled = true,
	-- 	shade = "dark",
	-- 	percentage = 0.15,
	-- },
	no_italic = false, -- Force no italic
	no_bold = false, -- Force no bold
	styles = {
		comments = { "italic" },
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	color_overrides = {
		all = {
			text = "#ffffff",
		},
	},
	custom_highlights = {},
	integrations = {
		cmp = true,
		nvimtree = true,
		treesitter = true,
		-- gitsigns = true,
		-- telescope = true,
		-- notify = false,
		-- mini = false,
		-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
		lsp_saga = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
		},
	},
})
