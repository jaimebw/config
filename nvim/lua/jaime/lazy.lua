local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
    {'mfussenegger/nvim-dap'},
    {'tpope/vim-commentary'
},
    { 'Civitasv/cmake-tools.nvim' },

    {'nvim-lualine/lualine.nvim',
    dependencies= { 'nvim-tree/nvim-web-devicons'},
    opt = true },
    {'christoomey/vim-tmux-navigator'
    },
    {
          "folke/trouble.nvim",
           dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "1.2.1.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    },

    'norcalli/nvim-colorizer.lua',

    {
        'nvim-tree/nvim-tree.lua',
        dependencies= {
        'nvim-tree/nvim-web-devicons', -- optional, for file icons
      },
    },

    {
          'nvim-telescope/telescope.nvim',
          tag = '0.1.4',
          dependencies=  {
              'nvim-lua/plenary.nvim'
          },
      },

    {
          'rose-pine/neovim',
          name= 'rose-pine',
    },
    {
    "rebelot/kanagawa.nvim",
    name= 'kanagawa',
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        ignore_install = { "help" },
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects'
        }
    },

    'tpope/vim-fugitive',

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
      -- LSP Support
          {'neovim/nvim-lspconfig'},             -- Required
          {                                      -- Optional
            'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
          {'williamboman/mason-lspconfig.nvim'}, -- Optional

          -- Autocompletion
          {'hrsh7th/nvim-cmp'},     -- Required
          {'hrsh7th/cmp-nvim-lsp'}, -- Required
          {'L3MON4D3/LuaSnip'},     -- Required
    }
  },

    'github/copilot.vim'
})
