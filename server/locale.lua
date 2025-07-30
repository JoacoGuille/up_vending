Locale = {}

Locale.languages = {}
Locale.defaultLanguage = Config.DefaultLanguage

function Locale.Translate(key, replacements)
    local lang = Locale.defaultLanguage
    local src = source
    if GetPlayerServerId then
        lang = Locale.GetLanguage and Locale.GetLanguage(src) or Locale.defaultLanguage
    end
    return Locale.getTranslation(key, lang, replacements)
end

function Locale.GetLanguage(src)
    return Config.LocaleSettings.Locale or Locale.defaultLanguage
end

function Locale.getTranslation(key, lang, replacements)
    lang = lang or Locale.defaultLanguage
    if not Locale.languages[lang] then
        lang = Locale.defaultLanguage
    end
    local text = Locale.languages[lang][key] or key
    if replacements then
        for k, v in pairs(replacements) do
            text = string.gsub(text, '{{'..k..'}}', v)
        end
    end
    return text
end

function LoadLocales()
    Locale.languages = Config.LocaleSettings.Languages
end

LoadLocales()