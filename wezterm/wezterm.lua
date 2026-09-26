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

-- Ctrl+h/j/k/l: 在 WezTerm pane 之間移動焦點。
-- 但如果目前 pane 前景程式是 (n)vim，就把按鍵原樣送進去，
-- 讓 nvim 自己用 <C-w>hjkl 在 split 之間切換 (同 tmux 的 is_vim 做法)。
local function is_vim(pane)
  local proc = pane:get_foreground_process_name()
  if not proc then return false end
  local base = proc:lower():gsub('\\', '/'):match('([^/]+)$') or ''
  return base:match('^n?vim') ~= nil
end

for key, direction in pairs {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
} do
  table.insert(config.keys, {
    key = key,
    mods = 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        win:perform_action(act.SendKey { key = key, mods = 'CTRL' }, pane)
      else
        win:perform_action(act.ActivatePaneDirection(direction), pane)
      end
    end),
  })
end

-- Finally, return the configuration to wezterm:
return config
