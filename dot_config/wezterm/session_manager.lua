local wezterm = require("wezterm")
local wezterm_session_manager = {}
local search_path = ""
wezterm_session_manager.apply_to_config = function(_, project_path)
	search_path = project_path:gsub("\\", "/") .. "/"
end

wezterm.on("wezterm_session_manager_show", function(window, pane)
	local sucess, stdout, _ = wezterm.run_child_process({ "fd", "-t", "d", ".*", search_path })
	if not sucess then
		return
	end
	local dirs = {}
	for i, line in ipairs(wezterm.split_by_newlines(stdout)) do
		local path = line:gsub("\\", "/")
		dirs[i] = { label = path:gsub("^" .. search_path, ""), id = path }
	end
	window:perform_action(
		wezterm.action.InputSelector({
			title = "Wezterm Session Manager",
			action = wezterm.action_callback(function(_, _, id, label)
				if id == nil then
					return
				end
				-- local folder_name = label:match("([^/]+)/?$")

				window:perform_action(wezterm.action.SwitchToWorkspace({ name = id, spawn = { cwd = id } }), pane)
			end),
			choices = dirs,
			fuzzy = true,
		}),
		pane
	)
end)

wezterm.on("wezterm_session_manager_create_project", function(window, pane)
	window:perform_action(
		wezterm.action.PromptInputLine({
			description = "Create new project",
			action = wezterm.action_callback(function(window, pane, line)
				if line == "" then
					return
				end
				local folder_path = search_path .. "/" .. line
				if package.config:sub(1, 1) == "\\" then
					-- Windows: pass as argument table, no shell quoting needed
					local win_path = folder_path:gsub("/", "\\")
					wezterm.background_child_process({ "cmd.exe", "/c", "mkdir", win_path })
				else
					-- Unix/macOS
					wezterm.background_child_process({ "mkdir", "-p", folder_path })
				end
			end),
		}),
		pane
	)
end)

wezterm_session_manager.Show = wezterm.action.EmitEvent("wezterm_session_manager_show")
wezterm_session_manager.CreateProject = wezterm.action.EmitEvent("wezterm_session_manager_create_project")

return wezterm_session_manager
