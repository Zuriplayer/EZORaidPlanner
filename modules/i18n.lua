EZORaidPlanner = EZORaidPlanner or {}
EZORaidPlanner.i18n = EZORaidPlanner.i18n or {}

local strings = {}

local function GetClientLanguage()
    if type(GetCVar) == "function" then
        local language = zo_strlower(tostring(GetCVar("language.2") or ""))
        local prefix = language:sub(1, 2)
        if prefix == "es" then return "es" end
        if prefix == "en" then return "en" end
    end

    return "en"
end

local function IsLanguageManagedByEZOCore()
    if not (EZOCore and type(EZOCore.IsLanguageGloballyManaged) == "function") then
        return false
    end

    local ok, managed = pcall(function()
        return EZOCore:IsLanguageGloballyManaged()
    end)

    return ok and managed == true
end

function EZORaidPlanner.i18n.GetEffectiveLanguage(languageCode)
    if IsLanguageManagedByEZOCore() then
        local ok, inherited = pcall(function()
            return EZOCore:GetLanguage()
        end)
        if ok and (inherited == "es" or inherited == "en") then
            return inherited
        end
    end

    if languageCode == "es" or languageCode == "en" then
        return languageCode
    end

    return GetClientLanguage()
end

function EZORaidPlanner.i18n.Register(languageCode, stringTable)
    strings[languageCode] = stringTable
end

function EZORaidPlanner.i18n.Get(key, languageCode)
    local lang = EZORaidPlanner.i18n.GetEffectiveLanguage(languageCode)
    local dict = strings[lang] or strings.en or {}
    return dict[key] or key
end
