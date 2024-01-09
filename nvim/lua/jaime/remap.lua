vim.g.mapleader = " "
--vim.keymap.set("n","<leader>pv",vim.cmd.Ex)
vim.api.nvim_set_keymap('n', '<Leader>pv', ':NvimTreeToggle<CR>', {silent=true})
-- Movements between splits
vim.api.nvim_set_keymap("n", "<up>", "<C-w><up>", { noremap = true })
vim.api.nvim_set_keymap("n", "<down>", "<C-w><down>", { noremap = true })
vim.api.nvim_set_keymap("n", "<left>", "<C-w><left>", { noremap = true })
vim.api.nvim_set_keymap("n", "<right>", "<C-w><right>", { noremap = true })
