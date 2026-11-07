-- Standalone Lua translation of hyprland.conf.
-- This is named test.lua intentionally; it does not replace or activate the
-- existing hyprland.lua / hyprland.conf. Test with Hyprland's --config option
-- before deciding whether to install it as the active configuration.

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1.2,
})

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- Input method configuration
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("INPUT_METHOD", "fcitx")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	cursor = {
		-- Hyprland's current option is numeric: 1 disables hardware cursors.
		no_hardware_cursors = 1,
	},
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 3,
		col = {
			active_border = {
				colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
				angle = 45,
			},
			inactive_border = "rgba(595959aa)",
		},
		layout = "dwindle",
	},
	decoration = {
		rounding = 10,
		rounding_power = 2.0,
		shadow = {
			enabled = false,
			range = 25,
			render_power = 4,
			color = "rgba(6f00ff55)",
			color_inactive = "rgba(1a1a1a55)",
		},
		blur = {
			enabled = true,
			size = 6,
			passes = 2,
			new_optimizations = true,
		},
	},
	animations = {
		enabled = true,
	},
})

hl.curve("linear", {
	type = "bezier",
	points = { { 0.0, 0.0 }, { 1.0, 1.0 } },
})

---------------------
---- MY PROGRAMS ----
---------------------

local mainMod = "Mod1"
local terminal = "kitty"
local fileManager = "thunar"
local menu = "rofi -show drun"

-------------------
---- KEYBINDINGS ----
-------------------

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit")
)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))

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

------------------
---- RESIZE MAP ----
------------------

hl.define_submap("resize", function()
	local function resize(x, y)
		return hl.dsp.window.resize({ x = x, y = y, relative = true })
	end

	hl.bind("right", resize(20, 0), { repeating = true })
	hl.bind("left", resize(-20, 0), { repeating = true })
	hl.bind("up", resize(0, -20), { repeating = true })
	hl.bind("down", resize(0, 20), { repeating = true })

	hl.bind("SHIFT + right", resize(5, 0), { repeating = true })
	hl.bind("SHIFT + left", resize(-5, 0), { repeating = true })
	hl.bind("SHIFT + up", resize(0, -5), { repeating = true })
	hl.bind("SHIFT + down", resize(0, 5), { repeating = true })

	hl.bind("escape", hl.dsp.submap("reset"))
end)

----------------------------
---- MEDIA KEYBINDINGS ----
----------------------------

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), {
	locked = true,
	repeating = true,
})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), {
	locked = true,
	repeating = true,
})
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {
	locked = true,
})

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("waybar")
	-- Original commented alternatives: swww-daemon, dunst
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("swaybg -i /home/arch_Kang/Downloads/wallpaper.jpg -m fill")
	hl.exec_cmd("swaync")
	hl.exec_cmd("~/.config/hypr/scripts/battery-monitor.sh")
	hl.exec_cmd("fcitx5 -d")
	hl.exec_cmd(
		"systemctl --user import-environment WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP XDG_SESSION_TYPE"
	)
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP XDG_SESSION_TYPE"
	)
end)

--------------------------------------
---- WINDOWS AND WORKSPACES RULES ----
--------------------------------------

hl.window_rule({
	name = "todo-popup",
	match = { title = "^(todo)$" },
	float = true,
	size = "320 820",
	move = "onscreen 100%-340 40",
	pin = true,
})
hl.window_rule({
	name = "hermes-popup",
	match = { title = "^(hermes-popup)$" },
	float = true,
	size = "320 820",
	move = "onscreen 100%-340 40",
	pin = true,
})
