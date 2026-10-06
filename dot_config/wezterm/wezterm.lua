local wezterm = require("wezterm") ---@type Wezterm
local config = wezterm.config_builder() ---@type Config

local wezterm_session_manager = require("session_manager")

wezterm_session_manager.apply_to_config(config, os.getenv("WEZTERM_PROJECTS_PATH"))
config.max_fps = 180
config.webgpu_power_preference = "HighPerformance"

config.default_prog = { "powershell.exe", "-nologo" }
config.window_decorations = "RESIZE"

local wallpaper_name = "a_road_with_trees_in_the_background.jpg"
local default_background = {
	{
		source = { File = wezterm.home_dir .. "/.config/wallpapers/" .. wallpaper_name },
		vertical_align = "Middle",
		horizontal_align = "Center",
	},
	{
		source = { Color = "050505E9" },
		height = "120%",
		width = "120%",
		vertical_offset = "-10%",
		horizontal_offset = "-10%",
	},
}
config.background = default_background

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.font_size = 15

config.color_scheme = "Default Dark (base16)"
config.colors = {
	tab_bar = { background = "rgba(0,0,0,0)" },
}
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_max_width = 25
config.hide_tab_bar_if_only_one_tab = true
config.window_content_alignment = {
	horizontal = "Center",
	vertical = "Center",
}

local active_color = wezterm.color.get_builtin_schemes()[config.color_scheme]["cursor_bg"]
wezterm.on("format-tab-title", function(tab)
	local title = ""
	local background = "none"
	local foreground = "#808080"
	local text = "[" .. tab.tab_index + 1 .. "]" .. title
	if tab.is_active then
		foreground = active_color
		text = text
	end
	-- text = " " .. text .. " "
	-- if #text >= config.tab_max_width then
	-- 	text = wezterm.truncate_right(text, config.tab_max_width - 4) .. "... "
	-- end
	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = text },
	}
end)

local act = wezterm.action
config.keys = {
	{
		key = "g",
		mods = "ALT",
		action = wezterm_session_manager.Show,
	},
	{
		key = "p",
		mods = "ALT",
		action = wezterm_session_manager.CreateProject,
	},
	{
		key = "n",
		mods = "ALT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = "ALT",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "h",
		mods = "ALT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "j",
		mods = "ALT",
		action = act.ActivatePaneDirection("Next"),
	},
	{
		key = "k",
		mods = "ALT",
		action = act.ActivatePaneDirection("Prev"),
	},
}
for num = 1, 9 do
	table.insert(config.keys, {
		key = tostring(num),
		mods = "ALT",
		action = act.ActivateTab(num - 1),
	})
end
return config
