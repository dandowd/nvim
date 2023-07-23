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

autocmd('BufWritePost', {
        pattern = "*.js, *.ts, *.jsx, *.tsx, *.html, *.css, *.scss, *.json, *.md",
        callback = function()
           -- The following command assumes that CWD is the root of the project. Which should be set by project_nvim
           vim.cmd [[ silent exec '!npx prettier --write %' ]]
           vim.cmd [[ edit! ]]
        end,
})
