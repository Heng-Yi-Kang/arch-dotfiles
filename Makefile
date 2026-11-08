PACKAGES = hypr waybar swaync kitty bash
THEME ?= tokyo-night

HYPR_DEV = apps/hypr-dev/.config/hypr
HYPR_LIVE = apps/hypr/.config/hypr

.PHONY: install uninstall restow preview theme reload validate hypr-colors hypr-validate hypr-preview hypr-deploy hypr-rollback waybar-reload swaync-reload

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
	./scripts/theme-switch "$(THEME)"

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

# Static checks only; this does not start or reload Hyprland.
hypr-validate:
	./scripts/hypr-validate

# Show the changes that deployment would make without writing to the live config.
hypr-preview: hypr-validate
	rsync -ain --delete $(HYPR_DEV)/ $(HYPR_LIVE)/

# Scripts require typing DEPLOY or ROLLBACK before changing the live config.
hypr-deploy:
	./scripts/hypr-deploy

hypr-rollback:
	./scripts/hypr-rollback

waybar-reload:
	pkill -SIGUSR2 waybar

swaync-reload:
	swaync-client -R -rs
