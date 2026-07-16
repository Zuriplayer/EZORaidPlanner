EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.EventManager = EZORaidPlanner.EventManager or {}

-- Responsible for: creating/editing events (trial or dungeon, day, time,
-- leader) and enforcing the 5-active-events-per-leader limit.
local MAX_ACTIVE_EVENTS_PER_LEADER = 5

local events = {}

function EZORaidPlanner.EventManager.Initialize()
    events = (EZORaidPlanner.saved and EZORaidPlanner.saved.events) or {}
end

function EZORaidPlanner.EventManager.CountActiveForLeader(leaderAccount)
    local count = 0
    for _, event in pairs(events) do
        if event.leader == leaderAccount and event.status == "active" then
            count = count + 1
        end
    end
    return count
end

-- eventData = { activityType = "trial"|"dungeon", name, day, time, leader }
function EZORaidPlanner.EventManager.CreateEvent(eventData)
    if EZORaidPlanner.EventManager.CountActiveForLeader(eventData.leader) >= MAX_ACTIVE_EVENTS_PER_LEADER then
        return nil, "MAX_ACTIVE_EVENTS_REACHED"
    end

    -- TODO: assign id, persist to EZORaidPlanner.saved, refresh UI.
    eventData.status = eventData.status or "active"
    return eventData
end
