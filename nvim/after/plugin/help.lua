local function show_dap_help()
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true) -- create a new empty buffer in memory
  vim.api.nvim_set_current_buf(buf) -- make the new buffer the current buffer

  -- Set buffer options to make it look nice
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe') -- buffer is deleted when no longer displayed
  vim.api.nvim_buf_set_option(buf, 'modifiable', true) -- allow buffer to be modified

  -- Define your mappings and descriptions
  local mappings = {
    {'<Leader>dr', 'Restart Debugging: Terminate and restart session'},
    {'<Leader>bc', 'Clear All Breakpoints: Remove all breakpoints'},
    {'<Leader>bc', 'Conditional Breakpoint: Set a breakpoint with a condition'},
    {'<Leader>du', 'Toggle DAP UI: Show or hide DAP UI elements'},
    {'<Leader>de', 'Evaluate Expression: Evaluate expressions in context'},
    {'<Leader>bn', 'Next Breakpoint: Navigate to the next breakpoint'},
    {'<Leader>bp', 'Previous Breakpoint: Navigate to the previous breakpoint'},
    {'<Leader>bf', 'Function Breakpoint: Set a breakpoint on a function'},
    {'<Leader>db', 'List Breakpoints with Telescope'},
    {'<Leader>df', 'List Frames with Telescope'},
    {'<Leader>dv', 'List Variables with Telescope'},
  }

  -- Write the mappings to the buffer
  for _, mapping in ipairs(mappings) do
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {mapping[1] .. " - " .. mapping[2]})
  end

  -- Set the buffer as non-modifiable after writing the content
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  -- Optionally, set the filetype to markdown or text for better readability
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
end

-- Create a command in Neovim to show the DAP help
vim.api.nvim_create_user_command('DapHelp', show_dap_help, {desc = "Show DAP Commands Help"})

