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

function api(name)
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

function APIMeta:__tostring()
	return "[" .. (self.Active and ">" or "x") .. "] [" .. (self.NetworkActive and "<" or "#") .. "] [" .. self.APIName .. "] [" .. #self.ClientMethods .. " method(s)]"
end

function APIMeta:Register()
	APIs[self.APIName] = self
end

function APIMeta:GetApiName()
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

	local utilNetworkStringToID, error, netReceive = util.NetworkStringToID, error, net.Receive
	function APIMeta:AttachToNetwork()
		if utilNetworkStringToID(self.APIName) == 0 then
			error("[" .. self.APIName .. "] Can't attach to network")
		end

		self.NetworkActive = true

		netReceive(self.APIName, function(len)
			local uniqueid, methodid = ReadHeader()
			local method = self.ClientMethods[methodid]
			if not method then return end
			local args = method.networkReader()
			APIQueue[#APIQueue + 1] = {self, method.callback, args, len, ply}
		end)
	end
end

function APIMeta:Call(method, args)
	method = self.ServerMethods[self.ClientMethods[method]]
	APIQueue[#APIQueue + 1] = {method.callback, args, nil}
end

function APIMeta:AddServerMethod(name, networkWriter)
	self.ServerMethods[#self.ServerMethods + 1] = {
		name = name,
		id = #self.ServerMethods + 1,
		networkWriter = isfunction(networkWriter) and networkWriter or NetworkWriterCompiler(self.APIName .. " (" .. name .. ")", networkWriter),
		networkWriterString = isfunction(networkWriter) and "custom" or networkWriter
	}

	if isfunction(networkWriter) then
		setfenv(networkWriter, net)
	end

	self.ServerMethods[name] = self.ServerMethods[#self.ServerMethods]
end

do
	local netStart, netSendToServer = net.Start, net.SendToServer

	function APIMeta:Send(method, args)
		method = self.ServerMethods[method]
		if not method then return end
		netStart(self.APIName)
		WriteHeader(method.id)
		method.networkWriter(args)
		netSendToServer()
	end
end

function APIMeta:AddMethod(name, callback, networkReader, id)
	if not id then
		if self.ClientMethods[name] then
			id = self.ClientMethods[name].id
		else
			id = #self.ClientMethods + 1
		end
	end

	self.ClientMethods[id] = {
		callback = callback,
		name = name,
		id = id,
		networkReader = isfunction(networkReader) and networkReader or NetworkReaderCompiler(self.APIName .. " (" .. name .. ")", networkReader),
		networkReaderString = isfunction(networkReader) and "custom" or networkReader
	}

	if isfunction(networkReader) then
		setfenv(networkReader, net)
	end

	if ___debug___ then
		print("[" .. self.APIName .. "] Method \"" .. name .. "\" registered at index " .. id)
	end

	self.ClientMethods[name] = self.ClientMethods[id or (#self.ClientMethods)]
end

function APIMeta:GetMethod(methodid)
	return self.ClientMethods[methodid]
end