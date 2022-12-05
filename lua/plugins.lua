-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- nvim-lspconfig
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP

  -- vim-surrounf
  use 'tpope/vim-surround'

  -- nerdcommenter
  use 'preservim/nerdcommenter'

  -- peekaboo
  use 'junegunn/vim-peekaboo'
  
  --nvim-tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }


end)



