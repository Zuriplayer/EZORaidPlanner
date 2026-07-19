EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.Menu = EZORaidPlanner.Menu or {}

local draft = {
    activityType = "trial",
    scheduleType = "one_time",
    name = "",
    date = "",
    weekday = "monday",
    time = "",
    leader = "",
    discordLink = "",
    selectedEventId = "",
}

local DELETE_DROPDOWN_REFERENCE = "EZORaidPlannerDeleteEventDropdown"
local DATE_EDITBOX_REFERENCE = "EZORaidPlannerEventDateEditbox"
local activeEventsSummaryControl

local function GetDefaultLeader()
    if draft.leader == "" and GetDisplayName then
        draft.leader = GetDisplayName()
    end
    return draft.leader
end

local function GetString(key)
    return EZORaidPlanner.i18n.Get(key)
end

local function PrintString(key, ...)
    if not EZORaidPlanner.Print then
        return
    end
    local message = GetString(key)
    if select("#", ...) > 0 then
        message = string.format(message, ...)
    end
    EZORaidPlanner.Print(message)
end

local function GetWeekdayName(weekday)
    local key = "WEEKDAY_" .. string.upper(tostring(weekday or ""))
    return GetString(key)
end

local function GetEventChoiceLabel(event)
    local scheduleText
    if event.scheduleType == "recurring" then
        scheduleText = string.format("%s %s", GetString("EVENT_SCHEDULE_RECURRING"), GetWeekdayName(event.weekday))
    else
        scheduleText = string.format("%s %s", GetString("EVENT_SCHEDULE_ONE_TIME"), event.date or "")
    end

    return string.format(
        "#%s %s - %s %s",
        tostring(event.id or "?"),
        tostring(event.name or ""),
        scheduleText,
        tostring(event.time or "")
    )
end

