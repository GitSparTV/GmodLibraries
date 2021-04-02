local PANELMETA = FindMetaTable("Panel")
local SysTime = SysTime

function PANELMETA:AddErp(mode, time, from, to)
	if not self.ErpList then
		function self:AnimationThink()
			for i = 1, #self.ErpList do
				local v = self.ErpList[i]

				if v.on then
					if v.switch then
						self[v.id] = v.func(SysTime() - v.systime, v.time, v.lastval or v.from, v.to)
					else
						self[v.id] = v.func(SysTime() - v.systime, v.time, v.lastval or v.to, v.from)
					end
				end
			end

			if self.ThinkHook then
				for i = 1, #self.ThinkHook do
					self.ThinkHook[i](self)
				end
			end
		end

		self.ErpList = {}
	end

	local id = #self.ErpList + 1

	self.ErpList[id] = {
		id = "Erp_" .. id,
		func = mode,
		time = time,
		from = from,
		to = to,
		switch = true,
		systime = SysTime(),
		on = true
	}

	return "Erp_" .. id
end

function PANELMETA:AddThinkHook(func)
	if not self.ThinkHook then
		if not self.AnimationThink then
			function self:AnimationThink()
				if self.ThinkHook then
					for i = 1, #self.ThinkHook do
						self.ThinkHook[i](self)
					end
				end
			end
		end

		self.ThinkHook = {}
	end

	self.ThinkHook[#self.ThinkHook + 1] = func
end

function PANELMETA:SetErpRange(id, a, b)
	self.ErpList[id].from = a
	self.ErpList[id].to = b
end

function PANELMETA:GetErpRange(id)
	return self.ErpList[id].from, self.ErpList[id].to
end

function PANELMETA:SetErpMode(id, func)
	self.ErpList[id].func = func
end

function PANELMETA:IsErpCompleted(id)
	return SysTime() - self.ErpList[id].systime > self.ErpList[id].time
end

function PANELMETA:SetErpOn(id, b)
	self.ErpList[id].on = b
end

function PANELMETA:SetErpEndTime(id, a)
	self.ErpList[id].time = a
end

do
	local tableremove = table.remove

	function PANELMETA:DeleteErp(id)
		self[self.ErpList[id].id] = nil
		tableremove(self.ErpList, id)
	end
end

function PANELMETA:DeleteAllErp()
	for i = 1, #self.ErpList do
		self[self.ErpList[i].id] = nil
		self.ErpList[i] = nil
	end
end

function PANELMETA:SwitchErp(id, bool)
	if self.ErpList[id].switch == bool then return end
	local erp = self.ErpList[id]
	erp.systime = SysTime()
	erp.switch = bool
	erp.lastval = self[erp.id]
end

function PANELMETA:FixErp(id, bool)
	local erp = self.ErpList[id]
	erp.systime = 0
	erp.switch = bool
	erp.lastval = nil
end

function PANELMETA:GetErpTime(id)
	return SysTime() - (self.ErpList[id].systime or 0)
end

function PANELMETA:FeedErpClock(id)
	self.ErpList[id].systime = SysTime()
end

function PANELMETA:SetErpClock(id, s)
	self.ErpList[id].systime = s
end

function PANELMETA:GetErpClock(id)
	return self.ErpList[id].systime
end

function PANELMETA:GetErpState(id)
	return self.ErpList[id].switch
end