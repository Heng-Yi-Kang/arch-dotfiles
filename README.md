# Dotfiles

Personal Linux desktop configuration for Hyprland and related applications, with a shared Tokyo Night color palette and generated application styling.

## Repository map

| Path | Purpose |
| --- | --- |
| `apps/` | Application behavior and configuration, arranged as GNU Stow packages where applicable. Includes Waybar, SwayNC, Kitty, Starship, and Hyprland. |
| `apps/hypr-dev/` | Development Hyprland configuration. Test changes here rather than in the live config. |
| `apps/hypr/` | Live Hyprland configuration; treat as deployment output, not a development area. |
| `apps/hypr-bak/` | Existing and deployment-created Hyprland backups. |
| `themes/palettes/` | Shared source palettes; currently `tokyo-night.toml`. |
| `themes/templates/` | Canonical Jinja2 templates for generated application styling. |
| `themes/generator/` | Python scripts that render the palette and templates into application files. Starship's source config is `apps/starship/config.toml`. |
| `generated/` | Rendered files consumed by app configs. This directory is Git-ignored; do not edit its contents by hand. |
| `scripts/` | Hyprland validation, deployment, and rollback helpers. |
| `Makefile` | Convenience targets, including Hyprland validation and deployment workflows. |

For contributor rules and the full color conventions, see [`AGENTS.md`](AGENTS.md).

## Theme workflow

The palette is the source of truth for shared semantic colors. When changing application appearance, update the palette and/or canonical template, then regenerate the outputs. Keep application behavior in `apps/` separate from shared styling, and do not hardcode a second set of shared colors in app configs.

The generators require Python 3.11+ and Jinja2. Use the repository virtual environment when available:

```sh
.venv/bin/python -m pip install Jinja2  # if Jinja2 is not already installed
for generator in themes/generator/generate_*.py; do
  .venv/bin/python "$generator"
done
```

To render only one application's output, run its corresponding script, for example:

```sh
.venv/bin/python themes/generator/generate_waybar.py
```

Generated styles are ignored by Git, so regenerate them after cloning or changing their source before using configurations that import them. Some app configurations currently refer to this checkout using the absolute path `/home/arch_Kang/dotfiles`; adjust those references if the repository lives elsewhere.

## Hyprland development and deployment

The development entry point is `apps/hypr-dev/.config/hypr/hyprland.lua`. Its `default.lua` is a backup/reference file; make changes in the entry point and relevant files under `modules/`. The development module loads are deliberately conservative.

Useful commands from the repository root:

```sh
make hypr-colors    # generate the palette-backed Hyprland color module
make hypr-validate  # generate colors and check Lua and shell syntax
make hypr-preview   # validate and show a dry-run dev-to-live sync
```

Validation is static: it does not start or reload Hyprland, nor prove compositor behavior. For safer behavior testing, follow the temporary-copy nested-session guidance in [`apps/hypr-dev/README.md`](apps/hypr-dev/README.md); do not run the dev config unchanged because its autostart module can affect the current session.

Deployment and rollback change the live configuration and reload Hyprland. Before either, review [`apps/hypr-dev/DEPLOY.md`](apps/hypr-dev/DEPLOY.md), test the proposed configuration, and obtain explicit confirmation. The commands also require typing `DEPLOY` or `ROLLBACK` in a terminal:

```sh
make hypr-deploy
make hypr-rollback
```

Never develop in `apps/hypr/` or deploy just to test. Deployment snapshots are stored under `apps/hypr-bak/`.

## Installation notes

GNU Stow is used by the Makefile to manage application links, but inspect the package list and target paths before using its install targets. At present, the Makefile references `apps/bash/` and `themes/wallust/`, which are not present in this checkout; some other convenience targets also refer to scripts that are not present. The live Hyprland package should not be stowed or changed as a substitute for the documented development/deployment workflow. Review `Makefile` and the app-specific configuration paths for your machine before installing.
