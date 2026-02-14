return {
	"folke/lazydev.nvim",
	ft = "lua",
	dependencies = {
		"DrKJeff16/wezterm-types",
		lazy = true,
	},
	opts = {
		library = {
			{ path = "wezterm-types", mods = { "wezterm" } },
			-- Load luvit types when the `vim.uv` word is found
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}
