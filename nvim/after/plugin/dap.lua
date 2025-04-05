local dap = require('dap')
local dapui = require('dapui')

-- Keybindings
vim.keymap.set('n', '<Leader>dr', function()
  dap.terminate()
  dap.continue()
end, { desc = 'Restart Debugging' })

vim.keymap.set('n', '<Leader>bcc', function()
  dap.clear_breakpoints()
end, { desc = 'Clear All Breakpoints' })

vim.keymap.set('n', '<Leader>b', function()
  local condition = vim.fn.input('Breakpoint condition: ')
  dap.set_breakpoint(condition)
end, { desc = 'Conditional Breakpoint' })

vim.keymap.set('n', '<Leader>du', function()
  dapui.toggle()
end, { desc = 'Toggle DAP UI' })

vim.keymap.set('n', '<Leader>de', function()
  local expression = vim.fn.input('Evaluate: ')
  dap.repl.evaluate(expression)
end, { desc = 'Evaluate Expression' })

vim.keymap.set('n', '<Leader>bn', function()
  dap.goto_next_breakpoint()
end, { desc = 'Next Breakpoint' })

vim.keymap.set('n', '<Leader>bp', function()
  dap.goto_prev_breakpoint()
end, { desc = 'Previous Breakpoint' })

vim.keymap.set('n', '<Leader>bf', function()
  local function_name = vim.fn.input('Function name: ')
  dap.set_breakpoint(function_name)
end, { desc = 'Function Breakpoint' })

-- Adapters and Configurations

-- C/C++ using lldb
dap.adapters.codelldb = {
    type = 'server',
    host = '127.0.0.1',
    port = 13000
}

dap.configurations.c = {
    {
        type = 'codelldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd()..'/', 'file')
        end,
        --program = '${fileDirname}/${fileBasenameNoExtension}',
        cwd = '${workspaceFolder}',
        terminal = 'integrated'
    }
}

dap.configurations.cpp = dap.configurations.c

dap.configurations.rust = {
    {
        type = 'codelldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd()..'/', 'file')
        end,
        cwd = '${workspaceFolder}',
        terminal = 'integrated',
        sourceLanguages = { 'rust' }
    }
}

-- Rust using lldb
dap.configurations.rust = dap.configurations.cpp


dap.configurations.python = {
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      pythonPath = function()
        return vim.fn.exepath('python')
      end,
    },
  }

-- DAP UI Setup
require('dapui').setup()
vim.api.nvim_create_user_command('JaimeDapHelp', function()
  local lines = {
    'DAP Keybindings:',
    '',
    '<Leader>dr - Restart debugging',
    '<Leader>bc - Conditional breakpoint / Clear breakpoints',
    '<Leader>bf - Function breakpoint',
    '<Leader>du - Toggle DAP UI',
    '<Leader>de - Evaluate expression',
    '<Leader>bn - Next breakpoint',
    '<Leader>bp - Previous breakpoint',
  }

  vim.cmd('new')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.swapfile = false
  vim.bo.filetype = 'help'
end, {})

