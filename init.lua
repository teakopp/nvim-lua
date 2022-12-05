require('plugins')
require'lspconfig'.pyright.setup{}

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Show line numbers
vim.wo.number = true

-- Change indent to 2 spaces
vim.o.shiftwidth = 2

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

--Use F2 to toggle NerdTree
vim.keymap.set("n","<F2>", ":NvimTreeToggle<CR>")


