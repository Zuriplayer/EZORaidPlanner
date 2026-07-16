EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.i18n = EZORaidPlanner.i18n or {}

local strings = {}

function EZORaidPlanner.i18n.Register(languageCode, stringTable)
    strings[languageCode] = stringTable
end

function EZORaidPlanner.i18n.Get(key, languageCode)
    local lang = languageCode or (GetCVar("language.2") or "en")
    local dict = strings[lang] or strings.en or {}
    return dict[key] or key
end
