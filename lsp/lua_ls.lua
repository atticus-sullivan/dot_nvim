local capabilities = require('cmp_nvim_lsp').default_capabilities()

return {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = {
		'main.lua',
		'.git',
	},
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
	capabilities = capabilities,
}
