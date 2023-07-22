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
                group = 'OnSave',
                command = 'EslintFixAll',
            })
    end
}

augroup('OnSave', { clear = true })
autocmd('BufWritePre', {
        group = 'OnSave',
        callback = function()
           vim.lsp.buf.format() 
        end,
})
