vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/AlexvZyl/nordic.nvim",
	"https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/ellisonleao/gruvbox.nvim",
	"https://github.com/shatur/neovim-ayu",
	"https://github.com/WTFox/jellybeans.nvim",
})

require("gruvbox").setup({ transparent_mode = true })
require("jellybeans").setup({ transparent = true })

local path = vim.fn.stdpath("data") .. "/saved_colorscheme.txt"
local function save_colorscheme(colorscheme)
	vim.fn.writefile({ colorscheme }, path)
end

local function get_saved_colorscheme()
	if vim.fn.filereadable(path) == 0 then
		save_colorscheme("tokyonight")
	end

	return vim.fn.readfile(path)[1]
end

vim.keymap.set("n", "<leader>cs", function()
	local colorscheme_name = vim.fn.input("Save colorscheme: ", vim.g.colors_name)
	save_colorscheme(colorscheme_name)
end, { desc = "Save loaded colorscheme" })

local saved_colorscheme = get_saved_colorscheme()

if not pcall(vim.cmd.colorscheme, saved_colorscheme) then
	vim.cmd.colorscheme("tokyonight")
	save_colorscheme("tokyonight")
	print(string.format("Saved colorscheme (%s) doesn't exist, swapping to tokyonight.", saved_colorscheme))
end
