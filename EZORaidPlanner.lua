-- EZORaidPlanner bootstrap
-- Early development scaffold. Core wiring lives in modules/core.lua.

EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.name = EZORaidPlanner.ADDON_NAME or "EZORaidPlanner"
EZORaidPlanner.version = EZORaidPlanner.ADDON_VERSION or "0.0.1"

local DEFAULTS = {
    events = {},
    nextEventId = 1,
}

local function OnAddOnLoaded(_, addonName)
    if addonName ~= EZORaidPlanner.name then
        return
    end
    EVENT_MANAGER:UnregisterForEvent(EZORaidPlanner.name, EVENT_ADD_ON_LOADED)

    EZORaidPlanner.saved = ZO_SavedVars:NewAccountWide("EZORaidPlanner_Saved", 1, GetWorldName(), DEFAULTS)

    if EZORaidPlanner.Core and EZORaidPlanner.Core.Initialize then
        EZORaidPlanner.Core.Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(EZORaidPlanner.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
