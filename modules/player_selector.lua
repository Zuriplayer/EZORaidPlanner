EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.PlayerSelector = EZORaidPlanner.PlayerSelector or {}

-- Responsible for: adding players to an event roster from three sources:
--   1) manual entry by @account
--   2) current group members
--   3) guild roster (when a guild is selected and the API exposes it easily)
function EZORaidPlanner.PlayerSelector.Initialize()
    -- no-op placeholder for early development
end

function EZORaidPlanner.PlayerSelector.AddByAccountName(accountName)
    -- TODO: validate format (@account) and append to the target event roster.
    return accountName
end

function EZORaidPlanner.PlayerSelector.AddFromCurrentGroup()
    local roster = {}
    for i = 1, GetGroupSize() do
        local unitTag = GetGroupUnitTagByIndex(i)
        if unitTag then
            roster[#roster + 1] = GetUnitDisplayName(unitTag)
        end
    end
    return roster
end

function EZORaidPlanner.PlayerSelector.AddFromGuildRoster(guildId)
    local roster = {}
    if not guildId then
        return roster
    end
    for i = 1, GetNumGuildMembers(guildId) do
        local displayName = GetGuildMemberInfo(guildId, i)
        roster[#roster + 1] = displayName
    end
    return roster
end
