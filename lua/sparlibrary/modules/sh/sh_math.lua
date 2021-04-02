function math.mean(t)
	local ret, len = 0, #t

	for i = 1, len do
		ret = ret + t[i]
	end

	return ret / len
end

function math.sign(n)
	return n > 0 and 1 or n < 0 and -1 or 0
end

do
	local sign, sin = math.sign, math.sin

	function math.square(n)
		return sign(sin(n))
	end
end

do
	local format, tonumber, math_floor, math_log, bit_rshift, bit_band, bit_lshift = string.format, tonumber, math.floor, math.log, bit.rshift, bit.band, bit.lshift

	function math.IntToBin(num)
		num = tonumber(format("%u", num))
		local ret = ""

		-- Iterate backward since the highest bit is at the beginning of the string
		-- i = #binary_string - 1
		for i = math_floor(math_log(num, 2)), 0, -1 do
			-- Mask each bit and add it on to the string
			ret = ret .. bit_rshift(bit_band(num, bit_lshift(1, i)), i)
		end

		return ret
	end
end

do
	local ceil, log = math.ceil, math.log

	function math.BitsRequired(max)
		return ceil(log(max) / log(2))
	end
end

do
	local Remap,Clamp = math.Remap, math.Clamp
	function math.ClampMap(input,inmin,inmax,outmin,outmax)
		return Remap(Clamp(input,inmin,inmax),inmin,inmax,outmin,outmax)
	end
end

do
local sort, ceil = table.sort, math.ceil
	function math.median(...)
		local copy = {...}
		local len = #copy
		sort(copy)

		if len % 2 == 0 then
			return (copy[len / 2] + copy[len / 2 + 1]) / 2
		end
		return copy[ceil(len / 2)]
	end
end

do
	local floor,ceil = math.floor, math.ceil
	function math.ceiloor(n)
		if n < 0 then
			return ceil(n)
		end
		return floor(n)
	end
end