vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

vim.cmd('autocmd BufNewFile,BufRead *.tera.html set filetype=html')

-- -- Transparency settings
-- local set_transparent_bg = function(group)
--   vim.api.nvim_set_hl(0, group, { bg = "NONE" })
-- end

-- local groups = { "Normal", "NonText", "SignColumn", "NormalNC", "TelescopeBorder" }

-- for _, group in ipairs(groups) do
--   set_transparent_bg(group)
-- end
-- -- Function to set iTerm2 transparency
-- local function set_iterm2_transparency(transparency)
--     local applescript_command = string.format(
--         'osascript -e \'tell application "iTerm2" to tell current window to set transparency to %s\'',
--         transparency
--     )
--     vim.fn.system(applescript_command)
-- end

-- -- Set iTerm2 transparency to 0.8 (80%) on NeoVim startup
-- set_iterm2_transparency(0.8)

