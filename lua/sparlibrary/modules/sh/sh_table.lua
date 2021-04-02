do
	local pairs = pairs

	function table.GetValueKey(tbl, value)
		for k, v in pairs(tbl) do
			if v == value then return k end
		end

		return false
	end

	function table.FromSet(tbl)
		local t = {}

		for k, v in pairs(tbl) do
			t[#t + 1] = k
		end

		return t
	end
end

function table.iGetValueKey(tbl, value, len)
	for k = 1, len or #tbl do
		if tbl[k] == value then return k end
	end

	return false
end

function table.ToSet(tbl)
	local t = {}

	for k = 1, #tbl do
		t[tbl[k]] = true
	end

	return t
end

function table.iclear(t)
	for k = 1, #t do
		t[k] = nil
	end
end