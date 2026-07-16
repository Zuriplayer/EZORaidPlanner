EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.Debug = EZORaidPlanner.Debug or {}

-- Optional diagnostics via LibDebugLogger, mirroring other EZO addons.
local logger

function EZORaidPlanner.Debug.Initialize()
    if LibDebugLogger then
        logger = LibDebugLogger("EZORaidPlanner")
    end
end

function EZORaidPlanner.Debug.Log(message)
    if logger then
        logger:Info(message)
    end
end
