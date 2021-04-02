local MsgC, Color, include, AddCSLuaFile, BroadcastLua = MsgC, Color(0, 255, 255), include, AddCSLuaFile, BroadcastLua

local function RuSBoxServerLibInit()
	MsgC(Color, "[ Russianspeaking SBox Server Library ] Created for Russianspeaking SBox Server by Spar", "\n")

	do
		local sh_modules = include("rusboxserverlib/modules/sh/_lib.lua")

		for i = 1, #sh_modules do
			include("rusboxserverlib/modules/sh/" .. sh_modules[i])
			AddCSLuaFile("rusboxserverlib/modules/sh/" .. sh_modules[i])
		end
	end

	do
		local sv_modules = include("rusboxserverlib/modules/sv/_lib.lua")

		for i = 1, #sv_modules do
			include("rusboxserverlib/modules/sv/" .. sv_modules[i])
		end
	end

	do
		local cl_modules = include("rusboxserverlib/modules/cl/_lib.lua")

		for i = 1, #cl_modules do
			AddCSLuaFile("rusboxserverlib/modules/cl/" .. cl_modules[i])
		end
	end

	AddCSLuaFile("rusboxserverlib/cl_init.lua")
	AddCSLuaFile("rusboxserverlib/modules/cl/_lib.lua")
	AddCSLuaFile("rusboxserverlib/modules/sh/_lib.lua")
	BroadcastLua([[RunConsoleCommand("rusboxserverlib_reload")]])
end

concommand.Add("rusboxserverlib_reload", function(ply)
	if ply:IsValid() then return end
	RuSBoxServerLibInit()
end, nil, nil, FCVAR_PROTECTED)

RuSBoxServerLibInit()