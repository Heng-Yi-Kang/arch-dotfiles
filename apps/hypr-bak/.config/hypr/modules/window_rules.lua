return function()
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
end
