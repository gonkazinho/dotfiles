return {
	"navarasu/onedark.nvim",
	priority = 1000,
	config = function()
		require("onedark").setup({
			style = "deep",
			transparent = true,
		})
		-- vim.cmd.colorscheme("onedark")
	end,
}
