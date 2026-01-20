return {
	"ribru17/bamboo.nvim",
	priority = 1000,
	config = function()
		require("bamboo").setup({
			transparent = true,
		})
		-- vim.cmd.colorscheme("bamboo")
	end,
}
