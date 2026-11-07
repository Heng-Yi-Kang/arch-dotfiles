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
- `themes/wallust/templates/` contains application-specific templates.
- `themes/wallust/wallust.toml` defines Wallust generation.
- `generated/` contains generated application color files.
- Generated files must not be manually edited.

## Color conventions

Use semantic color names consistently:

- background
- foreground
- surface
- surface-alt
- accent
- accent-alt
- border
- muted
- success
- warning
- error

When adding an application, map its native color variables
to the shared semantic color definitions.

## Application configurations

- `apps/` contains source configurations.
- Keep application behavior separate from appearance.
- Do not duplicate shared colors.
- Do not modify unrelated application settings when
  working on a specific application.

## Change management

When modifying a theme:

1. Update the source palette or theme definition.
2. Update relevant Wallust templates.
3. Regenerate affected application color files.
4. Verify all applications use the new colors.

When modifying an application:

1. Inspect its existing configuration.
2. Preserve existing functionality.
3. Reuse shared theme variables.
4. Avoid introducing independent color definitions.

## Generated files

- Never edit generated files directly.
- Regenerate them through the theme scripts.
- Keep generated files out of Git unless explicitly needed
  for reproducible testing.
