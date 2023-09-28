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

  -- fzf
  {
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf', run = ':call fzf#install()' }
  },

  -- formatter
  'mhartington/formatter.nvim'

}
