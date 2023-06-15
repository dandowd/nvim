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

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"nvim-lua/plenary.nvim",
	"nmac427/guess-indent.nvim",
	{
		"microsoft/vscode-js-debug",
		dependencies = "mxsdev/nvim-dap-vscode-js",
		opt = true,
		build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
	},
	{ "b0o/schemastore.nvim" },
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	"folke/trouble.nvim",
	"folke/neodev.nvim",
	"nvim-treesitter/nvim-treesitter",
	"neovim/nvim-lspconfig",
	"williamboman/mason-lspconfig.nvim",
	"jose-elias-alvarez/null-ls.nvim",
	"github/copilot.vim",
	"Hoffs/omnisharp-extended-lsp.nvim",
	"williamboman/mason.nvim",
	"mfussenegger/nvim-dap",
	{ "akinsho/bufferline.nvim", tag = "v3.6.0", dependencies = "nvim-tree/nvim-web-devicons" },
	"rcarriga/nvim-dap-ui",
	"nvim-neotest/neotest-go",
	"rouge8/neotest-rust",
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-plenary",
			"haydenmeade/neotest-jest",
			"Issafalcon/neotest-dotnet",
		},
	},
	"nvim-tree/nvim-web-devicons",
	{ "nvim-telescope/telescope.nvim", tag = "0.1.1" },
	"nvim-lualine/lualine.nvim",
	"nvim-telescope/telescope-file-browser.nvim",
	"windwp/nvim-autopairs",
	{ "rose-pine/neovim", as = "rose-pine" },
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{ "williamboman/mason.nvim" }, -- Optional
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "hrsh7th/cmp-buffer" }, -- Optional
			{ "hrsh7th/cmp-path" }, -- Optional
			{ "hrsh7th/cmp-nvim-lua" }, -- Optional

			-- Snippets
			{ "L3MON4D3/LuaSnip" }, -- Required
		},
	},
})

-- This must come before lsp config
require("neoconf").setup({})

local lsp = require("lsp-zero").preset({
	name = "minimal",
	set_lsp_keymaps = true,
	manage_nvim_cmp = true,
	suggest_lsp_servers = false,
})

lsp.configure("omnisharp", {
	handlers = {
		["textDocument/definition"] = require("omnisharp_extended").handler,
	},
})

require("luasnip.loaders.from_vscode").lazy_load()

lsp.setup_nvim_cmp({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer", keyword_length = 5 },
		{ name = "luasnip" },
	},
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()

require("mason").setup()
require("mason-lspconfig").setup()

require("mason-lspconfig").setup_handlers({
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup({
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})
	end,
})

local json_capabilities = vim.lsp.protocol.make_client_capabilities()
json_capabilities.textDocument.completion.completionItem.snippetSupport = true
require("lspconfig").jsonls.setup({
	capabilities = json_capabilities,
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

require("lualine").setup()
require("rose-pine").setup({
	disable_background = true,
})
require("trouble").setup()

require("telescope").load_extension("file_browser")
require("nvim-autopairs").setup()

require("neotest").setup({
	adapters = {
		require("neotest-plenary"),
		require("neotest-jest"),
		require("neotest-dotnet"),
		require("neotest-rust"),
		require("neotest-go"),
	},
	output = {
		enable = false,
		open_on_run = false,
	},
	quickfix = {
		enable = false,
		open = false,
	},
	output_panel = {
		enable = false,
		open = false,
	},
})

require("bufferline").setup({
	options = {
		diagnostics = "nvim_lsp",
		indicator = {
			style = "underline",
		},
		separator_style = "padded_slant",
		sort_by = "directory",
	},
})

require("guess-indent").setup({})
