
-- local nvim_lsp = require('lspconfig')

-- print("help on on_attach typescript")
-- nvim_lsp.tsserver.setup {
--   filetypes = {"typescript", "typescriptreact", "typescript.tsx"},
--   cmd = {"typescript-language-server", "--stdio"},
--   on_attach = function(client)
--     client.resolved_capabilities.document_formatting = true
--     client.resolved_capabilities.document_range_formatting = true
--   end,
--   settings = {
--     format = {
--       enable = true,
--       formatter = 'prettier',
--     },
--   },
-- }
