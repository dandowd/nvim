local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local lspconfig = require('lspconfig')

lspconfig.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
    end
}

lspconfig.eslint.setup {
    on_attach = function(client, bufnr)
            autocmd('BufWritePre', {
                command = 'EslintFixAll',
            })
    end
}

-- autocmd('BufWritePre', {
--         pattern = "*",
--         callback = function()
--            vim.cmd [[ silent exec '!./node_modules/.bin/prettier --write %' ]]
--            vim.cmd [[ edit! ]]
--         end,
-- })
