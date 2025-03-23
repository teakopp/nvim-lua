local plugins = require('plugins')

-- Bootstrap Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- Load Lazy
require("lazy").setup(plugins, {
  termguicolors = true,
  disable_netrw = true,
})

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup ({
  ensure_installed = { "lua_ls", "pyright", "gopls", "dockerls", "yamlls", "bashls", "eslint", "ts_ls", "solargraph", "rubocop", "clangd", "graphql" },
})

-- Autocompletion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- LSP setup
local lspconfig = require('lspconfig')
local servers = { "pyright", "gopls", "dockerls", "yamlls", "bashls", "ts_ls", "clangd", "graphql", "solargraph" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { capabilities = capabilities }
end

-- ESLint setup
lspconfig.eslint.setup {
  capabilities = capabilities,
  settings = {
    format = { enable = true },
    codeAction = { disableRuleComment = { enable = true } },
  },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = true
  end,
  flags = {
    debounce_text_changes = 150,
  }
}

-- Enable LSP diagnostics to show in the buffer
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,  -- Show virtual text (error messages inline)
    update_in_insert = false, -- Don't update diagnostics in insert mode
  }
)


-- Lua setup
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = { version = 'LuaJIT' },
          workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
        },
      })
      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end,
}

-- Clangd setup with extra features
lspconfig.clangd.setup {
  cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
  init_options = { fallbackFlags = { '-std=c++17' } },
}

-- Rubocop setup
vim.opt.signcolumn = "yes"
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.lsp.start { name = "rubocop", cmd = { "bundle", "exec", "rubocop", "--lsp" } }
  end,
})

-- UI and extras
vim.cmd[[colorscheme everforest]]

vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

-- Editor settings
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

-- Nvim-tree
require("nvim-tree").setup {
  sort = { sorter = "case_sensitive" },
  view = { adaptive_size = true },
  renderer = { group_empty = true },
  filters = { dotfiles = true },
}
vim.api.nvim_set_keymap("n", "<F2>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F8>', ":colorscheme tokyonight-day <CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F9>', ":colorscheme tokyonight-night <CR>", { noremap = true, silent = true })

-- Formatter
require('formatter').setup({
  logging = false,
  filetype = {
    python = { function() return { exe = 'black', args = { '-' }, stdin = true } end },
    go = { function() return { exe = 'gofmt', args = {}, stdin = true } end },
    yaml = { function() return { exe = 'prettier', args = { '--stdin-filepath', vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) }, stdin = true } end },
  },
})

-- LSP mappings
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
  end,
})

vim.cmd([[augroup FormatAutogroup]])
vim.cmd([[  autocmd!]])
vim.cmd([[  autocmd BufWritePost * FormatWrite]])
vim.cmd([[augroup END]])
