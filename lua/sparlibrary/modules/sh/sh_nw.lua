debug.Point()
local ENT = FindMetaTable("Entity")

if CLIENT then
	net.Receive("SBox.NWTable", function()
		local ent, id, tbl = net.ReadEntity(), net.ReadString(), net.ReadTable()

		callback.RegisterCallback("OnEntityCreated", ent, function()
			ent:SetNWTable(id, tbl)
		end, true, 1)

		ent:SetNWTable(id, tbl)
	end)

	hook.Add("OnEntityCreated", "TEST", function(...) end)

	function ENT:GetNWTable(id, def)
		falser(id, FALSER_VALID)
		if not istable(self.NWTable) or not istable(self.NWTable[id]) then return def or {} end

		return self.NWTable[id]
	end

	function ENT:SetNWTable(id, tbl)
		falser(id, FALSER_VALID)
		falser(tbl, FALSER_TBL)

		if not istable(self.NWTable) then
			self.NWTable = {}
		end

		if not IsValid(self) and self ~= Entity(0) then return end
		if not istable(self.NWTable) then return end
		self.NWTable[id] = tbl
		callback.RemoveCallback("OnEntityCreated", self)
	end
else
	util.AddNetworkString("SBox.NWTable")

	function ENT:GetNWTable(id, def)
		falser(id, FALSER_VALID)
		if not istable(self.NWTable) or not istable(self.NWTable[id]) then return def or {} end

		return self.NWTable[id]
	end

	function ENT:SetNWTable(id, tbl)
		falser(id, FALSER_VALID)

		timer.Simple(0.1, function()
			if not IsValid(self) and self ~= Entity(0) then
				print("Entity Not Valid", self)

				return
			end

			if not istable(tbl) then
				error("Not a table")
			end

			if not istable(self.NWTable) then
				self.NWTable = {}
			end

			self.NWTable[id] = tbl
			net.Start("SBox.NWTable")
			net.WriteEntity(self)
			net.WriteString(id)
			net.WriteTable(tbl)
			net.Broadcast()
		end)
	end
end