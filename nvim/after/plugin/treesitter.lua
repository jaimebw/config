local parser_root = vim.fn.stdpath("config") .. "/.treesitter"
pcall(vim.fn.mkdir, parser_root, "p")
vim.opt.runtimepath:append(parser_root)

local ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

local ok_setup, err = pcall(treesitter_configs.setup, {
  -- A list of parser names, or "all"
  ensure_installed = {},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  -- List of parsers to ignore installing (for "all")

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  parser_install_dir = parser_root,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    additional_vim_regex_highlighting = false,
  },
})

if not ok_setup then
  vim.schedule(function()
    vim.notify("nvim-treesitter setup failed: " .. err, vim.log.levels.WARN)
  end)
end
