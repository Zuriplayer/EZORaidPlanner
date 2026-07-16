EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.Menu = EZORaidPlanner.Menu or {}

function EZORaidPlanner.Menu.Initialize()
    if not EZORaidPlanner.LAM.IsAvailable() then
        return
    end

    local panelData = {
        type = "panel",
        name = EZORaidPlanner.i18n.Get("ADDON_NAME"),
        displayName = "EZO Raid Planner",
        author = "@Zuriplayer",
        version = EZORaidPlanner.version,
        registerForRefresh = true,
    }

    EZORaidPlanner.LAM.RegisterPanel("EZORaidPlanner_LAM", panelData)
    -- TODO: register controls once EventManager/PlayerSelector/Results
    -- settings are defined.
end
