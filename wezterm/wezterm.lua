-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
config.default_cwd = 'D:/Work'
config.default_prog = { 'powershell' }
config.window_padding = {
  left = 1,
  right = 1,
  top = 0,
  bottom = 0,
}

-- changing the initial geometry for new windows:
config.initial_cols = 90
config.initial_rows = 30

-- changing the font size and color scheme.
config.font = wezterm.font 'FiraCode Nerd Font Mono'
config.font_size = 12
config.color_scheme = 'catppuccin-macchiato'

-- Alt+1..Alt+9: focus tab 1..9
-- (WezTerm tab index is 0-based)
config.keys = {}
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })
end

table.insert(config.keys, {
  key = '%',
  mods = 'ALT|SHIFT',
  action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
})

table.insert(config.keys, {
  key = '"',
  mods = 'ALT|SHIFT',
  action = act.SplitVertical { domain = 'CurrentPaneDomain' },
})

for key, direction in pairs {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
} do
  table.insert(config.keys, {
    key = key,
    mods = 'CTRL',
    action = act.ActivatePaneDirection(direction),
  })
end

-- Finally, return the configuration to wezterm:
return config
