-- Active Hyprland Lua configuration.
-- Configuration is split into modules by concern; keep their load order explicit.

local settings = require("settings")

require("modules.monitor")()
require("modules.environment")()
require("modules.appearance")()
require("modules.keybindings")(settings)
require("modules.resize")()
require("modules.media")()
require("modules.autostart")()
require("modules.window_rules")()
