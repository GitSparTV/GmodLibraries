-- nethook = {}
-- local HookTable = {}

-- if SERVER then
-- 	util.AddNetworkString("SparLibrary.NetHook")
-- end

-- net.Receive("SparLibrary.NetHook", function(len, ply)
-- 	local hookid = net.ReadString()
-- 	if not istable(HookTable[hookid]) or table.Count(HookTable[hookid]) == 0 then return end

-- 	if SERVER then
-- 		for k, v in pairs(HookTable[hookid]) do
-- 			v(ply, unpack(net.ReadTable()))
-- 		end
-- 	else
-- 		for k, v in pairs(HookTable[hookid]) do
-- 			v(unpack(net.ReadTable()))
-- 		end
-- 	end
-- end)

-- function nethook.Add(hookid, id, func)
-- 	falser(hookid, FALSER_STR)
-- 	falser(id, FALSER_VALID)
-- 	table.Write(HookTable, true, hookid, id, func)
-- end

-- function nethook.Remove(hookid, id)
-- 	falser(hookid, FALSER_STR)
-- 	falser(id, FALSER_VALID)
-- 	HookTable[hookid][id] = nil
-- end

-- function nethook.Hook(hookid)
-- 	falser(hookid, FALSER_STR)

-- 	hook.Add(hookid, "SparLibrary.NetHook", function(...)
-- 		nethook.Call(hookid, ...)
-- 	end)
-- end

-- function nethook.Call(hookid, ...)
-- 	falser(hookid, FALSER_STR)
-- 	net.Start("SparLibrary.NetHook")
-- 	net.WriteString(hookid)
-- 	net.WriteTable({...})

-- 	if CLIENT then
-- 		net.SendToServer()
-- 	else
-- 		net.Broadcast()
-- 	end
-- end