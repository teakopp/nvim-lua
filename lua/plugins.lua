-- Plugin list
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

  -- nvim-treesitter
  -- in your plugins.lua list
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
      -- include whatever other languages you edit
      ensure_installed = { "lua" },
      highlight = { enable = true },
    }
  end,
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
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",      -- LSP source
      "hrsh7th/cmp-buffer",        -- Buffer words
      "hrsh7th/cmp-path",          -- File paths
      "hrsh7th/cmp-cmdline",       -- Command-line completion
      "saadparwaiz1/cmp_luasnip",  -- Snippet completion
      "L3MON4D3/LuaSnip",          -- Snippet engine
      "rafamadriz/friendly-snippets", -- Predefined snippets
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Optional: cmdline completions
      cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
    end,
  },
}

