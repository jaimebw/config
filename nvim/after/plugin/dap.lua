-- ====================================
-- File: dap.lua
-- Author: jaimebw
-- Created: 2025-04-05 15:22:58
-- ====================================

local dap = require('dap')
local has_dapui, dapui = pcall(require, 'dapui')

-- Keybindings
-- Basic debugging control
vim.keymap.set('n', '<Leader>dc', function() dap.continue() end, { desc = 'Start/Continue Debugging' })
vim.keymap.set('n', '<Leader>dr', function() dap.terminate(); dap.continue() end, { desc = 'Restart Debugging' })
vim.keymap.set('n', '<Leader>dt', function() dap.terminate() end, { desc = 'Terminate Debugging' })
vim.keymap.set('n', '<Leader>dp', function() dap.pause() end, { desc = 'Pause Debugging' })

-- Stepping
vim.keymap.set('n', '<Leader>di', function() dap.step_into() end, { desc = 'Step Into' })
vim.keymap.set('n', '<Leader>do', function() dap.step_over() end, { desc = 'Step Over' })
vim.keymap.set('n', '<Leader>dO', function() dap.step_out() end, { desc = 'Step Out' })
vim.keymap.set('n', '<Leader>db', function() dap.step_back() end, { desc = 'Step Back' })
vim.keymap.set('n', '<Leader>dg', function() dap.run_to_cursor() end, { desc = 'Run to Cursor' })

-- Breakpoints
vim.keymap.set('n', '<Leader>bb', function() dap.toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })
vim.keymap.set('n', '<Leader>bc', function()
  local condition = vim.fn.input('Breakpoint condition: ')
  dap.set_breakpoint(condition)
end, { desc = 'Conditional Breakpoint' })
vim.keymap.set('n', '<Leader>bl', function()
  dap.set_breakpoint(nil, nil, vim.fn.input('Log message: '))
end, { desc = 'Logpoint' })
vim.keymap.set('n', '<Leader>bC', function() dap.clear_breakpoints() end, { desc = 'Clear All Breakpoints' })
vim.keymap.set('n', '<Leader>bn', function() dap.goto_next_breakpoint() end, { desc = 'Next Breakpoint' })
vim.keymap.set('n', '<Leader>bp', function() dap.goto_prev_breakpoint() end, { desc = 'Previous Breakpoint' })
vim.keymap.set('n', '<Leader>bf', function()
  local function_name = vim.fn.input('Function name: ')
  dap.set_breakpoint(nil, nil, function_name)
end, { desc = 'Function Breakpoint' })

-- UI and information
vim.keymap.set('n', '<Leader>du', function()
  if has_dapui then
    dapui.toggle()
  else
    vim.notify('dapui is not available (check nvim-nio and nvim-dap-ui)', vim.log.levels.WARN)
  end
end, { desc = 'Toggle DAP UI' })
vim.keymap.set('n', '<Leader>de', function()
  if has_dapui then
    local expression = vim.fn.input('Evaluate: ')
    dapui.eval(expression, {})
  else
    vim.notify('dapui is not available (check nvim-nio and nvim-dap-ui)', vim.log.levels.WARN)
  end
end, { desc = 'Evaluate Expression' })
vim.keymap.set('n', '<Leader>dh', function() require('dap.ui.widgets').hover() end, { desc = 'Hover Variables' })
vim.keymap.set('n', '<Leader>ds', function() require('dap.ui.widgets').scopes() end, { desc = 'Show Scopes' })
vim.keymap.set('n', '<Leader>df', function() require('dap.ui.widgets').frames() end, { desc = 'Show Frames' })

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

-- DAP UI Setup (optional; avoid startup crashes if dependency load fails)
if has_dapui then
  dapui.setup()
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
else
  vim.schedule(function()
    vim.notify('nvim-dap-ui failed to load; DAP core remains available', vim.log.levels.WARN)
  end)
end
vim.api.nvim_create_user_command('JaimeDapHelp', function()
  local lines = {
    'DAP Keybindings:',
    '',
    '-- Basic debugging control --',
    '<Leader>dc - Start/Continue debugging',
    '<Leader>dr - Restart debugging',
    '<Leader>dt - Terminate debugging',
    '<Leader>dp - Pause debugging',
    '',
    '-- Stepping --',
    '<Leader>di - Step into',
    '<Leader>do - Step over',
    '<Leader>dO - Step out',
    '<Leader>db - Step back',
    '<Leader>dg - Run to cursor',
    '',
    '-- Breakpoints --',
    '<Leader>bb - Toggle breakpoint',
    '<Leader>bc - Conditional breakpoint',
    '<Leader>bl - Logpoint (breakpoint with message)',
    '<Leader>bC - Clear all breakpoints',
    '<Leader>bn - Next breakpoint',
    '<Leader>bp - Previous breakpoint',
    '<Leader>bf - Function breakpoint',
    '',
    '-- UI and information --',
    '<Leader>du - Toggle DAP UI',
    '<Leader>de - Evaluate expression',
    '<Leader>dh - Hover variables',
    '<Leader>ds - Show scopes',
    '<Leader>df - Show frames',
  }

  vim.cmd('new')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.swapfile = false
  vim.bo.filetype = 'help'
end, {})
