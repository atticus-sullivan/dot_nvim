local capabilities = require('cmp_nvim_lsp').default_capabilities()

return {
	root_markers = {
		'compile_commands.json',
		'compile_flags.txt',
		'CMakeLists.txt',
		'Makefile',
		'main.c',
		'.git',
	},
	capabilities = capabilities,
}
