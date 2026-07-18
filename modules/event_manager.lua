EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.EventManager = EZORaidPlanner.EventManager or {}

-- Responsible for: creating/editing events (trial or dungeon, day, time,
-- leader) and enforcing the 5-active-events-per-leader limit.
local MAX_ACTIVE_EVENTS_PER_LEADER = 5

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

-- eventData = { activityType = "trial"|"dungeon", name, day, time, leader, discordLink }
function EZORaidPlanner.EventManager.CreateEvent(eventData)
    local saved = EnsureStore()
    if not saved then
        return nil, "SAVED_VARS_UNAVAILABLE"
    end

    eventData = type(eventData) == "table" and eventData or {}
    local leader = NormalizeText(eventData.leader) or ""
    if EZORaidPlanner.EventManager.CountActiveForLeader(leader) >= MAX_ACTIVE_EVENTS_PER_LEADER then
        return nil, "MAX_ACTIVE_EVENTS_REACHED"
    end

    local eventId = tostring(saved.nextEventId)
    saved.nextEventId = saved.nextEventId + 1

    local event = {
        id = eventId,
        activityType = eventData.activityType == "dungeon" and "dungeon" or "trial",
        name = NormalizeText(eventData.name) or "",
        day = NormalizeText(eventData.day) or "",
        time = NormalizeText(eventData.time) or "",
        leader = leader,
        discordLink = NormalizeText(eventData.discordLink) or "",
        status = eventData.status or "active",
        createdAt = GetTimeStamp and GetTimeStamp() or 0,
        roster = {},
    }

    events[eventId] = event
    return event
end
