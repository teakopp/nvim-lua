local plugins = require('plugins')

-- 1. BOOTSTRAP LAZY.NVIM
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- 2. LOAD PLUGINS
require("lazy").setup(plugins, {
  termguicolors = true,
  disable_netrw = true,
})

-- 3. MASON & CAPABILITIES
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls", "pyright", "gopls", "dockerls", "yamlls", "bashls",
    "eslint", "ts_ls", "solargraph", "rubocop", "clangd", "graphql", "terraformls"
  },
})

-- Common capabilities for nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- 4. NATIVE LSP CONFIGURATION (0.11 API)
local servers = {
  "pyright", "gopls", "dockerls", "yamlls", "bashls",
  "ts_ls", "clangd", "graphql", "solargraph", "terraformls", "lua_ls"
}

for _, lsp in ipairs(servers) do
  -- Fetch the default configuration from nvim-lspconfig data
  local config = vim.lsp.config[lsp]

  if config then
    -- Merge your custom capabilities and flags into the default config
    config = vim.tbl_deep_extend("force", config, {
      capabilities = capabilities,
      flags = { debounce_text_changes = 300 },
    })

    -- Server-Specific Logic (Clangd)
    if lsp == "clangd" then
      config.cmd = {
        'clangd', '--background-index', '--clang-tidy', '--log=verbose',
        '--header-insertion=iwyu', '--completion-style=detailed', '-j=4'
      }
      config.init_options = { fallbackFlags = { '-std=c++17' } }
    end

    -- Server-Specific Logic (Lua)
    if lsp == "lua_ls" then
      config.on_init = function(client)
        local path = client.workspace_folders[1].name
        if not (vim.uv or vim.loop).fs_stat(path..'/.luarc.json') and not (vim.uv or vim.loop).fs_stat(path..'/.luarc.jsonc') then
          client.config.settings.Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
          }
        end
        return true
      end
    end

    -- Register the modified config
    vim.lsp.config(lsp, config)
  end
end

-- Enable all servers (This replaces lspconfig setup loops)
vim.lsp.enable(servers)

-- Diagnostics Setup
vim.diagnostic.config({
  virtual_text = true,
  update_in_insert = false,
  severity_sort = true,
})

-- 5. KEYBINDINGS (LspAttach Autocommand)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    -- Navigation
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    -- Actions
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
  end,
})

-- 6. RUBOCOP (Manual Startup)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.lsp.start({ name = "rubocop", cmd = { "bundle", "exec", "rubocop", "--lsp" } })
  end,
})

-- 7. GENERAL EDITOR SETTINGS & UI
vim.cmd[[colorscheme everforest]]
vim.o.background = "dark"
vim.opt.hidden = true
vim.wo.number = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.termguicolors = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.signcolumn = "yes"

-- 8. KEYMAPS (General & Plugins)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {desc="Find References"})
vim.keymap.set('n', '<leader>ft', function()
    local function_name = vim.fn.expand("<cword>")
    require('telescope.builtin').live_grep({
        default_text = "def test_" .. function_name,
    })
end, { desc = 'Find tests for function under cursor' })

-- Substitute Plugin
vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })

-- Nvim-tree
require("nvim-tree").setup { filters = { dotfiles = true } }
vim.api.nvim_set_keymap("n", "<F2>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Formatter Autocmd
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ts", "*.js", "*.tsx", "*.jsx" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
