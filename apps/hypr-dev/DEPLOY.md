# Deploying the Hyprland development configuration

This guide is the deployment checklist for `apps/hypr-dev/`. Keep the live
configuration in `apps/hypr/` untouched until the development configuration has
been reviewed and tested.

## Prepare the module loads

Before deployment, inspect
[`.config/hypr/hyprland.lua`](.config/hypr/hyprland.lua) and every Lua module in
[`.config/hypr/modules/`](.config/hypr/modules/). The entry point deliberately
leaves some module loads commented out.

When asked to prepare the configuration for deployment, the agent must:

1. Read the entry point and all module files. Determine what each module does,
   identify dependencies and side effects, and note machine-specific settings.
2. Tell the user which commented `require("modules...")()` lines it proposes to
   enable, including any modules it recommends leaving disabled, and why.
3. **Ask the user for explicit confirmation before uncommenting any module
   loads.** Do not edit `hyprland.lua` until the user confirms the proposed set.
   Do not assume that every module should be enabled just because it exists.
4. After confirmation, enable only the agreed module loads and preserve their
   order. Review the resulting diff and run the validation steps below.

[`modules/autostart.lua`](.config/hypr/modules/autostart.lua) currently starts
Waybar, swaybg, swaync, text and image clipboard watchers, the battery monitor,
and Fcitx. It also imports Wayland session variables into the user's systemd and
D-Bus activation environments. The swaybg wallpaper path is machine-specific;
the clipboard watchers require `wl-paste` and `cliphist`, and the battery
monitor requires the battery sysfs entries and `notify-send`. Verify these
commands and their effects for the target live session before deployment. The
`swww-daemon` and `dunst` mention is an alternatives note, not an enabled
startup command. For nested-session testing, keep autostart disabled or isolate
its side effects in a temporary copy; refer to [the development README](README.md#test-this-config-without-replacing-the-live-session).

Do not edit `apps/hypr/` as part of this preparation. Module review and edits to
the development configuration are separate from deployment. The deployment
script's `DEPLOY` prompt is an additional safeguard and does not replace the
agent's requirement to obtain confirmation before changing module loads.

## Validate and deploy

From the repository root:

1. Run `make hypr-validate` to generate the palette module and check Lua and
   shell syntax. This does not alter the live configuration. `make hypr-colors`
   is also available to regenerate palette colors by itself.
2. Run `make hypr-preview` to validate and preview the proposed file sync. Review
   the output carefully.
3. Complete nested-session testing and review the final diff before deployment.
4. Only after the user has confirmed deployment, run `make hypr-deploy`.
   `scripts/hypr-deploy` previews the sync, asks you to type `DEPLOY`, saves the
   current `apps/hypr/` tree in a new timestamped
   `apps/hypr-bak/deploy-*/` directory (preserving existing backups), syncs the
   development tree into the live tree, and runs `hyprctl reload`.

If a rollback is needed, `make hypr-rollback` previews restoring the latest
deployment snapshot, asks you to type `ROLLBACK`, restores it, and reloads
Hyprland. Both deployment and rollback require a terminal for confirmation and
cancel if confirmation is unavailable or does not exactly match. Do not run
either mutating target without the relevant explicit user confirmation.
