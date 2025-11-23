local capabilities = require('cmp_nvim_lsp').default_capabilities()

return {
	root_markers = {
		'tlconfig.lua',
		'.git',
	},
	capabilities = capabilities,
}
