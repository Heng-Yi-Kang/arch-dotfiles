PACKAGES = hypr waybar swaync kitty bash

.PHONY: install uninstall restow preview theme reload validate hypr-colors

install:
	stow -d apps -t ~ $(PACKAGES)
	stow -d themes -t ~ wallust

uninstall:
	stow -D -d apps -t ~ $(PACKAGES)
	stow -D -d themes -t ~ wallust

restow:
	stow -R -d apps -t ~ $(PACKAGES)
	stow -R -d themes -t ~ wallust

preview:
	stow -n -v -d apps -t ~ $(PACKAGES)

theme:
	./scripts/theme-switch

reload:
	./scripts/theme-reload

validate:
	./scripts/validate-configs

# Generate the Hyprland dev config's palette-backed Lua color module.
hypr-colors:
	@if [ -x .venv/bin/python ]; then \
		.venv/bin/python themes/generator/generate_hypr.py; \
	else \
		python3 themes/generator/generate_hypr.py; \
	fi
