EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.LAM = EZORaidPlanner.LAM or {}

-- Thin wrapper so other modules don't need to check for LibAddonMenu2
-- directly. Mirrors the pattern used by other EZO addons.
function EZORaidPlanner.LAM.IsAvailable()
    return LibAddonMenu2 ~= nil
end

function EZORaidPlanner.LAM.RegisterPanel(panelId, panelData)
    if not EZORaidPlanner.LAM.IsAvailable() then
        return nil
    end
    return LibAddonMenu2:RegisterAddonPanel(panelId, panelData)
end

function EZORaidPlanner.LAM.RegisterOptionControls(panelId, optionsTable)
    if not EZORaidPlanner.LAM.IsAvailable() then
        return
    end
    LibAddonMenu2:RegisterOptionControls(panelId, optionsTable)
end
