local MsgC, Color, include = MsgC, Color(18, 149, 241), include

local function RuSBoxServerLibInit()
	MsgC(Color, "[ Russianspeaking SBox Server Library ] Created for Russianspeaking SBox Server by Spar", "\n")

	do
		local sh_modules = include("rusboxserverlib/modules/sh/_lib.lua")

		for i = 1, #sh_modules do
			include("rusboxserverlib/modules/sh/" .. sh_modules[i])
		end
	end

	do
		local cl_modules = include("rusboxserverlib/modules/cl/_lib.lua")

		for i = 1, #cl_modules do
			include("rusboxserverlib/modules/cl/" .. cl_modules[i])
		end
	end
end

concommand.Add("rusboxserverlib_reload", function()
	RuSBoxServerLibInit()
end, nil, nil, FCVAR_PROTECTED)

RuSBoxServerLibInit()