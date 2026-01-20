return {
	"vague-theme/vague.nvim",
	priority = 1000,
	config = function()
		require("vague").setup({
			transparent = true,
		})
		vim.cmd.colorscheme("vague")
	end,
}
