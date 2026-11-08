return function()
	hl.on("hyprland.start", function()
		--		hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
		hl.exec_cmd("waybar")
		-- Original commented alternatives: swww-daemon, dunst
		--		hl.exec_cmd("wl-paste --type text --watch cliphist store")
		--		hl.exec_cmd("wl-paste --type image --watch cliphist store")
		hl.exec_cmd("swaybg -i /home/arch_Kang/Downloads/wallpaper.jpg -m fill")
		hl.exec_cmd("swaync")
		--		hl.exec_cmd("~/.config/hypr/scripts/battery-monitor.sh")
		--		hl.exec_cmd("fcitx5 -d")
		--		hl.exec_cmd(
		--			"systemctl --user import-environment WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP XDG_SESSION_TYPE"
		--		)
		--		hl.exec_cmd(
		--			"dbus-update-activation-environment --systemd WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP XDG_SESSION_TYPE"
		--		)
	end)
end
