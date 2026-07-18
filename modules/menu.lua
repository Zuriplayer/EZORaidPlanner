EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.Menu = EZORaidPlanner.Menu or {}

local draft = {
    activityType = "trial",
    name = "",
    day = "",
    time = "",
    leader = "",
    discordLink = "",
}

local function GetDefaultLeader()
    if draft.leader == "" and GetDisplayName then
        draft.leader = GetDisplayName()
    end
    return draft.leader
end

local function BuildOptions()
    return {
        {
            type = "header",
            name = EZORaidPlanner.i18n.Get("EVENT_NEW"),
        },
        {
            type = "dropdown",
            name = EZORaidPlanner.i18n.Get("EVENT_TYPE"),
            choices = {
                EZORaidPlanner.i18n.Get("EVENT_TYPE_TRIAL"),
                EZORaidPlanner.i18n.Get("EVENT_TYPE_DUNGEON"),
            },
            choicesValues = { "trial", "dungeon" },
            getFunc = function() return draft.activityType end,
            setFunc = function(value) draft.activityType = value or "trial" end,
            default = "trial",
            width = "half",
        },
        {
            type = "editbox",
            name = EZORaidPlanner.i18n.Get("EVENT_NAME"),
            getFunc = function() return draft.name end,
            setFunc = function(value) draft.name = tostring(value or "") end,
            width = "half",
        },
        {
            type = "editbox",
            name = EZORaidPlanner.i18n.Get("EVENT_DAY"),
            getFunc = function() return draft.day end,
            setFunc = function(value) draft.day = tostring(value or "") end,
            width = "half",
        },
        {
            type = "editbox",
            name = EZORaidPlanner.i18n.Get("EVENT_TIME"),
            getFunc = function() return draft.time end,
            setFunc = function(value) draft.time = tostring(value or "") end,
            width = "half",
        },
        {
            type = "editbox",
            name = EZORaidPlanner.i18n.Get("EVENT_LEADER"),
            getFunc = GetDefaultLeader,
            setFunc = function(value) draft.leader = tostring(value or "") end,
            width = "half",
        },
        {
            type = "editbox",
            name = EZORaidPlanner.i18n.Get("EVENT_DISCORD_LINK"),
            tooltip = EZORaidPlanner.i18n.Get("EVENT_DISCORD_LINK_TOOLTIP"),
            getFunc = function() return draft.discordLink end,
            setFunc = function(value) draft.discordLink = tostring(value or "") end,
            width = "half",
        },
        {
            type = "button",
            name = EZORaidPlanner.i18n.Get("EVENT_CREATE"),
            func = function()
                EZORaidPlanner.EventManager.CreateEvent(draft)
            end,
            width = "half",
        },
    }
end

function EZORaidPlanner.Menu.Initialize()
    if not EZORaidPlanner.LAM.IsAvailable() then
        return
    end

    local panelData = {
        type = "panel",
        name = EZORaidPlanner.i18n.Get("ADDON_NAME"),
        displayName = "EZO Raid Planner",
        author = EZORaidPlanner.ADDON_AUTHOR or "@Zuriplayer",
        version = EZORaidPlanner.ADDON_VERSION or EZORaidPlanner.version,
        ezoStage = "development",
        registerForRefresh = true,
    }

    local options = BuildOptions()
    if EZOCore and type(EZOCore.RegisterSettingsPanel) == "function" then
        local registered = EZOCore:RegisterSettingsPanel("EZORaidPlanner", "EZORaidPlanner_LAM", panelData, options)
        if registered then
            EZORaidPlanner.ezoSettingsRegistered = true
            return
        end
    end

    EZORaidPlanner.LAM.RegisterPanel("EZORaidPlanner_LAM", panelData)
    EZORaidPlanner.LAM.RegisterOptionControls("EZORaidPlanner_LAM", options)
end
