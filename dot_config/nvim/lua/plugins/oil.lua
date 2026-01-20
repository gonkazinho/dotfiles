return {
	"stevearc/oil.nvim",
	opts = {},
	config = function()
		require("oil").setup({
			vim.keymap.set("n", "<leader>o", "<cmd>Oil<cr>", { desc = "Open [O]il" }),
		})
	end,
	-- Optional dependencies
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
}
