if not cookie.GetNumber("RuSBoxServer.UILanguage") then
	cookie.Set("RuSBoxServer.UILanguage", 0)
end

local lang = {}
lang[0] = {}
lang[1] = {}
local langmeta = {__index = function(t, k) return k end}
setmetatable(lang[0], langmeta)
setmetatable(lang[1], langmeta)

do
	local API = GetAPI("Global")
	API:AddServerMethod("LanguageSet", "u1")
	local mathClamp = math.Clamp

	function ChangeLanguage(n)
		n = mathClamp(n, 0, 1)
		LANG = lang[n]
		cookie.Set("RuSBoxServer.UILanguage", n)
		API:Send("LanguageSet", {n})
	end
	ChangeLanguage(cookie.GetNumber("RuSBoxServer.UILanguage"))
end