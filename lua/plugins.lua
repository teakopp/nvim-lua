-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return {
  -- nvim-lspconfig
  'neovim/nvim-lspconfig', -- Configurations for Nvim LSP

  -- vim-surround
  'tpope/vim-surround',

  -- nerdcommenter
  'preservim/nerdcommenter',

  -- peekaboo
  'junegunn/vim-peekaboo',

  -- fugitive
  'tpope/vim-fugitive',

  -- mason.nvim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",

  -- Co-Pilot
  'github/copilot.vim',

  -- Follow OS light and dark mode
  'vimpostor/vim-lumen',

  -- Better Quickfix menu 
  'kevinhwang91/nvim-bqf',

  -- nvim-tree
  'nvim-tree/nvim-web-devicons',
  {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    cmd = 'NvimTreeToggle',
  },

  -- Everforest Colorscheme
  "sainnhe/everforest",

  -- fzf
   "junegunn/fzf", dir = "~/.fzf", build = "./install --all",
   'junegunn/fzf.vim',

  -- formatter
  'mhartington/formatter.nvim',

  -- Substitute
  "gbprod/substitute.nvim",

  -- Telescope
  {
   'nvim-lua/plenary.nvim',
   'nvim-telescope/telescope.nvim', tag = 'latest',
      dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Telescope file browser
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },

  -- nvim-autopairs
  {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      config = true
      -- use opts = {} for passing setup options
      -- this is equivalent to setup({}) function
  },


}
