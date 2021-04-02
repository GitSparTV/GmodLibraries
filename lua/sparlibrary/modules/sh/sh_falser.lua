-- FALSER_BOOL = "boolean"
-- FALSER_NUM = "number"
-- FALSER_STR = "string"
-- FALSER_TBL = "table"
-- FALSER_FUNC = "function"
-- FALSER_VEC = "Vector"
-- FALSER_ANG = "Angle"
-- FALSER_PLY = "Player"
-- FALSER_MATRIX = "VMatrix"
-- FALSER_NIL = "nil"
-- FALSER_VALID = "valid"

-- function falser(any, ...)
-- 	local t = {...}
-- 	local ret = false

-- 	if t[1] == true then
-- 		ret = true
-- 		table.remove(t, 1)
-- 	end

-- 	if #t == 1 then
-- 		if t[1] == "valid" and type(any) ~= "nil" and type(any) ~= "no value" then return end
-- 		if type(any) ~= t[1] then return (ret and true or error("] Argument type is " .. type(any) .. ". Allowed: " .. t[1])) end
-- 	else
-- 		local found = false

-- 		for k, v in pairs(t) do
-- 			if type(any) == v then
-- 				found = true
-- 				break
-- 			end
-- 		end

-- 		if not found then return (ret and true or error("] Argument type is " .. type(any) .. ". Allowed: " .. string.Implode(", ", t))) end
-- 	end

-- 	return false
-- end