return function()
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
end
