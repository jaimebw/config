local lsp = require("lsp-zero").preset({})
local lspconfig = require('lspconfig')

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- Configure lua language server
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

-- You can uncomment this if you want to install these LSPs automatically
-- lsp.ensure_installed({
--   'rust_analyzer',
--   'ruff_lsp'
-- })

lsp.setup()
