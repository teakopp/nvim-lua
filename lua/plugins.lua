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

  -- Better Quickfix menu 
  'kevinhwang91/nvim-bqf',

  -- nvim-tree
  {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    cmd = 'NvimTreeToggle',
  },

  -- TokyoNight Colorscheme
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup{}
    end
  },

  -- Nord Colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup{}
    end
  },

  -- fzf
   "junegunn/fzf", dir = "~/.fzf", build = "./install --all",
   'junegunn/fzf.vim',

  -- formatter
  'mhartington/formatter.nvim',

  -- Substitute
  "gbprod/substitute.nvim",

  -- Telescope
   'nvim-lua/plenary.nvim',
   'nvim-telescope/telescope.nvim', tag = 'latest',
      dependencies = { 'nvim-lua/plenary.nvim' }

}
