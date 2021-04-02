local DBMeta = {}
DBMeta.__index = DBMeta
debug.getregistry().filedatabase = DBMeta

local HandleMeta = {
	__index = false,
	__newindex = function(self, k, v)
		self.__handle__lookup[k] = v
		self.__handle__database:Update()
	end
}

do
	local setmetatable = setmetatable

	HandleMeta.__index = function(self, k)
		local v = self.__handle__lookup[k]

		if istable(v) then
			return setmetatable({
				__handle__database = self.__handle__database,
				__handle__lookup = v
			}, HandleMeta)
		end

		return v
	end

	function database(path, pretty)
		local GC = newproxy(true)

		local obj = setmetatable({
			db_Path = path,
			db_Cache = {},
			db_WriteHandle = false,
			db_ReadHandle = false,
			db_DataHandle = false,
			db_DatabaseGC = GC,
			db_PrettyPrint = pretty,
			db_UpdateEach = 1,
			db_CurrentUpdate = 0
		}, DBMeta)

		getmetatable(GC).__gc = function()
			obj:Close()
		end

		return obj
	end
end

do
	local itextSplit = itext.Split
	local fileExists, fileCreateDir = file.Exists, file.CreateDir
	local tableconcat = table.concat

	function DBMeta:ValidPath()
		if fileExists(self.db_Path, "DATA") then return true end
		local path = itextSplit(self.db_Path, "/")
		if #path == 1 then return false end
		fileCreateDir(tableconcat(path, "/", 1, #path - 1))

		return false
	end
end

function DBMeta:GetPath()
	return self.db_Path
end

function DBMeta:UpdateEach(n)
	self.db_UpdateEach = n
end

function DBMeta:Update()
	if self.db_UpdateEach == 0 then return end
	if self.db_UpdateEach == 1 then return self:Sync() end
	self.db_CurrentUpdate = (self.db_CurrentUpdate + 1) % self.db_UpdateEach

	if self.db_CurrentUpdate == 0 then
		self:Sync()
	end
end

function DBMeta:__tostring()
	return "[DataBase] [" .. self.db_Path .. "]"
end

function DBMeta:Setup()
	self:ValidPath()
	self:LoadFile()
end

function DBMeta:Close()
	self.db_ReadHandle:Close()
	self.db_WriteHandle:Close()
end

do
	local fileOpen, FromJSON = file.Open, util.JSONToTable

	function DBMeta:Clear()
		fileOpen(self.db_Path, "w", "DATA"):Close()
	end

	function DBMeta:LoadFile()
		local w, r = fileOpen(self.db_Path, "a", "DATA"), fileOpen(self.db_Path, "r", "DATA")

		if not r or not w then
			error("Could not open the database file (W:" .. tostring(w) .. "|R:" .. tostring(r) .. ")")
		end

		self.db_WriteHandle, self.db_ReadHandle = w, r
		self.db_Cache = FromJSON(r:Read(r:Size()) or "") or self.db_Cache
		r:Seek(0)
	end
end

function DBMeta:GetHandle()
	return setmetatable({
		__handle__lookup = self.db_Cache,
		__handle__database = self
	}, HandleMeta)
end

function DBMeta:GetTable()
	return self.db_Cache
end

do
	local ToJSON = util.TableToJSON

	function DBMeta:Sync()
		self:Clear()
		self.db_WriteHandle:Seek(0)
		self.db_WriteHandle:Write(ToJSON(self.db_Cache, self.db_PrettyPrint))
		self.db_WriteHandle:Flush()
		self.db_CurrentUpdate = 0
	end
end