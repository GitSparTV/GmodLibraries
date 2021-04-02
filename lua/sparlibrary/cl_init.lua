local MsgC, Color, include = MsgC, Color(18, 149, 241), include

local function SparLibrary()
	MsgC(Color, "[ Spar Library ] Created for Russianspeaking SBox Server by Spar", "\n")

	do
		local sh_modules = include("sparlibrary/modules/sh/_sparlib.lua")

		for i = 1, #sh_modules do
			include("sparlibrary/modules/sh/" .. sh_modules[i])
		end
	end

	do
		local cl_modules = include("sparlibrary/modules/cl/_sparlib.lua")

		for i = 1, #cl_modules do
			include("sparlibrary/modules/cl/" .. cl_modules[i])
		end
	end
end

concommand.Add("sparlibrary_reload", function()
	SparLibrary()
end, nil, nil, FCVAR_PROTECTED)

SparLibrary()