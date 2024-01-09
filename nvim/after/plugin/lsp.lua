local lsp = require("lsp-zero").preset({})


lsp.ensure_installed({
  'rust_analyzer',
  'ruff_lsp'
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
