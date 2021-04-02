local MsgC, Color, include, AddCSLuaFile, BroadcastLua = MsgC, Color(0, 255, 255), include, AddCSLuaFile, BroadcastLua

local function SparLibrary()
	MsgC(Color, "[ Spar Library ] Created for Russianspeaking SBox Server by Spar", "\n")

	do
		local sh_modules = include("sparlibrary/modules/sh/_sparlib.lua")

		for i = 1, #sh_modules do
			include("sparlibrary/modules/sh/" .. sh_modules[i])
			AddCSLuaFile("sparlibrary/modules/sh/" .. sh_modules[i])
		end
	end

	do
		local sv_modules = include("sparlibrary/modules/sv/_sparlib.lua")

		for i = 1, #sv_modules do
			include("sparlibrary/modules/sv/" .. sv_modules[i])
		end
	end

	do
		local cl_modules = include("sparlibrary/modules/cl/_sparlib.lua")

		for i = 1, #cl_modules do
			AddCSLuaFile("sparlibrary/modules/cl/" .. cl_modules[i])
		end
	end

	AddCSLuaFile("sparlibrary/cl_init.lua")
	AddCSLuaFile("sparlibrary/modules/cl/_sparlib.lua")
	AddCSLuaFile("sparlibrary/modules/sh/_sparlib.lua")
	BroadcastLua([[RunConsoleCommand("sparlibrary_reload")]])
end

concommand.Add("sparlibrary_reload", function(ply)
	if ply:IsValid() then return end
	SparLibrary()
end, nil, nil, FCVAR_PROTECTED)

SparLibrary()