local UPMeta = {}
UPMeta.__index = UPMeta
ACCOUNTSROOT = "sboxserver/userprofiles/"

local UPErrorNoUser = function()
	error("[SBUP] No User assigned to this profile!")
end

local UPErrorNoProfile = function()
	error("[SBUP] No Profile loaded!")
end

function UserProfile()
	local GC = newproxy(true)

	local p = setmetatable({
		Player = false,
		Profile = false,
		SteamID = false,
		WriteHandler = false,
		ReadHandler = false,
		__gc = GC
	}, UPMeta)

	getmetatable(GC).__gc = function()
		p:Close()
	end

	return p
end

function UPMeta:__tostring()
	local suffix = "[No User]"

	if self.Remote then
		suffix = "[Remote] " .. self.SteamID
	elseif self.Player then
		suffix = tostring(self.Player)
	end

	return "[SBox UserProfile] " .. suffix
end

function UPMeta:Close()
	if self.WriteHandler then
		self.WriteHandler:Close()
	end

	if self.ReadHandler then
		self.ReadHandler:Close()
	end
end

function UPMeta:SetPlayer(ply)
	if not ply:IsValid() or ply:IsBot() then return false end
	self.Player = ply
	self.SteamID = ply:SteamID64()

	return true
end

local ContainerMeta = {}
ContainerMeta.__index = ContainerMeta
local ContainersParent = {}

do
	local fileOpen = file.Open
	local ToJSON, FromJSON = util.TableToJSON, util.JSONToTable

	function UPMeta:ImportProfile()
		if not self.Player then
			UPErrorNoUser()
		end

		local path = ACCOUNTSROOT .. self.SteamID .. ".dat"

		do
			local f = fileOpen(path, "r", "DATA")
			if not f then return self:CreateProfile() end
			local size = f:Size()
			if size == 0 then return self:CreateProfile() end
			self.Profile = setmetatable(FromJSON(f:Read(size)), ContainerMeta)
			ContainersParent[self.Profile] = self
			self.ReadHandler = f
		end

		self.WriteHandler = fileOpen(path, "a", "DATA")

		return true
	end

	function UPMeta:RemoteProfile(steamid)
		local path = ACCOUNTSROOT .. steamid .. ".dat"

		do
			local f = fileOpen(path, "r", "DATA")
			if not f then return self:CreateProfile() end
			local size = f:Size()
			if size == 0 then error("[SBUP] Account doesn't exist") end
			self.Profile = setmetatable(FromJSON(f:Read(size)), ContainerMeta)
			f:Seek(0)
			self.ReadHandler = f
		end

		self.WriteHandler = fileOpen(path, "a", "DATA")

		return true
	end

	function UPMeta:CreateProfile()
		if not self.Player then
			UPErrorNoUser()
		end

		do
			local f = fileOpen(ACCOUNTSROOT .. self.SteamID .. ".dat", "w", "DATA")

			local NewProfile = {
				General = {
					Money = 0,
					Reputation = 0
				},
				StoreKit = {}
			}

			NewProfile.General.Nick = self.Player:Nick()
			NewProfile.General.UserGroup = self.Player:GetUserGroup()
			NewProfile.General.LastOnline = os.time()
			f:Write(ToJSON(NewProfile))
			f:Close()
		end

		return true, self:ImportProfile()
	end
end

function UPMeta:Sync(callback)
	if not self.Profile then
		UPErrorNoProfile()
	end

	self.WriteHandler:Seek(0)
	self.WriteHandler:Write(ToJSON(self.Profile))
	self.WriteHandler:Flush()

	if callback then
		callback()
	end
end

function UPMeta:Register()
	if not self.Player then
		UPErrorNoUser()
	end

	Global.ActiveProfiles[self.Player] = self

	return self
end

function UPMeta:GetProfile()
	return self.Profile
end

function UPMeta:GetPlayer()
	return self.Player
end

function UPMeta:GetSteamID()
	return self.SteamID
end

function ContainerMeta:GetString(key)
	return tostring(self[key])
end

function ContainerMeta:GetTable(key)
	local t = setmetatable(self[key], ContainerMeta)
	ContainersParent[t] = ContainersParent[self]

	return t
end

function ContainerMeta:GetNumber(key)
	return tonumber(self[key])
end

function ContainerMeta:Exists(key)
	return self[key] ~= nil
end

function ContainerMeta:GetType(key)
	return type(self[key])
end

function ContainerMeta:SetString(key, value, disable_net)
	self[key] = tostring(value)

	if not disable_net then
		self:UpdateNetwork(key, self[key])
	end
end

function ContainerMeta:SetNumber(key, value, disable_net)
	self[key] = tosafe(tonumber(value) or 0)

	if not disable_net then
		self:UpdateNetwork(key, self[key])
	end
end

function ContainerMeta:AddNumber(key, value, disable_net)
	self[key] = tosafe((self[key] or 0) + (tonumber(value) or 0))

	if not disable_net then
		self:UpdateNetwork(key, self[key])
	end
end

function ContainerMeta:RemoveValue(key)
	self[key] = nil
end

do
	local PLY = FindMetaTable("Player")

	function PLY:GetProfile()
		return Global.ActiveProfiles[self]
	end
end

do
	local ENT = FindMetaTable("Entity")

	local NWt = {
		string = ENT.SetNWString,
		int = ENT.SetNWInt,
		float = ENT.SetNWFloat,
		bool = ENT.SetNWBool
	}

	local NetContainers = {}

	function ContainerMeta:AttachToNetwork(key, netname, keytype)
		if not NetContainers[self] then
			NetContainers[self] = {}
		end

		NetContainers[self][key] = NWt[keytype]
		local P = ContainersParent[self]

		P.Player:SetNWVarProxy(key, function(_1, _2, _3, newv)
			if self[key] == newv then return end
			self[key] = newv
			P:Sync()
		end)
	end

	function ContainerMeta:UpdateNetwork(key, val)
		if not NetContainers[self] or not NetContainers[self][key] then return end
		NetContainers[self][key](ContainersParent[self].Player, key, val)
	end
end
