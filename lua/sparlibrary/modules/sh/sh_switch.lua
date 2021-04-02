-- Deprecated
--[[SWITCH-CASE-----------------------------------------------------------]]
--
local switchMeta = {}
debug.getregistry().switch = switchMeta
switchMeta.__index = switchMeta

function Switch()
	return setmetatable({
		cases = {}
	}, switchMeta)
end

function switchMeta:case(on, call)
	self.cases[on] = call
end

function switchMeta:default(call)
	self.cases["SWITCH_DEFAULT"] = call
end

function switchMeta:go(val)
	if self.cases[val] then
		self.cases[val]()
	elseif self.cases["SWITCH_DEFAULT"] then
		self.cases["SWITCH_DEFAULT"]()
	end
end
--[[SWITCH-CASE-----------------------------------------------------------]]
--