EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.Core = EZORaidPlanner.Core or {}

-- Central initialization point. Wires together events, player selection,
-- results tracking and the settings menu once saved vars are ready.
function EZORaidPlanner.Core.Initialize()
    if EZORaidPlanner.EventManager and EZORaidPlanner.EventManager.Initialize then
        EZORaidPlanner.EventManager.Initialize()
    end

    if EZORaidPlanner.PlayerSelector and EZORaidPlanner.PlayerSelector.Initialize then
        EZORaidPlanner.PlayerSelector.Initialize()
    end

    if EZORaidPlanner.Results and EZORaidPlanner.Results.Initialize then
        EZORaidPlanner.Results.Initialize()
    end

    if EZORaidPlanner.Menu and EZORaidPlanner.Menu.Initialize then
        EZORaidPlanner.Menu.Initialize()
    end
end
