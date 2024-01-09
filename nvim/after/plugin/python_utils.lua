function Pytest(mode)
    -- For running Pytest with Neovim
    local commands = "source venv/bin/activate;pytest tests ".. mode
    local output = vim.api.nvim_call_function("system",{commands})
    vim.api.nvim_command("echo '"..output.."'")
end
-- More info of the commands at https://gist.github.com/kwmiebach/3fd49612ef7a52b5ce3a
vim.api.nvim_set_keymap("n", "<leader>t", ":lua Pytest('')<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>tv", ":lua Pytest('-v')<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>ts", ":lua Pytest('-s')<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>tq", ":lua Pytest('-q')<CR>", {noremap = true})

-- Ruff implementation 
-- See: https://github.com/neovim/nvim-lspconfig/tree/54eb2a070a4f389b1be0f98070f81d23e2b1a715#suggested-configuration
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
