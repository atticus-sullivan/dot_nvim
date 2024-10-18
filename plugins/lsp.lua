local util = require 'lspconfig.util'
local nvim_lsp = require('lspconfig')

local function cursorMoved()
	local group = vim.api.nvim_create_augroup("lsp_document_highlight", {clear = true})
	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function() vim.lsp.buf.document_highlight() end,
		group = group
	})
	vim.api.nvim_create_autocmd("CursorMoved", {
		callback = function() vim.lsp.buf.clear_references() end,
		group = group
	})
end

local lsp_defaults = nvim_lsp.util.default_config
capabilities = vim.tbl_deep_extend(
	'force',
	lsp_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
)
local function on_attach_add(o)
	return function(client, bufnr)
		local function buf_set_keymap(...)
			vim.api.nvim_buf_set_keymap(bufnr, ...)
		end
		local function buf_set_option(...)
			vim.api.nvim_buf_set_option(bufnr, ...)
		end

		buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

		-- Mappings.
		local opts = { noremap=true, silent=true }
		buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',                       opts)
		buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',                    opts)
		buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

		-- -- custom stuff
		for _,map in ipairs(o) do
			buf_set_keymap("n", map[1], map[2], vim.tbl_deep_extend('force', opts, map[3]))
		end

		-- lspsaga
		buf_set_keymap("n", "gh", "<cmd>Lspsaga finder def+ref<cr>",    opts)
		buf_set_keymap("n", "gd", "<cmd>Lspsaga peek_definition<cr>",    opts)
		buf_set_keymap("n", "gD", "<cmd>Lspsaga goto_definition<cr>",    opts)
		buf_set_keymap("n", "gr", "<cmd>Lspsaga rename ++project<cr>",                opts)
		buf_set_keymap("n", "gx", "<cmd>Lspsaga code_action<cr>",           opts)
		buf_set_keymap("x", "gx", ":<c-u>Lspsaga range_code_action<cr>",    opts)
		buf_set_keymap("n", "K",  "<cmd>Lspsaga hover_doc<cr>",             opts)
		-- buf_set_keymap("n", "K",  "<cmd>Lspsaga hover_doc<cr>",             vim.tbl_deep_extend('force', opts, {noremap=false}))
		buf_set_keymap("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
		buf_set_keymap("n", "gJ", "<cmd>Lspsaga diagnostic_jump_next<cr>",  opts)
		buf_set_keymap("n", "gK", "<cmd>Lspsaga diagnostic_jump_prev<cr>",  opts)
		--
		buf_set_keymap("n", "gO", "<cmd>Lspsaga outgoing_calls<cr>", opts)
		buf_set_keymap("n", "gI", "<cmd>Lspsaga incoming_calls<cr>", opts)
		-- buf_set_keymap("n", "<C-j>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-j>')<cr>", {})
		-- buf_set_keymap("n", "<C-k>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-k>')<cr>",  {})

		-- Set some keybinds conditional on server capabilities
		if client.server_capabilities.document_formatting then
			buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
		end
		if client.server_capabilities.document_range_formatting then
			buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
		end
	end
end

local on_attach = on_attach_add{}

require'lspconfig'.lua_ls.setup{
settings = {
	Lua = {
		-- see https://github.com/LuaLS/lua-language-server/wiki/Settings
		runtime = {
			-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
			version = 'Lua5.4',
			path = {
				'?.lua',
				'?/init.lua',
				vim.fn.expand'~/.luarocks/share/lua/5.4/?.lua',
				vim.fn.expand'~/.luarocks/share/lua/5.4/?/init.lua',
				'/usr/share/5.4/?.lua',
				'/usr/share/lua/5.4/?/init.lua'
			},
			},
		diagnostics = {
			enable = true,
			-- Get the language server to recognize the `vim` global
			-- globals = {'vim'},
			},
		workspace = {
			checkThirdParty = false,
			library = {
				vim.fn.expand'~/.luarocks/share/lua/5.4',
				'/usr/share/lua/5.4',
				'~/coding/xournalpp/plugins/'
			},
		},
		-- Do not send telemetry data containing a randomized but unique identifier
		telemetry = {
			enable = false,
			},
		},
	},
 	on_attach = function(client, bufnr) on_attach(client, bufnr) cursorMoved() end,
	capabilities = capabilities,
 	root_dir = function(fname) return util.root_pattern('main.lua')(fname) or util.find_git_ancestor(fname) end,
}

-- require'lspconfig'.golangci_lint_ls.setup{
--  	on_attach = function(client, bufnr) on_attach(client, bufnr) cursorMoved() end,
-- 	capabilities = capabilities,
-- }
require'lspconfig'.gopls.setup{
 	on_attach = function(client, bufnr) on_attach(client, bufnr) cursorMoved() end,
	capabilities = capabilities,
}

require'lspconfig'.pyright.setup{
 	on_attach = function(client, bufnr) on_attach(client, bufnr) cursorMoved() end,
	root_dir = function(fname) return util.root_pattern('main.py')(fname) or util.find_git_ancestor(fname) end,
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				typeCheckingMode = "basic",
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				extraPaths = {
					"~/.conda/envs/main/lib/python3.12/site-packages",
				}
			}
		}
	},
}
-- require'lspconfig'.texlab.setup{
-- 	on_attach = on_attach,
-- 	root_dir = function(fname) return util.root_pattern('master.tex', 'main.tex', 'Makefile')(fname) or util.find_git_ancestor(fname) end,
-- 	capabilities = capabilities,
-- }
require'lspconfig'.clangd.setup{
	root_dir = function(fname) return util.root_pattern('compile_commands.json', 'compile_flags.txt', 'CMakeLists.txt', 'Makefile', 'main.c')(fname) or util.find_git_ancestor(fname) end,
 	on_attach = function(client, bufnr) on_attach(client, bufnr) cursorMoved() end,
	capabilities = capabilities,
}
require'lspconfig'.cmake.setup{
 	on_attach = function(client, bufnr) on_attach(client, bufnr) cursorMoved() end,
	root_dir = function(fname) return util.root_pattern('compile_commands.json', 'compile_flags.txt', 'CMakeLists.txt', 'Makefile', 'main.c')(fname) or util.find_git_ancestor(fname) end,
	capabilities = capabilities,
}
require'lspconfig'.marksman.setup{
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = util.root_pattern(".git", ".marksman.toml", "main.md", "root.md", "index.md"),
	single_file_support = true,
}
require'lspconfig'.teal_ls.setup{
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = util.root_pattern("tlconfig.lua", ".git"),
}

