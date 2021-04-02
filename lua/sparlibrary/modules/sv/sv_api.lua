local APIMeta, APIQueue, APIs = {}, {}, {}
APIMeta.__index = APIMeta
APIMeta.__metatable = false
local ___debug___ = true

if ___debug___ then
	print("WARNING !!! API DEBUG IS ON !!! WARNING")
	debug.Point()
end

API_CLIENT = bit.flag(1)
API_CONSOLE = bit.flag(2)
API_NOTMINGE = bit.flag(3)
API_ADMINONLY = bit.flag(4)
API_SUPERADMINONLY = bit.flag(5)
local NET_STRING = "s"
local NET_FLOAT = "f"
local NET_DOUBLE = "d"
local NET_BOOL = "b"
local NET_BIT = "."
local NET_COLOR = "c"
local NET_VECTOR = "v"
local NET_ANGLE = "a"
local NET_ENT = "e"
local NET_PLAYER = "p"
local NET_INT = "i"
local NET_UINT = "u"
local NET_TABLE = "t"
local NET_ARRAY = "A"

local WriteHeader

do
	local SysTime = SysTime
	local netWriteFloat, netWriteUInt = net.WriteFloat, net.WriteUInt

	function WriteHeader(methodid)
		local s = SysTime()
		netWriteFloat(s - s % 0.01)
		netWriteUInt(methodid, 5)
	end
end

local NetworkReaderCompiler

