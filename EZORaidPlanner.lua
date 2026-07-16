-- EZORaidPlanner bootstrap
-- Early development scaffold. Core wiring lives in modules/core.lua.

EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.name = "EZORaidPlanner"
EZORaidPlanner.version = "0.0.1"

local function OnAddOnLoaded(_, addonName)
    if addonName ~= EZORaidPlanner.name then
        return
    end
    EVENT_MANAGER:UnregisterForEvent(EZORaidPlanner.name, EVENT_ADD_ON_LOADED)

    EZORaidPlanner_Saved = EZORaidPlanner_Saved or {}
    EZORaidPlanner.saved = EZORaidPlanner_Saved

    if EZORaidPlanner.Core and EZORaidPlanner.Core.Initialize then
        EZORaidPlanner.Core.Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(EZORaidPlanner.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
