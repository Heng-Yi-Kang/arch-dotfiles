return function()
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
end