do
	local error, tableconcat, stringmatch, setfenv, stringsub, CompileString = error, table.concat, string.match, setfenv, string.sub, CompileString

	function NetworkReaderCompiler(name, reader)
		local result, toskip = {"return {"}

		for i = 1, #reader do
			if toskip then
				if toskip == 1 then
					toskip = nil
				else
					toskip = toskip - 1
				end

				goto cont
			end

			local char = stringsub(reader, i, i)
			local item

			if char == NET_STRING then
				item = "ReadString(),"
			elseif char == NET_FLOAT then
				item = "ReadFloat(),"
			elseif char == NET_DOUBLE then
				item = "ReadDouble(),"
			elseif char == NET_BOOL then
				item = "ReadBool(),"
			elseif char == NET_BIT then
				item = "ReadBit(),"
			elseif char == NET_COLOR then
				item = "ReadColor(),"
			elseif char == NET_VECTOR then
				item = "ReadVector(),"
			elseif char == NET_ANGLE then
				item = "ReadAngle(),"
			elseif char == NET_ENT then
				item = "ReadEntity(),"
			elseif char == NET_PLAYER then
				item = "ReadPlayer(),"
			elseif char == NET_INT then
				local num = stringmatch(reader, "^%d%d?", i + 1)

				if not num then
					error("Number of bits expected near " .. i .. " in " .. name)
				end

				toskip = #num
				item = "ReadInt(" .. num .. "),"
			elseif char == NET_UINT then
				local num = stringmatch(reader, "^%d%d?", i + 1)

				if not num then
					error("Number of bits expected near " .. i .. " in " .. name)
				end

				toskip = #num
				item = "ReadUInt(" .. num .. "),"
			elseif char == NET_TABLE then
				item = "ReadTable(),"
			elseif char == NET_ARRAY then
				item = "ReadArray(),"
			end

			result[#result + 1] = item
			::cont::
		end

		result[#result + 1] = "}"
		local c = CompileString(tableconcat(result), name .. " [NetReader]")
		setfenv(c, net)

		return c
	end
end

local NetworkWriterCompiler

do
	local error, tableconcat, stringmatch, setfenv, stringsub, CompileString = error, table.concat, string.match, setfenv, string.sub, CompileString

	function NetworkWriterCompiler(name, writer)
		local result, toskip = {true}

		for i = 1, #writer do
			if toskip then
				if toskip == 1 then
					toskip = nil
				else
					toskip = toskip - 1
				end

				goto cont
			end

			local char = stringsub(writer, i, i)
			local n = #result
			local item

			if char == NET_STRING then
				item = "WriteString(t[" .. n .. "])"
			elseif char == NET_FLOAT then
				item = "WriteFloat(t[" .. n .. "])"
			elseif char == NET_DOUBLE then
				item = "WriteDouble(t[" .. n .. "])"
			elseif char == NET_BOOL then
				item = "WriteBool(t[" .. n .. "])"
			elseif char == NET_BIT then
				item = "WriteBit(t[" .. n .. "])"
			elseif char == NET_COLOR then
				item = "WriteColor(t[" .. n .. "])"
			elseif char == NET_VECTOR then
				item = "WriteVector(t[" .. n .. "])"
			elseif char == NET_ANGLE then
				item = "WriteAngle(t[" .. n .. "])"
			elseif char == NET_ENT then
				item = "WriteEntity(t[" .. n .. "])"
			elseif char == NET_PLAYER then
				item = "WritePlayer(t[" .. n .. "])"
			elseif char == NET_INT then
				local num = stringmatch(writer, "^%d%d?", i + 1)

				if not num then
					error("Number of bits expected near " .. i .. " in " .. name)
				end

				toskip = #num
				item = "WriteInt(t[" .. n .. "], " .. num .. ")"
			elseif char == NET_UINT then
				local num = stringmatch(writer, "^%d%d?", i + 1)

				if not num then
					error("Number of bits expected near " .. i .. " in " .. name)
				end

				toskip = #num
				item = "WriteUInt(t[" .. n .. "], " .. num .. ")"
			elseif char == NET_TABLE then
				item = "WriteTable(t[" .. n .. "])"
			elseif char == NET_ARRAY then
				item = "WriteArray(t[" .. n .. "])"
			end

			result[#result + 1] = item
			::cont::
		end

		result[1] = "local t = ... "
		local c = CompileString(tableconcat(result), name .. " [NetWriter]")
		setfenv(c, net)

		return c
	end
end

do
	local pcall, coroutineyield, tableremove, coroutinewrap, timerCreate = pcall, coroutine.yield, table.remove, coroutine.wrap, timer.Create

	local function APIPipeline()
		while true do
			local v = APIQueue[1]

			if v then
				local b, ret = pcall(v[2], v[1], v[3], v[4], v[5])

				if not b then
					ErrorNoHalt(ret)
				end

				coroutineyield()
				tableremove(APIQueue, 1)
			end

			coroutineyield()
		end
	end

	APIPipeline = coroutinewrap(APIPipeline)

	timerCreate("APIClock", 0.1, 0, APIPipeline)
end

function GetAPI(name)
	return APIs["API." .. name]
end

do
	local function api(self, name)
		local t = setmetatable({
			ServerMethods = {},
			ClientMethods = {},
			Name = name,
			APIName = "API." .. name,
			Active = false,
			NetworkActive = false
		}, APIMeta)

		APIs[t.APIName] = t

		return t
	end

	api = {
		__call = api
	}

	do
		local bitband, bitbor = bit.bor, bit.band

		_G.api = setmetatable({
			flags = bitbor,
			flag = bitband,
			getflags = function(flags) return bitband(flags, API_CLIENT) == API_CLIENT, bitband(flags, API_CONSOLE) == API_CONSOLE, bitband(flags, API_NOTMINGE) == API_NOTMINGE, bitband(flags, API_ADMINONLY) == API_ADMINONLY, bitband(flags, API_SUPERADMINONLY) == API_SUPERADMINONLY end
		}, api)
	end
end

function APIMeta:Register()
	APIs[self.APIName] = self
end

function APIMeta:__tostring()
	return "[" .. (self.Active and ">" or "x") .. "] [" .. (self.NetworkActive and "<" or "#") .. "] [" .. self.APIName .. "] [" .. #self.ServerMethods .. " method(s)]"
end

function APIMeta:GetAPIName()
	return self.APIName
end

function APIMeta:GetName()
	return self.Name
end

function APIMeta:IsActive()
	return self.Active
end

function APIMeta:Activate()
	self.Active = true
end

do
	local netReceive = net.Receive

	function APIMeta:Deactivate()
		self.Active = false
		netReceive(self.APIName)
	end
end

function APIMeta:CanBeCalledFromNetwork()
	return self.Active and self.NetworkActive
end

do
	local ReadHeader
	do
			local netReadFloat, netReadUInt = net.ReadFloat, net.ReadUInt
			function ReadHeader()
				return netReadFloat(), netReadUInt(5)
			end
	end

	local utilAddNetworkString, netReceive = util.AddNetworkString, net.Receive
	function APIMeta:AttachToNetwork()
		utilAddNetworkString(self.APIName)
		self.NetworkActive = true

		netReceive(self.APIName, function(len, ply)
			local uniqueid, methodid = ReadHeader()
			if not self:CheckAccess(methodid, ply) then return end
			local method = self.ServerMethods[methodid]
			local args = method.networkReader()
			APIQueue[#APIQueue + 1] = {self, method.callback, args, len, ply}
		end)
	end
end

function APIMeta:Call(method, args, ply)
	if not _API:CheckAccess(self.ServerMethods[method], ply) then return end
	method = self.ServerMethods[self.ServerMethods[method]]
	APIQueue[#APIQueue + 1] = {method.callback, args, nil, ply}
end

function APIMeta:AddClientMethod(name, networkWriter)
	self.ClientMethods[#self.ClientMethods + 1] = {
		name = name,
		id = #self.ClientMethods + 1,
		networkWriter = isfunction(networkWriter) and networkWriter or NetworkWriterCompiler(self.APIName .. " (" .. name .. ")", networkWriter),
		networkWriterString = isfunction(networkWriter) and "custom" or networkWriter
	}
	if isfunction(networkWriter) then setfenv(networkWriter,net) end

	self.ClientMethods[name] = self.ClientMethods[#self.ClientMethods]
end

do
	local netStart, isbool, netBroadcast, netSend = net.Start, isbool, net.Broadcast, net.Send

	function APIMeta:Send(ply, method, args)
		method = self.ClientMethods[method]
		if not method then return end
		netStart(self.APIName)
		WriteHeader(method.id)
		method.networkWriter(args)

		if isbool(ply) then
			netBroadcast()
		else
			netSend(ply)
		end
	end
end

function APIMeta:AddMethod(name, callback, flags, networkReader, id)
	if not id then
		if self.ServerMethods[name] then
			id = self.ServerMethods[name].id
		else
			id = #self.ServerMethods + 1
		end
	end

	self.ServerMethods[id] = {
		callback = callback,
		name = name,
		id = id,
		flags = flags,
		networkReader = isfunction(networkReader) and networkReader or NetworkReaderCompiler(self.APIName .. " (" .. name .. ")", networkReader),
		networkReaderString = isfunction(networkReader) and "custom" or networkReader
	}
	if isfunction(networkReader) then setfenv(networkReader,net) end

	if ___debug___ then
		print("[" .. self.APIName .. "] Method \"" .. name .. "\" registered at index " .. id)
	end

	self.ServerMethods[name] = self.ServerMethods[id]
end

function APIMeta:GetMethod(methodid)
	return self.ServerMethods[methodid]
end

function APIMeta:CheckAccess(methodid, ply)
	if not self.ServerMethods[methodid] then return false end
	local cl, sv, minge, admin, superadmin = api.getflags(self.ServerMethods[methodid].flags)

	if ply then
		if not cl or (minge and ply:IsMinge()) or (admin and not ply:IsAdmin()) or (superadmin and not ply:IsSuperAdmin()) then return false end

		return true
	end

	return sv
end