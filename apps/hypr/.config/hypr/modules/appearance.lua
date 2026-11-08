return function()
	local colors = require("modules.colors")

	local function with_alpha(color, alpha)
		return "rgba(" .. color:gsub("^#", "") .. string.format("%02x", alpha) .. ")"
	end

	hl.config({
		cursor = {
			-- Hyprland's current option is numeric: 1 disables hardware cursors.
			no_hardware_cursors = 1,
		},
		general = {
			gaps_in = 2,
			gaps_out = 5,
			border_size = 1,
			col = {
				active_border = {
					colors = {
						with_alpha(colors.accent, 0xee),
						with_alpha(colors.accent_alt, 0xee),
					},
					angle = 45,
				},
				inactive_border = with_alpha(colors.border, 0xaa),
			},
			layout = "dwindle",
		},
		decoration = {
			rounding = 0,
			rounding_power = 2.0,
			shadow = {
				enabled = false,
				range = 25,
				render_power = 4,
				color = with_alpha(colors.accent, 0x55),
				color_inactive = with_alpha(colors.background, 0x55),
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
end
