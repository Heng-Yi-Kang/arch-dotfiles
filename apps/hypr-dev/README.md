# Hyprland development configuration: emergency recovery

This note documents Hyprland's emergency keybindings and recovery options for this development configuration. It is intended to help recover from a bad live reload without treating the emergency bindings as a substitute for testing changes first.

## Hyprland's built-in emergency binds

In current upstream Hyprland's Lua configuration implementation, emergency mode is triggered when a configuration reload has errors **and no keybinds have been registered**. Hyprland then installs built-in recovery binds:

| Binding | Action |
| --- | --- |
| `SUPER + Q` | Launch a recognized terminal, if one is available |
| `SUPER + R` | Launch `hyprland-run` |
| `SUPER + M` | Exit Hyprland |

This behavior is implemented in [Hyprland's Lua config manager](https://github.com/hyprwm/Hyprland/blob/main/src/config/lua/ConfigManager.cpp). These are compositor-provided fallback binds: there is no user configuration setting in that implementation to rename, replace, or add to this emergency set. Check the source for the installed Hyprland version if relying on the exact behavior; it may differ between releases and configuration backends.

**Important limitation:** the fallback is conditional on *zero* binds being registered. If a broken reload leaves any bind registered, the emergency set is not installed. In that case, any successfully loaded normal binds may still help, but don't assume the built-in recovery bindings will be available.

There have also been reports of `SUPER + Q` failing to launch a terminal on a Hyprland 0.56.2 setup. Treat that bind as a convenience rather than the only recovery path; `SUPER + R` or an independent route is preferable. See the [upstream discussion](https://github.com/hyprwm/Hyprland/discussions/16678).

## If a reload leaves you without usable binds

1. Try `SUPER + R` and use the runner to open a terminal.
2. Restore or repair the configuration file that Hyprland actually loads. Keep a known-good backup outside files that are being edited.
3. Reload the repaired configuration from the terminal:

   ```sh
   hyprctl reload
   ```

   For example, after adjusting the paths and filenames to match your setup:

   ```sh
   cp ~/.config/hypr/hyprland.lua.bak ~/.config/hypr/hyprland.lua
   hyprctl reload
   ```

4. If no emergency bind works, use an independent recovery route such as a text console or SSH to repair the file, then return to the graphical session and reload Hyprland. Avoid relying on a bind defined only in the broken configuration as your sole recovery mechanism.

The [Hyprland binds documentation](https://wiki.hypr.land/Configuring/Binds/) describes regular configured binds. The [`hyprctl` documentation](https://wiki.hypr.land/Configuring/Using-hyprctl/) covers controlling a running compositor, including dynamic configuration operations.

## Palette-backed color tokens

Hyprland's dev config consumes the shared semantic palette through a generated
Lua module. Before testing or stowing this config, run `make hypr-colors` (or
`python3 themes/generator/generate_hypr.py`). This renders
`generated/hypr/colors.lua` from `themes/palettes/tokyo-night.toml` using
`themes/templates/hypr-colors.lua.j2`. `.config/hypr/modules/colors.lua`
requires that generated module by its absolute path so it works when deployed
through the `~/.config` symlink; do not edit the generated output file directly.

`modules/appearance.lua` maps those tokens to Hyprland's color syntax and sets
per-use opacity. Keep these compositor-specific choices there; change the
shared hues in the palette, not in the generated module or another application
config.

## Configuration source of truth

- **Do not edit `.config/hypr/default.lua`.** It is kept only as a backup and reference.
- The configuration to test is `.config/hypr/hyprland.lua`, which is the modular entry point. Make behavior and appearance changes in the appropriate files under `.config/hypr/modules/`, then load the module from `hyprland.lua` when testing it.

## Recommendations for this directory

- Keep experiments in `apps/hypr-dev/`; do not use `apps/hypr/` as a test area.
- Keep a known-good copy of the active config before deploying a change.
- Validate Lua syntax before reloading. The local `apps/hypr-dev/.config/hypr/scripts/validate.sh` checks Lua files with `luac -p`; this catches syntax errors, but does **not** validate Hyprland-specific configuration behavior or guarantee that a reload will register all binds.
- Consider defining a small, simple recovery set early in the Lua startup sequence, before modules that are more likely to fail. These are ordinary configured keybinds, not Hyprland's emergency binds. Their usefulness depends on Hyprland successfully loading that part of the config, so retain an independent recovery route as well.
- Keep recovery actions conservative and easy to remember. In particular, `SUPER + M` exits Hyprland in the built-in emergency set; avoid assigning it a conflicting expectation.

## Deployment

Deployment preparation, module-load review, required user confirmation, validation,
backup, deployment, and rollback instructions are maintained in
[`DEPLOY.md`](DEPLOY.md). Follow that checklist before syncing this development
configuration into the live `apps/hypr/` tree.

## Test this config without replacing the live session

The safest way to test configuration behavior is to start a **nested Hyprland session** in a window inside your current Hyprland desktop. Hyprland's [Contributing and Debugging guide](https://wiki.hypr.land/Contributing-and-Debugging/) recommends this approach for development: the nested compositor can be tested without logging out of or replacing the live session.

Hyprland accepts an explicit config path with `--config` (see [upstream argument handling](https://github.com/hyprwm/Hyprland/blob/main/src/main.cpp)). For this Lua config, use the path to `hyprland.lua`.

**Do not launch this dev config unchanged for a nested test.** Its [`modules/autostart.lua`](.config/hypr/modules/autostart.lua) starts desktop services and imports session variables into the user's systemd and D-Bus environments. Those side effects can affect the live session even though the second compositor is nested.

Recommended workflow:

1. From the repository root, make a temporary copy of the development config tree. Keeping the module directory structure lets the entry-point Lua file continue loading its modules:

   ```sh
   test_root="$(mktemp -d)"
   cp -a apps/hypr-dev/.config/hypr "$test_root/"
   ```

2. In the temporary copy only, uncomment **only the module you intend to test**, plus any modules it explicitly depends on. Leave unrelated modules commented. Keep `modules/autostart.lua` disabled unless autostart itself is the test target and you have first removed or isolated its side effects. In particular, do not import the nested session's `WAYLAND_DISPLAY` or `HYPRLAND_INSTANCE_SIGNATURE` into the shared systemd/D-Bus environment.
3. From a terminal inside the live Hyprland session, launch the copied config:

   ```sh
   Hyprland --config "$test_root/hypr/hyprland.lua"
   ```

   The nested compositor should open in a window. Test there, then exit that nested session normally. The original compositor remains active.
4. The development config currently sets `mainMod` to `Mod1` (Alt). If that conflicts with your live bindings during nested testing, change the modifier in the temporary copy.

You can point `--config` directly at `apps/hypr-dev/.config/hypr/hyprland.lua`, but only after disabling or isolating its autostart behavior. A temporary copy is safer because test-specific edits then cannot accidentally alter the tracked dev config or live config.

## Sources

- [Hyprland upstream Lua config manager](https://github.com/hyprwm/Hyprland/blob/main/src/config/lua/ConfigManager.cpp) — condition for emergency mode and emergency-bind notice.
- [Hyprland binds documentation](https://wiki.hypr.land/Configuring/Binds/) — regular configured binds.
- [Hyprland `hyprctl` documentation](https://wiki.hypr.land/Configuring/Using-hyprctl/) — runtime compositor control.
- [Hyprland discussion: emergency `SUPER + Q` terminal launch issue](https://github.com/hyprwm/Hyprland/discussions/16678) — version/setup-specific caveat.
