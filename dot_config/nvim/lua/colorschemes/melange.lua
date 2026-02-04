return {
	"savq/melange-nvim",
	priority = 1000,
	config = function()
		require("kanagawa").setup({})
		-- vim.cmd.colorscheme("melange")
	end,
}
