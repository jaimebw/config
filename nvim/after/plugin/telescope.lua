local find_files = require('telescope.builtin').find_files
local git_files = require('telescope.builtin').git_files
local grep_string = require('telescope.builtin').grep_string

local file_ignore_patterns = { "node_modules", ".git", "venv","__pycache__","target",".ipynb_checkpoints"}

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

