local dap = require("dap")
local dapui = require("dapui")

require('dap-go').setup()

vim.keymap.set('n', '<leader>dc', function() dap.continue() end)
vim.keymap.set('n', '<leader>dl', function() dap.run_last() end)

vim.keymap.set('n', '<leader>so', function() dap.step_over() end)
vim.keymap.set('n', '<leader>si', function() dap.step_into() end)
vim.keymap.set('n', '<leader>sO', function() dap.step_out() end)

vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)

require("dapui").setup()
vim.keymap.set('n', '<leader>du', function() dapui.toggle() end)
vim.keymap.set('n', '<leader>df', function() dapui.float_element() end)
vim.keymap.set('n', '<leader>de', function() dapui.eval() end)

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
