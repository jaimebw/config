local find_files = require('telescope.builtin').find_files
local git_files = require('telescope.builtin').git_files
local grep_string = require('telescope.builtin').grep_string
require('telescope').load_extension('dap')

local file_ignore_patterns = { "node_modules", ".git/", "venv","__pycache__","target",".ipynb_checkpoints"}

-- Find files
vim.keymap.set('n', '<leader>pf', function()
    find_files({
        file_ignore_patterns = file_ignore_patterns,
        hidden = true,
    })
end, {})

-- Git files
vim.keymap.set('n', '<C-p>', function()
    git_files({
        file_ignore_patterns = file_ignore_patterns,
        hidden = true,
    })
end, {})

-- Grep string
vim.keymap.set('n', '<leader>ps', function()
    grep_string({
        search = vim.fn.input("Grep > "),
        file_ignore_patterns = file_ignore_patterns,
    })
end,{})

-- List Breakpoints: Show all breakpoints
vim.keymap.set('n', '<Leader>db', ':Telescope dap list_breakpoints<CR>', {desc = 'List Breakpoints'})

-- List Frames: Show call stack frames
vim.keymap.set('n', '<Leader>df', ':Telescope dap frames<CR>', {desc = 'List Frames'})

-- List Variables: Show variables in the current scope
vim.keymap.set('n', '<Leader>dv', ':Telescope dap variables<CR>', {desc = 'List Variables'})

