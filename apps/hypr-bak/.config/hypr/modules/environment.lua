return function()
	hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
	hl.env("XDG_SESSION_TYPE", "wayland")
	hl.env("XDG_SESSION_DESKTOP", "Hyprland")
	hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

	-- Input method configuration
	hl.env("QT_IM_MODULE", "fcitx")
	hl.env("XMODIFIERS", "@im=fcitx")
	hl.env("SDL_IM_MODULE", "fcitx")
	hl.env("INPUT_METHOD", "fcitx")
end
