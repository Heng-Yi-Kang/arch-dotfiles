# Dotfiles Architecture

## General principles

- Keep application configurations modular.
- All desktop applications must share one color system.
- Never hardcode theme colors inside application configs.
- Never manually edit generated configuration files.
- Keep application behavior separate from visual styling.
- Prefer small, focused changes over rewriting entire configurations.

## Theme management

- `themes/palettes/` contains source color schemes.
- `themes/templates/` contains the canonical Jinja2 source templates for application styling.
- `themes/generator/` contains scripts that render templates using the palettes.
- `generated/` contains rendered application files; never edit these outputs manually.
- Application stylesheets in `apps/` may import their corresponding generated files.

## Color conventions

Use semantic color names consistently:

- background
- foreground
- surface
- surface_alt
- accent
- accent_alt
- border
- muted
- success
- warning
- error

When adding an application, map its native color variables
to the shared semantic color definitions.

## Application configurations

- `apps/` contains application behavior/configuration and app-facing imports of generated styling.
- Keep application behavior separate from appearance; author shared styling in `themes/templates/`.
- Do not duplicate shared colors or maintain a second editable copy of a generated stylesheet.
- Do not modify unrelated application settings when
  working on a specific application.

## Change management

When modifying a theme:

1. Update the source palette or theme definition as needed.
2. Update the canonical application template(s) in `themes/templates/`.
3. Regenerate affected application files with the corresponding script in `themes/generator/`.
4. Ensure app-facing imports in `apps/` resolve to the generated outputs and verify the applications use the new colors.

When modifying an application:

1. Inspect its existing configuration.
2. Preserve existing functionality.
3. Reuse shared theme variables.
4. Avoid introducing independent color definitions.

## Generated files

- Never edit generated files directly.
- Regenerate them through the theme scripts before installing or using app-facing imports.
- Keep generated files out of Git unless explicitly needed
  for reproducible testing.
