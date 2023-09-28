local plugins = require('plugins') 

-- Bootstrap Lazy
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
vim.opt.runtimepath:prepend(lazypath)

-- Load Lazy
local lazy = require("lazy")

-- Lazy setup
lazy.setup(plugins, {
  termguicolors = true,
  disable_netrw = true,
})

-- Load LSP configurations
require'lspconfig'.pyright.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.dockerls.setup{}
require'lspconfig'.yamlls.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        }
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end
}

-- Load ColorScheme
vim.cmd[[colorscheme tokyonight-night]]

-- Show line numbers
vim.wo.number = true

-- Change indent to 2 spaces
vim.bo.shiftwidth = 2

-- OR set termguicolors to enable highlight groups
vim.o.termguicolors = true

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- Use F2 to toggle NvimTree
vim.api.nvim_set_keymap("n", "<F2>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Change between day and night colorschemes
vim.api.nvim_set_keymap('n', '<F8>', ":colorscheme tokyonight-day <CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F9>', ":colorscheme tokyonight-night <CR>", { noremap = true, silent = true })

-- formatter.nvim setup
require('formatter').setup({
  logging = false, -- Set to true to enable debug logging
  filetype = {
    python = {
      function()
        return {
          exe = 'black',
          args = { '-' },
          stdin = true,
        }
      end,
    },
    go = {
      function()
        return {
          exe = 'gofmt',
          args = {},
          stdin = true,
        }
      end,
    },
    javascript = {
      function()
        return {
          exe = 'prettier',
          args = { '--stdin-filepath', vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote' },
          stdin = true,
        }
      end,
    },
    typescript = {
      function()
        return {
          exe = 'prettier',
          args = { '--stdin-filepath', vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote' },
          stdin = true,
        }
      end,
    },
  },
})

-- Define an autocmd to run formatter.nvim on save
vim.cmd([[augroup FormatAutogroup]])
vim.cmd([[  autocmd!]])
vim.cmd([[  autocmd BufWritePost * FormatWrite]])
vim.cmd([[augroup END]])




