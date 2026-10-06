vim.pack.add({
	"https://github.com/sainnhe/gruvbox-material",
})
vim.g.gruvbox_material_foreground = "mix"
vim.g.gruvbox_material_transparent_background = true

local path = vim.fn.stdpath("data") .. "/saved_colorscheme.txt"
local function save_colorscheme(colorscheme)
	vim.fn.writefile({ colorscheme }, path)
end

local function get_saved_colorscheme()
	if vim.fn.filereadable(path) == 0 then
		save_colorscheme("catppuccin")
	end

	return vim.fn.readfile(path)[1]
end

vim.keymap.set("n", "<leader>cs", function()
	local colorscheme_name = vim.fn.input("Save colorscheme: ", vim.g.colors_name)
	save_colorscheme(colorscheme_name)
end, { desc = "[S]ave loaded colorscheme" })

local saved_colorscheme = get_saved_colorscheme()

if not pcall(vim.cmd.colorscheme, saved_colorscheme) then
	vim.cmd.colorscheme("catppuccin")
	save_colorscheme("catppuccin")
	print(string.format("Saved colorscheme (%s) doesn't exist, swapping to catppuccin.", saved_colorscheme))
end
