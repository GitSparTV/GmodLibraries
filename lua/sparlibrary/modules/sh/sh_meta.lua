-- function metaobject(metatable, add)
-- 	local proxy = newproxy(true)
-- 	local mt = getmetatable(proxy)
-- 	local meta = {
-- 		baked = true,
-- 		isPublicMeta = false
-- 	}
-- 	if add then
-- 		for k, v in pairs(add) do
-- 			meta[k] = v
-- 		end
-- 	end
-- 	for k, v in pairs(metatable) do
-- 		if isfunction(v) then
-- 			meta[k] = function(self, b, c, d, e, f)
-- 				print(b, c, d, e, f)
-- 				return v(mt, self, b, c, d, e, f)
-- 			end
-- 			continue
-- 		end
-- 		meta[k] = v
-- 	end
-- 	for k, v in pairs(meta) do
-- 		mt[k] = v
-- 	end
-- 	mt.baked = true
-- 	mt.publicMeta = {
-- 		baked = true,
-- 		isPublicMeta = true
-- 	}
-- 	for k, v in pairs(mt) do
-- 		if isfunction(v) then
-- 			mt.publicMeta[k] = v
-- 		end
-- 	end
-- 	mt.__index = mt.publicMeta
-- 	mt.__metatable = {}
-- 	return proxy
-- end
do
	local File = FindMetaTable("File")

	function File:WriteString(s)
		self:WriteUShort(#s)
		self:Write(s)
	end

	function File:ReadString()
		return self:Read(self:ReadUShort())
	end
end

do
	local COLORMETA, IsColor, Color = FindMetaTable("Color"), IsColor, Color

	COLORMETA.__mul = function(left, right)
		if IsColor(right) then
			return Color(left.r * right.r, left.g * right.g, left.b * right.b, left.a)
		else
			return Color(left.r * right, left.g * right, left.b * right, left.a)
		end
	end

	COLORMETA.__add = function(left, right)
		if IsColor(right) then
			return Color(left.r + right.r, left.g + right.g, left.b + right.b, left.a)
		else
			return Color(left.r + right, left.g + right, left.b + right, left.a)
		end
	end

	COLORMETA.__sub = function(left, right)
		if IsColor(right) then
			return Color(left.r - right.r, left.g - right.g, left.b - right.b, left.a)
		else
			return Color(left.r - right, left.g - right, left.b - right, left.a)
		end
	end
end

do
	local format = string.format
	FindMetaTable("Vector").__tostring = function(self) return format("Vector(%.2f, %.2f, %.2f)", self:Unpack()) end
end

FindMetaTable("CTakeDamageInfo").ToTable = function(self)
	return {
		GetAmmoType = self:GetAmmoType(),
		GetAttacker = self:GetAttacker(),
		GetBaseDamage = self:GetBaseDamage(),
		GetDamage = self:GetDamage(),
		GetDamageBonus = self:GetDamageBonus(),
		GetDamageCustom = self:GetDamageCustom(),
		GetDamageForce = self:GetDamageForce(),
		GetDamagePosition = self:GetDamagePosition(),
		GetDamageType = self:GetDamageType(),
		GetInflictor = self:GetInflictor(),
		GetMaxDamage = self:GetMaxDamage(),
		GetReportedPosition = self:GetReportedPosition(),
		IsBulletDamage = self:IsBulletDamage(),
		IsExplosionDamage = self:IsExplosionDamage(),
		IsFallDamage = self:IsFallDamage()
	}
end

if CLIENT then
	local PANELMETA = FindMetaTable("Panel")

	function PANELMETA:CopySize(panel)
		self:SetSize(panel:GetSize())
	end

	function PANELMETA:Debug(func)
		if not IsValid(self.DebugWindow) then
			local f = vgui.Create("DFrame")
			f:SetTitle("SBox Debugger")
			f:MakePopup()
			f:Center()
			f:SetSize(SCALEW * 200, SCALEH * 200)
			self.DebugWindow = f

			function f:Paint(w, t)
				draw.RoundedBox(SCALEH * 4, 0, 0, w, t, Color(0, 0, 0))
				draw.RoundedBox(SCALEH * 4, 2, 2, w - 4, t - 4, Color(255, 255, 255))
			end

			local text = f:Add("DLabel")
			text:SetFont(SBOX_FONT_17)
			text:SetColor(Color(0, 0, 0))
			text:Dock(FILL)
			text:SetWrap(true)
			text:SetContentAlignment(5)
			f.Text = text
			local Self = self

			function text:Think()
				if not IsValid(Self) then
					self:GetParent():Close()

					return
				end

				self:SetText(tostring(func()))
			end
		else
			local Self = self

			function self.DebugWindow.Text:Think()
				if not IsValid(Self) then
					self:GetParent():Close()

					return
				end

				self:SetText(tostring(func()))
			end
		end
	end
end

do
	FindMetaTable("Entity").GetFPPOwner = function(self) return self.FPPOwner end
end

do
	local rettable = {}
	local trace = {output = rettable}
	function util.GetPlayerTrace( ply, dir )

		dir = dir or ply:GetAimVector()
		local trace = trace
		trace.start = ply:EyePos()
		trace.endpos = trace.start + (dir * (4096 * 8))
		trace.filter = ply
		return trace
		
	end
	local TraceLine, GetPlayerTrace = util.TraceLine, util.GetPlayerTrace

	FindMetaTable("Player").PlayerTrace = rettable
	if SERVER then
		FindMetaTable("Player").GetEyeTrace = function(self)
			local tr = TraceLine(GetPlayerTrace(self))

			return rettable
		end
	else
		local CurTime = CurTime

		FindMetaTable("Player").GetEyeTrace = function(self)
			local curtime = CurTime()
			if (self.LastPlayerTrace == curtime) then return self.PlayerTrace end
			self.LastPlayerTrace = curtime
			local tr = TraceLine(GetPlayerTrace(self))
			self.PlayerTrace = tr

			return tr
		end
	end
end