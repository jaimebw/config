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
    {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- add any opts here
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
},

    -- DAP
    { "mfussenegger/nvim-dap"},
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "mfussenegger/nvim-dap"
        }

    },
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = {
            "mfussenegger/nvim-dap",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "nvim-telescope/telescope-dap.nvim"
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            -- Automatically open UI when debugging starts
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            -- Automatically close UI when debugging ends
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    },


    { "folke/neodev.nvim", opts = {} },
    {'tpope/vim-commentary'},
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
          name= 'roseson-pine',
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
          {'williamboman/mason.nvim',            -- Optional
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
