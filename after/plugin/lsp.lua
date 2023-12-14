vim.lsp.set_log_level('debug')

vim.g.lsp_zero_extend_cmp = 0
vim.g.lsp_zero_extend_lspconfig = 0

local lsp = require('lsp-zero')
local status, nvim_lsp = pcall(require, "lspconfig")

if (not status) then return end

lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'rust_analyzer',
  'tailwindcss',
  'lua_ls',
  'ltex',
  'vtsls',
  'yamlls',
  'bashls'
})

-- Fix Undefined global 'vim'
lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

local cmp = require("cmp")
local cmp_select = { behaivor = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
  ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
  ["<C-y>"] = cmp.mapping.confirm({ select = true }),
  ["<C-space>"] = cmp.mapping.complete()
})


-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  setup_servers_on_start = true,
  set_lsp_keymaps = true,
  configure_diagnostics = true,
  cmp_capabilities = true,
  manage_nvim_cmp = true,
  call_servers = 'local',
  sign_icons = {
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = ''
  }
})

lsp.on_attach(function(client, bufnr)
  print("help on attach")
  local opts = { buffer = bufnr, remap = false }

  lsp.default_keymaps({buffer = bufnr})
  -- lsp.buffer_autoformat()

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>tt", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

end)

-- local lsp_zero = require('lsp-zero.api')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

nvim_lsp.tsserver.setup({
  capabilities = lsp_capabilities,
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = true

    -- Configuración del resaltado de errores en las variables
    client.resolved_capabilities.spell_checker.variables = true
    client.resolved_capabilities.document_formatting = true

    -- Configuración del estilo del resaltado de errores
    client.resolved_capabilities.spell_checker.error_highlight = '#FFA07A'

    lsp.default_keymaps({buffer = bufnr})
  end,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" },
  settings = {
    format = {
      enable = true,
      formatter = 'prettier'
    }
  }
})

nvim_lsp.sourcekit.setup({
  on_attach = function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
  end
})

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
-- local cmp_config = lsp.defaults.cmp_config({})
cmp.setup({
  sources = {
    {name = 'nvim_lsp'}
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

lsp.setup_servers({'eslint', 'lua_ls', 'rust_analyzer',  force = true, })

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

lsp.setup()

vim.diagnostic.config({
  virtual_text = true,
})

