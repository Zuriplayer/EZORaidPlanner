EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.EventManager = EZORaidPlanner.EventManager or {}

-- Responsible for: creating/editing events (trial or dungeon, day, time,
-- leader) and enforcing the 10-active-events-per-leader limit.
local MAX_ACTIVE_EVENTS_PER_LEADER = 10

local events = {}

local function NormalizeText(value)
    value = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if value == "" then
        return nil
    end
    return value
end

local function GetSaved()
    return EZORaidPlanner and EZORaidPlanner.saved
end

local function EnsureStore()
    local saved = GetSaved()
    if not saved then
        return nil
    end
    saved.events = type(saved.events) == "table" and saved.events or {}
    saved.nextEventId = tonumber(saved.nextEventId) or 1
    events = saved.events
    return saved
end

local function NormalizeScheduleType(value)
    return value == "recurring" and "recurring" or "one_time"
end

local function NormalizeWeekday(value)
    local weekday = NormalizeText(value)
    if weekday == "monday" or weekday == "tuesday" or weekday == "wednesday"
        or weekday == "thursday" or weekday == "friday" or weekday == "saturday"
        or weekday == "sunday" then
        return weekday
    end
    return ""
end

function EZORaidPlanner.EventManager.Initialize()
    EnsureStore()
end

function EZORaidPlanner.EventManager.CountActiveForLeader(leaderAccount)
    EnsureStore()
    local count = 0
    leaderAccount = NormalizeText(leaderAccount) or ""
    for _, event in pairs(events) do
        if event.leader == leaderAccount and event.status == "active" then
            count = count + 1
        end
    end
    return count
end

function EZORaidPlanner.EventManager.GetEvents()
    EnsureStore()
    return events
end

function EZORaidPlanner.EventManager.GetEvent(eventId)
    EnsureStore()
    if eventId == nil then
        return nil
    end
    return events[tostring(eventId)]
end

function EZORaidPlanner.EventManager.GetActiveEvents()
    EnsureStore()
    local out = {}
    for _, event in pairs(events) do
        if event.status == "active" then
            out[#out + 1] = event
        end
    end
    table.sort(out, function(a, b)
        return tonumber(a.id or 0) < tonumber(b.id or 0)
    end)
    return out
end

function EZORaidPlanner.EventManager.DeleteEvent(eventId)
    local saved = EnsureStore()
    if not saved then
        return false, "SAVED_VARS_UNAVAILABLE"
    end

    local normalizedId = NormalizeText(eventId)
    if not normalizedId or not events[normalizedId] then
        return false, "EVENT_NOT_FOUND"
    end

    events[normalizedId] = nil
    if EZORaidPlanner.Debug and EZORaidPlanner.Debug.Log then
        EZORaidPlanner.Debug.Log("Deleted event " .. normalizedId)
    end
    return true
end

-- eventData = { activityType = "trial"|"dungeon", scheduleType = "one_time"|"recurring", date, weekday, time, name, leader, discordLink }
function EZORaidPlanner.EventManager.CreateEvent(eventData)
    local saved = EnsureStore()
    if not saved then
        return nil, "SAVED_VARS_UNAVAILABLE"
    end

    eventData = type(eventData) == "table" and eventData or {}
    local leader = NormalizeText(eventData.leader) or ""
    local scheduleType = NormalizeScheduleType(eventData.scheduleType)
    local date = scheduleType == "one_time" and (NormalizeText(eventData.date or eventData.day) or "") or ""
    local weekday = scheduleType == "recurring" and NormalizeWeekday(eventData.weekday or eventData.day) or ""
    if EZORaidPlanner.EventManager.CountActiveForLeader(leader) >= MAX_ACTIVE_EVENTS_PER_LEADER then
        return nil, "MAX_ACTIVE_EVENTS_REACHED"
    end

    local eventId = tostring(saved.nextEventId)
    saved.nextEventId = saved.nextEventId + 1

    local event = {
        id = eventId,
        activityType = eventData.activityType == "dungeon" and "dungeon" or "trial",
        scheduleType = scheduleType,
        name = NormalizeText(eventData.name) or "",
        date = date,
        weekday = weekday,
        day = scheduleType == "recurring" and weekday or date,
        time = NormalizeText(eventData.time) or "",
        leader = leader,
        discordLink = NormalizeText(eventData.discordLink) or "",
        status = eventData.status or "active",
        createdAt = GetTimeStamp and GetTimeStamp() or 0,
        roster = {},
    }

    events[eventId] = event
    if EZORaidPlanner.Debug and EZORaidPlanner.Debug.Log then
        EZORaidPlanner.Debug.Log("Created event " .. eventId)
    end
    return event
end
