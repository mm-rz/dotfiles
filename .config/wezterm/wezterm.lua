-- https://wezterm.org/config/files.html#configuration-files

-- require 'japanese'

local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Linux の要領で起動できるようにする 
-- config.default_prog = {"wsl.exe", "--distribution", "Ubuntu-22.04", "--cd", "~"}
-- colors

local appearance_themes = {
    Light = 'Earthsong (Gogh)',
    Dark = 'Ayu Mirage (Gogh)',
}

local appearance = wezterm.gui.get_appearance()
config.color_scheme = appearance_themes[appearance] or dark_theme

-- mouse cursor

config.hide_mouse_cursor_when_typing = true


-- font
config.font = wezterm.font("CaskaydiaMono Nerd Font")
config.font_size = 14.0

-- タイトルバーを消して、枠だけ残す
config.window_decorations="RESIZE"

-- 透明化
config.window_background_opacity=0.85
config.macos_window_background_blur=20

-- タブが 1 つだけならタブバーを隠す
config.hide_tab_bar_if_only_one_tab=true

-- keybinds
local act = wezterm.action
config.keys = {
    -- Alt(Opt)+Shift+Fでフルスクリーン切り替え
    { key = 'f', mods = 'SHIFT|META', action = act.ToggleFullScreen, },
    -- ウインドウ移動
    { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
    -- Ctrl+Shift+A,Qで新しいペインを作成(画面を分割)
    {key = 'a', mods = 'META', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
    {key = 'q', mods = 'META', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }, },
    {key = 'z', mods = 'META', action = wezterm.action.CloseCurrentPane {confirm = false, }, },
    { key = "h", mods = "META", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "META", action = act.ActivatePaneDirection("Right") },
    { key = "j", mods = "META", action = act.ActivatePaneDirection("Up") },
    { key = "k", mods = "META", action = act.ActivatePaneDirection("Down") },
    { key = "H", mods = "META", action = act.AdjustPaneSize{"Left", 10} },
    { key = "L", mods = "META", action = act.AdjustPaneSize{"Right", 10} },
    { key = "J", mods = "META", action = act.AdjustPaneSize{"Up", 5} },
    { key = "K", mods = "META", action = act.AdjustPaneSize{"Down", 5} },
    -- Ctrl+C, Ctrl+Shift+C, Ctrl+V, Ctrl+Shift+V
    {
        key = "c",
        mods = "CTRL",
        action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane) ~= ""
            if has_selection then
                window:perform_action(
                wezterm.action{CopyTo="ClipboardAndPrimarySelection"},
                pane
            )
            window:perform_action("ClearSelection", pane)
            else
            window:perform_action(
                wezterm.action{SendKey={key="c", mods="CTRL"}},
                pane
            )
            end
        end)
    },
    {
    key = "c",
    mods = "CTRL|SHIFT",
    action = act.CopyTo("Clipboard"),
  },
  {
    key = "v",
    mods = "CTRL|SHIFT",
    action = act.PasteFrom("Clipboard"),
  },
}

return config
