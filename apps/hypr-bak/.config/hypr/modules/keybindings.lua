return function(settings)
	local mainMod = settings.mainMod

	hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(settings.terminal))
	hl.bind(mainMod .. " + Q", hl.dsp.window.close())
	hl.bind(
		mainMod .. " + M",
		hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit")
	)
	hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(settings.fileManager))
	hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
	hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(settings.menu))

	-- Move focus between adjacent windows.
	for key, direction in pairs({
		left = "left",
		right = "right",
		up = "up",
		down = "down",
	}) do
		hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
	end

	hl.bind(mainMod .. " + V", hl.dsp.exec_cmd('cliphist list | rofi -dmenu -i -p "Clipboard" | cliphist decode | wl-copy'))
	-- Original alternative (commented out): cliphist list | rofi -dmenu | cliphist delete
	hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("~/.local/bin/snippet-manager.sh"))

	hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))
	hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
	hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("~/projects/linux-apps/todo/todo-popup"))
	hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("/home/arch_Kang/projects/hermes/scripts/hermes-popup"))

	-- Switch to workspaces 1-9; SHIFT moves the active window there.
	for i = 1, 9 do
		hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
		hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
	end

	-- Swap window positions with adjacent tiles.
	for key, direction in pairs({
		left = "left",
		right = "right",
		up = "up",
		down = "down",
	}) do
		hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.swap({ direction = direction }))
	end

	-- Left-click and drag to move; right-click and drag to resize.
	hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
	hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

	-- Laptop brightness keys (repeat while held).
	hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { repeating = true })
	hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })

	hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("~/.local/bin/sys-power"))
	hl.bind(mainMod .. " + P", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
end
