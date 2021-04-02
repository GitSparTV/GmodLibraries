if SERVER then
	include("sparlibrary/init.lua")
	include("rusboxserverlib/init.lua")
else
	AddCSLuaFile("sparlibrary/cl_init.lua")
	include("sparlibrary/cl_init.lua")
	AddCSLuaFile("rusboxserverlib/cl_init.lua")
	include("rusboxserverlib/cl_init.lua")
end

	-- _SCRIPT
	-- while true do end 