return {default = {
		terminal = "alacritty",
		editor = os.getenv("EDITOR") or "nvim",
		browser = "vimb",
		file_manager = "vifm",
		notes = "joplin-desktop",
		launcher = "rofi -show drun -modi drun -theme ~/.config/rofi/themes/dmenu", 
	}, autostart = {
		"picom",
		"MEGAsync",
		"alacritty",
	}
}

