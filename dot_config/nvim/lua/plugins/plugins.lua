-- Devicons
vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })
-- Treesitter
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

require("nvim-treesitter").setup({
	auto_install = true,
})

-- Update parsers when nvim-treesitter updates
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and (kind == "update" or kind == "install") then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})
-- Luasnip
vim.pack.add({ "https://github.com/L3MON4D3/LuaSnip", "https://github.com/rafamadriz/friendly-snippets" })
require("luasnip.loaders.from_vscode").lazy_load()
-- Lazydev
vim.pack.add({ "https://github.com/folke/lazydev.nvim" })
require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})
-- Blink (Autocomplete)
vim.pack.add({ "https://github.com/saghen/blink.cmp" })
require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 500 },
	},
	sources = {
		default = { "lsp", "path", "snippets", "lazydev" },
		providers = {
			lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
		},
	},
	snippets = { preset = "luasnip" },
	fuzzy = { implementation = "lua" },
	signature = { enabled = true },
})
-- LSP
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

local lsp_servers = {
	ty = {},
	clangd = {},
	lua_ls = {},
	vtsls = {
		settings = {
			vtsls = {
				tsserver = {
					globalPlugins = {
						{
							name = "@vue/typescript-plugin",
							location = vim.fn.stdpath("data")
								.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
							languages = { "vue" },
							configNamespace = "typescript",
						},
					},
				},
			},
		},
		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	},
	vue_ls = {},
}

local formatters = {
	"stylua",
	"ruff",
	"clang-format",
	"prettierd",
}

local ensure_installed = vim.tbl_keys(lsp_servers)
vim.list_extend(ensure_installed, formatters)

require("mason").setup()
require("mason-lspconfig").setup({})
require("mason-tool-installer").setup({
	ensure_installed = ensure_installed,
})
for server, config in pairs(lsp_servers) do
	config["on_attach"] = function(_, bufnr)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		-- LSP Keybinds
		map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
		map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
		map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
		map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
		map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
	end
	vim.lsp.config(server, config)
end

vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
	},
})

-- Conform
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
require("conform").setup({
	notify_on_error = false,
	format_on_save = function()
		return {
			timeout_ms = 250,
			lsp_format = "fallback",
		}
	end,
	formatters_by_ft = {
		python = { "ruff_format" },
		c = { "clang_format" },
		lua = { "stylua" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
	formatters = {
		clang_format = {
			prepend_args = { "--style=file", "--fallback-style=LLVM" },
		},
	},
})
-- Fidget
vim.pack.add({ "https://github.com/j-hui/fidget.nvim" })
require("fidget").setup({
	notification = {
		window = {
			winblend = 0,
		},
	},
})
-- Telescope
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "telescope-fzf-native.nvim" and (kind == "update" or kind == "install") then
			vim.system({ "make" }, { cwd = ev.data.path })
		end
	end,
})

vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
})

require("telescope").setup({
	pickers = {
		colorscheme = {
			enable_preview = true,
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
		["fzf"] = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader>sc", builtin.colorscheme, { desc = "[S]earch [C]olorschemes" })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
-- Which Key
vim.pack.add({ "https://github.com/folke/which-key.nvim" })

require("which-key").setup({
	delay = 0,
	spec = {
		{ "<leader>s", group = "[S]earch" },
	},
})
-- Oil
vim.pack.add({ "https://github.com/stevearc/oil.nvim" })
require("oil").setup({
	view_options = { show_hidden = true },
})
vim.keymap.set("n", "<leader>o", "<cmd>Oil<cr>", { desc = "Open [O]il" })
-- Mini
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })
require("mini.ai").setup({ n_lines = 500 })

local statusline = require("mini.statusline")
statusline.setup({ use_icons = vim.g.have_nerd_font })

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
	return "%2l:%-2v"
end
-- Autopairs
vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })
require("nvim-autopairs").setup({})
-- Indent Blankline
vim.pack.add({ "https://github.com/lukas-reineke/indent-blankline.nvim" })
require("ibl").setup({})
-- Gitsigns
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})
-- Arrow
vim.pack.add({ "https://github.com/otavioschwanck/arrow.nvim" })
require("arrow").setup({
	show_icons = true,
	leader_key = ";",
	buffer_leader_key = "m",
})
-- Rustacean
vim.pack.add({ "https://github.com/mrcjkb/rustaceanvim" })
