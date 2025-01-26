-- Restart Debugging: Terminate the current session and start it again
vim.keymap.set('n', '<Leader>dr', function() require('dap').terminate(); require('dap').continue() end, {desc = 'Restart Debugging'})

-- Clear All Breakpoints: Remove all breakpoints in the current session
vim.keymap.set('n', '<Leader>bc', function() require('dap').clear_breakpoints() end, {desc = 'Clear All Breakpoints'})

-- Conditional Breakpoint: Set a breakpoint with a condition
vim.keymap.set('n', '<Leader>bc', function()
    local condition = vim.fn.input('Breakpoint condition: ')
    require('dap').set_breakpoint(condition)
end, {desc = 'Conditional Breakpoint'})

-- Toggle DAP UI: Show or hide DAP UI elements
vim.keymap.set('n', '<Leader>du', function() require('dapui').toggle() end, {desc = 'Toggle DAP UI'})

-- Evaluate Expression: Evaluate expressions in the current context
vim.keymap.set('n', '<Leader>de', function()
    local expression = vim.fn.input('Evaluate: ')
    require('dap').repl.evaluate(expression)
end, {desc = 'Evaluate Expression'})

-- Next Breakpoint: Navigate to the next breakpoint
vim.keymap.set('n', '<Leader>bn', function() require('dap').goto_next_breakpoint() end, {desc = 'Next Breakpoint'})

-- Previous Breakpoint: Navigate to the previous breakpoint
vim.keymap.set('n', '<Leader>bp', function() require('dap').goto_prev_breakpoint() end, {desc = 'Previous Breakpoint'})

-- Function Breakpoint: Set a breakpoint on a function by name
vim.keymap.set('n', '<Leader>bf', function()
    local function_name = vim.fn.input('Function name: ')
    require('dap').set_breakpoint(function_name)
end, {desc = 'Function Breakpoint'})

