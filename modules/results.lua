EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.Results = EZORaidPlanner.Results or {}

-- Responsible for: recording the outcome of an event once it has taken place.
-- resultData = { completed = true|false, score, time, vitality, notes }
function EZORaidPlanner.Results.Initialize()
    -- no-op placeholder for early development
end

function EZORaidPlanner.Results.RecordResult(eventId, resultData)
    -- TODO: persist resultData against the event identified by eventId.
    return eventId, resultData
end