-- require'lspconfig'.rust_analyzer.setup{
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	cmd = {"rustup", "run", "stable", "rust-analyzer"},
-- 	settings = {
-- 		['rust-analyzer'] = {
-- 			diagnostics = {
-- 				enable = true;
-- 				},
-- 			hover = {
-- 				actions = {
-- 					enable = true,
-- 					gotoTypeDef = {enable=true},
-- 					},
-- 			},
-- 			inlayHints = {
-- 				bindingModeHints = {enable=true},
-- 				closingBraceHints = {enable=true},
-- 				closureCaptureHints = {enable=true},
-- 			},
-- 		}
-- 	}
-- }


vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = false,
	float = {
		border = 'rounded',
		source = 'always',
		header = '',
		prefix = '',
	},
})

local extension_path = vim.env.HOME .. '/programme/codelldb-x86_64-linux/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb'
local this_os = vim.loop.os_uname().sysname;

liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")

require("rust-tools").setup{
	server = {
		-- on_attach = on_attach,
		on_attach = function(client, bufnr) on_attach_add({
			{"gH", "<cmd>RustHoverActions<CR>", {noremap=false}},
		})(client, bufnr) cursorMoved() end,
		capabilities = vim.tbl_deep_extend(
			'force',
			capabilities,
			{
				textDocument = {
					inlayHint = {
						dynamicRegistration = true,
					},
					diagnostic = {
						dynamicRegistration = true,
					},
				},
			}
		),
		cmd = {"rustup", "run", "stable", "rust-analyzer"},
		},
	tools = {
		inlay_hints = {
			auto = true,
			show_parameter_hints = true,
		},
		hover_actions = {
			auto_focus = true,
		},
	},
	dap = {
		adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
	},
	-- dap = {
	-- 	adapter = {
	-- 		type = "executable",
	-- 		command = "lldb-vscode",
	-- 		name = "rt_lldb",
	-- 	},
	-- },
}


-- nvim_lsp.rls.setup {
-- 	settings = {
-- 		rust = {
-- 			unstable_features = true,
-- 			build_on_save = false,
-- 			all_features = true,
-- 		},
-- 	},
-- }
-- require'lspconfig'.als.setup{cmd = "/path/to/als/executable"}

-- disable inline diagnostic
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics, {
--         virtual_text = false
--     }
-- )

vim.keymap.set('n', '<C-j>', function() require('lspsaga.action').smart_scroll_with_saga(1) end)
vim.keymap.set('n', '<C-k>', function() require('lspsaga.action').smart_scroll_with_saga(-1) end)

vim.cmd("hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow")
vim.cmd("hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow")
vim.cmd("hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow")
