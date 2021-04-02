collectgarbage("setstepmul", 10000)

MetaWeakK = {
	__mode = "k"
}

MetaWeakV = {
	__mode = "v"
}

MetaWeakKV = {
	__mode = "kv"
}

VECTOR_ZERO = Vector()
ANGLE_ZERO = Angle()
debug.Point()
_Color = _Color or Color
ColorCounter = ColorCounter or {}

function Color(r, g, b, a)
	local s = debug.getinfo(2, "S").source .. debug.getinfo(2, "S").linedefined
	ColorCounter[s] = ColorCounter[s] or 0 + 1

	return _Color(r, g, b, a)
end

function ColorDump()
	local t = {}

	for k, v in pairs(ColorCounter) do
		t[#t + 1] = {k, v}
	end

	table.sort(t, function(a, b) return a[2] > b[2] end)
	local f = file.Open("ColorCounter.txt", "w", "DATA")

	for i = 1, #t do
		local v = t[i]
		f:Write(v[1])
		f:Write("\t=\t")
		f:Write(v[2])
		f:Write("\n")
	end

	f:Close()
end

do
	local player = player
	local playerGetAll = player.GetAll
	local clear = table.iclear
	player.FindName = player.FindName or {}
	player.FindUserID = player.FindUserID or {}
	player.FindSteamID = player.FindSteamID or {}
	player.FindSteamID64 = player.FindSteamID64 or {}
	player.List = player.List or {}
	local FindName, FindUserID, FindSteamID, FindSteamID64, List = player.FindName, player.FindUserID, player.FindSteamID, player.FindSteamID64, player.List

	local function UpdateLists(ignoreply)
		print("List Updated")
		clear(FindName)
		clear(FindUserID)
		clear(FindSteamID)
		clear(FindSteamID64)
		clear(List)
		local t = playerGetAll()

		for k = 1, #t do
			local v = t[k]

			if ignoreply ~= v then
				List[k] = v
				FindName[v:Nick()] = v
				FindUserID[v:UserID()] = v
				FindSteamID[v:SteamID()] = v
				FindSteamID64[v:SteamID64() or ""] = v
			end
		end
	end

	UpdateLists()

	if SERVER then
		gameevent.Listen("player_changename")

		hook.Add("PlayerInitialSpawn", "SparLib.FindCache", function()
			UpdateLists()
		end)

		hook.Add("PlayerDisconnected", "SparLib.FindCache", UpdateLists)
		hook.Add("player_changename", "SparLib.FindCache", UpdateLists)
	else
		gameevent.Listen("player_connect_client")
		gameevent.Listen("player_disconnect")
		hook.Add("player_disconnect", "SparLib.FindCache", UpdateLists)
		hook.Add("player_connect_client", "SparLib.FindCache", UpdateLists)
	end
end

_f = function() end

do
	local osdate = os.date

	function datastamp(bool)
		return osdate(bool and "%d-%m-%Y_%H-%M-%S" or "%d.%m.%Y %H:%M:%S")
	end
end

do
	local format, gsub = string.format, string.gsub

	function topf(num)
		return (gsub(format("%f", num), "(%.-)0+$", ""))
	end
end

tosafe = bit.tobit

do
	function newset(...)
		local t, len, output = {...}, select("#", ...), {}

		for I = 1, len do
			output[t[I]] = true
		end

		return output
	end
end

function createtable(n, t)
	t = t or {}

	if n then
		for I = 1, n do
			t[I] = true
		end
	end

	return t
end

do
	local concat = table.concat
	local CompileString = CompileString

	function createunpack(n)
		local ret = {}

		for k = 1, n do
			ret[k] = "t[" .. k .. "]"
		end

		return CompileString("local t = ... return " .. concat(ret, ",", 1, n))
	end
end

function numbool(bool)
	return bool and 1 or 0
end

do
	local abs, sin = math.abs, math.sin

	function absin(s)
		return abs(sin(s))
	end
end

function bit.flag(n)
	return 2 ^ (n - 1)
end

do
	local ceil, log = math.ceil, math.log

	function bit.max(n)
		return ceil(log(n) / log(2))
	end
end

do
	local Simple = timer.Simple

	function retry(func_exec, func_case, time, attempts)
		attempts = attempts or 10

		Simple(time, function()
			func_exec()

			if not func_case() then
				retry(func_exec, func_case, time, attempts - 1)
			end
		end)
	end
end

do
	local tostring, gsub, sub = tostring, string.gsub, string.sub

	function string.NiceMoney(n)
		return sub(gsub(tostring(n), "(%d%d%d)", "%1,"), 1, -2)
	end
end

do
	local b, gsub, char, tonumber = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/', string.gsub, string.char, tonumber

	function string.Base64Decode(data)
		data = gsub(data, '[^' .. b .. '=]', '')

		return (data:gsub('.', function(x)
			if (x == '=') then return '' end
			local r, f = '', b:find(x) - 1

			for i = 6, 1, -1 do
				r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0')
			end

			return r
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if (#x ~= 8) then return '' end

			return char(tonumber(x, 2))
		end))
	end
end

function debug.GetArgs(func)
	local info = debug.getinfo(func, "Su")
	if info.what == "C" then return "C function" end
	local t = {}

	for i = 1, info.nparams do
		t[i] = debug.getlocal(func, i)
	end

	if info.isvararg then
		t[info.nparams + 1] = "..."
	end

	return "function(" .. table.concat(t, ", ") .. ")"
end

function debug.where(n, r)
	local i = debug.getinfo(n or 3, "Sln")
	local str = ""

	if i.what == "C" then
		str = "C Function"
	else
		str = "debug.where: " .. (#i.namewhat == 0 and "" or ("A " .. i.namewhat .. " on ")) .. i.source .. ":" .. i.currentline
	end

	if r then
		return str
	else
		print(str)
	end
end

function debug.Bench(s, e, slot)
	DebugInfo(slot or 0, topf(e - s))
end

do
	local player = player

	function sound.Broadcast(path, volume, pitch)
		local t = player.List

		for i = 1, #t do
			t[i]:EmitSound(path, volume or 75, pitch or 100)
		end
	end
end

function file.AppendTable(filepath, table, f, tab, antiloop, notf)
	if not istable(table) then return end
	tab = tab or 0
	antiloop = antiloop or {}
	f = f or file.Open(filepath, "wb", "DATA")
	local t = string.rep("\t", tab)

	for k, v in pairs(table) do
		if istable(v) then
			if antiloop[v] then
				f:Write(t .. tostring(k) .. " = ANTILOOP" .. "\n")
			else
				f:Write(t .. tostring(k) .. ":" .. "\n")
				antiloop[v] = true
				file.AppendTable(filepath, v, f, tab + 1, antiloop, true)
				antiloop[v] = nil
			end
		else
			f:Write(t .. tostring(k) .. " = " .. tostring(v) .. "\n")
		end
	end

	if not notf then
		f:Close()
	end
end

sprintt = PrintTable

function printt(t, indent, antiloop)
	indent = indent or 0

	antiloop = antiloop or {
		[t] = true
	}

	for k, v in pairs(t) do
		Msg(string.rep("\t", indent))
		Msg(k)
		Msg("\t=\t")

		if istable(v) and not antiloop[v] then
			Msg("\n")
			antiloop[v] = true
			printt(v, indent + 1, antiloop)
		else
			Msg(v)
			Msg("\n")
		end
	end
end