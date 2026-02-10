-- ====================================
-- File: mason_lsp.lua
-- Author: jaimebw
-- Created: 2025-04-05 00:34:17
-- ====================================

-- require("mason-lspconfig").setup {
--     ensure_installed = { "lua_ls", "rust_analyzer", "clangd" },
-- }

-- -- Install non-LSP tools through Mason
-- require("mason").setup()
-- require("mason.settings").set({
--     ui = {
--         icons = {
--             package_installed = "✓",
--             package_pending = "➜",
--             package_uninstalled = "✗"
--         }
--     }
-- })

-- -- Ensure other tools are installed
-- local mason_registry = require("mason-registry")
-- local function ensure_installed(package_name)
--     if not mason_registry.is_installed(package_name) then
--         mason_registry.get_package(package_name):install()
--     end
-- end

-- ensure_installed("clang-format")
-- ensure_installed("codelldb")