local function GetActiveEventsSummary()
    local activeEvents = EZORaidPlanner.EventManager.GetActiveEvents()
    if #activeEvents == 0 then
        return GetString("EVENT_ACTIVE_NONE")
    end

    local lines = {}
    for _, event in ipairs(activeEvents) do
        lines[#lines + 1] = GetEventChoiceLabel(event)
    end

    return table.concat(lines, "\n")
end

local function SetActiveEventsSummaryText(control)
    if not control or not control.summaryLabel then
        return
    end
    control.summaryLabel:SetText(GetActiveEventsSummary())
end

local function CreateActiveEventsSummaryControl(control)
    activeEventsSummaryControl = control
    local width = control:GetWidth()

    control.titleLabel = WINDOW_MANAGER:CreateControl(nil, control, CT_LABEL)
    control.titleLabel:SetAnchor(TOPLEFT, control, TOPLEFT, 0, 0)
    control.titleLabel:SetWidth(width)
    control.titleLabel:SetFont("ZoFontWinH4")
    control.titleLabel:SetText(GetString("EVENT_ACTIVE_SUMMARY"))

    control.summaryLabel = WINDOW_MANAGER:CreateControl(nil, control, CT_LABEL)
    control.summaryLabel:SetAnchor(TOPLEFT, control.titleLabel, BOTTOMLEFT, 0, 4)
    control.summaryLabel:SetWidth(width)
    control.summaryLabel:SetFont("ZoFontGame")
    control.summaryLabel:SetVerticalAlignment(TEXT_ALIGN_TOP)
    SetActiveEventsSummaryText(control)
end

local function BuildEventChoices()
    local choices = {}
    local values = {}

    for _, event in ipairs(EZORaidPlanner.EventManager.GetActiveEvents()) do
        choices[#choices + 1] = GetEventChoiceLabel(event)
        values[#values + 1] = tostring(event.id or "")
    end

    if #choices == 0 then
        choices[1] = GetString("EVENT_ACTIVE_NONE")
        values[1] = ""
    end

    return choices, values
end

local function RefreshDeleteDropdownChoices()
    local control = _G[DELETE_DROPDOWN_REFERENCE]
    if not control then
        return
    end

    local choices, values = BuildEventChoices()
    if type(control.UpdateChoices) == "function" then
        control:UpdateChoices(choices, values)
    end
    if type(control.UpdateValue) == "function" then
        control:UpdateValue(false)
    end
end

local function RefreshActiveEventsSummary()
    local control = activeEventsSummaryControl
    if not control then
        return
    end

    if type(control.UpdateValue) == "function" then
        control:UpdateValue(false)
    else
        SetActiveEventsSummaryText(control)
    end
end

local function RefreshEventControls()
    RefreshActiveEventsSummary()
    RefreshDeleteDropdownChoices()
end

local function RefreshScheduleControls()
    local control = _G[DATE_EDITBOX_REFERENCE]
    if not control then
        return
    end
    if type(control.UpdateDisabled) == "function" then
        control:UpdateDisabled()
    end
    if type(control.UpdateValue) == "function" then
        control:UpdateValue(false)
    end
end

local function BuildOptions()
    local eventChoices, eventValues = BuildEventChoices()

    return {
        {
            type = "header",
            name = EZORaidPlanner.i18n.Get("EVENT_NEW"),
        },
        {
            type = "custom",
            createFunc = CreateActiveEventsSummaryControl,
            refreshFunc = SetActiveEventsSummaryText,
            minHeight = 115,
            maxHeight = 260,
            width = "full",
        },
        {
            type = "dropdown",
            name = EZORaidPlanner.i18n.Get("EVENT_SELECTED_ID"),
            tooltip = EZORaidPlanner.i18n.Get("EVENT_SELECTED_ID_TOOLTIP"),
            choices = eventChoices,
            choicesValues = eventValues,
            getFunc = function() return draft.selectedEventId end,
            setFunc = function(value) draft.selectedEventId = tostring(value or "") end,
            default = "",
            reference = DELETE_DROPDOWN_REFERENCE,
            width = "half",
        },
        {
            type = "button",
            name = EZORaidPlanner.i18n.Get("EVENT_DELETE"),
            tooltip = EZORaidPlanner.i18n.Get("EVENT_DELETE_TOOLTIP"),
            func = function()
                local deleted, err = EZORaidPlanner.EventManager.DeleteEvent(draft.selectedEventId)
                if deleted then
                    PrintString("EVENT_DELETED", draft.selectedEventId)
                    draft.selectedEventId = ""
                    RefreshEventControls()
                    return
                end
                PrintString(err or "EVENT_DELETE_FAILED")
            end,
            width = "half",
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
            type = "dropdown",
            name = EZORaidPlanner.i18n.Get("EVENT_SCHEDULE_TYPE"),
            tooltip = EZORaidPlanner.i18n.Get("EVENT_SCHEDULE_TYPE_TOOLTIP"),
            choices = {
                EZORaidPlanner.i18n.Get("EVENT_SCHEDULE_ONE_TIME"),
                EZORaidPlanner.i18n.Get("EVENT_SCHEDULE_RECURRING"),
            },
            choicesValues = { "one_time", "recurring" },
            getFunc = function() return draft.scheduleType end,
            setFunc = function(value)
                draft.scheduleType = value or "one_time"
                RefreshScheduleControls()
            end,
            default = "one_time",
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
            name = EZORaidPlanner.i18n.Get("EVENT_DATE"),
            tooltip = EZORaidPlanner.i18n.Get("EVENT_DATE_TOOLTIP"),
            getFunc = function() return draft.date end,
            setFunc = function(value) draft.date = tostring(value or "") end,
            disabled = function() return draft.scheduleType == "recurring" end,
            reference = DATE_EDITBOX_REFERENCE,
            width = "half",
        },
        {
            type = "dropdown",
            name = EZORaidPlanner.i18n.Get("EVENT_WEEKDAY"),
            tooltip = EZORaidPlanner.i18n.Get("EVENT_WEEKDAY_TOOLTIP"),
            choices = {
                EZORaidPlanner.i18n.Get("WEEKDAY_MONDAY"),
                EZORaidPlanner.i18n.Get("WEEKDAY_TUESDAY"),
                EZORaidPlanner.i18n.Get("WEEKDAY_WEDNESDAY"),
                EZORaidPlanner.i18n.Get("WEEKDAY_THURSDAY"),
                EZORaidPlanner.i18n.Get("WEEKDAY_FRIDAY"),
                EZORaidPlanner.i18n.Get("WEEKDAY_SATURDAY"),
                EZORaidPlanner.i18n.Get("WEEKDAY_SUNDAY"),
            },
            choicesValues = { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" },
            getFunc = function() return draft.weekday end,
            setFunc = function(value) draft.weekday = value or "monday" end,
            default = "monday",
            width = "half",
        },
        {
            type = "editbox",
            name = EZORaidPlanner.i18n.Get("EVENT_TIME"),
            tooltip = EZORaidPlanner.i18n.Get("EVENT_TIME_TOOLTIP"),
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
                local event, err = EZORaidPlanner.EventManager.CreateEvent(draft)
                if event then
                    PrintString("EVENT_CREATED", event.id)
                    draft.selectedEventId = event.id
                    RefreshEventControls()
                    return
                end
                PrintString(err or "EVENT_CREATE_FAILED")
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
