return {
	"eldritch-theme/eldritch.nvim",
	priority = 1000,
	config = function()
		require("eldritch").setup({
			transparent = true,
		})
	end,
}
