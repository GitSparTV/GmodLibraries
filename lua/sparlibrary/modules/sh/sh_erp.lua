local clmp, pow, sin, cos, pi, pih, sqrt = math.Clamp, math.pow, math.sin, math.cos, math.pi, math.pi / 2, math.sqrt

function iQerp(t, d, b, c)
	return (c - b) * pow(clmp(t, 0, d) / d, 2) + b
end

function oQerp(t, d, b, c)
	local cp = clmp(t, 0, d)

	return -(c - b) * cp * (cp - 2) + b
end

function ioQerp(t, d, b, c)
	local cp = clmp(t, 0, d)
	if cp < 1 then return (c - b) / 2 * pow(cp, 2) + b end

	return -(c - b) / 2 * ((cp - 1) * (cp - 3) - 1) + b
end

function iCuerp(t, d, b, c)
	return (c - b) * pow(clmp(t, 0, d) / d, 3) + b
end

function oCuerp(t, d, b, c)
	return (c - b) * (pow(clmp(t, 0, d) / d - 1, 3) + 1) + b
end

function iQaerp(t, d, b, c)
	return (c - b) * pow(clmp(t, 0, d) / d, 4) + b
end

function oQaerp(t, d, b, c)
	return -(c - b) * (pow(clmp(t, 0, d) / d - 1, 4) - 1) + b
end

function ioQaerp(t, d, b, c)
	local cp = clmp(t, 0, d)
	if cp < 1 then return (c - b) / 2 * pow(cp, 4) + b end

	return -(c - b) / 2 * (pow(cp - 2, 4) - 2) + b
end

function iQuerp(t, d, b, c)
	return (c - b) * pow(clmp(t, 0, d) / d, 5) + b
end

function oQuerp(t, d, b, c)
	return (c - b) * (pow(clmp(t, 0, d) / d - 1, 5) + 1) + b
end

function ioQuerp(t, d, b, c)
	local cp = clmp(t, 0, d)
	if cp < 1 then return (c - b) / 2 * pow(cp, 5) + b end

	return (c - b) / 2 * (pow(cp - 2, 5) + 2) + b
end

function iSerp(t, d, b, c)
	return -(c - b) * cos(clmp(t, 0, d) / d * pih) + (c - b) + b
end

function oSerp(t, d, b, c)
	return (c - b) * sin(clmp(t, 0, d) / d * pih) + b
end

function ioSerp(t, d, b, c)
	return -(c - b) / 2 * (cos(pi * clmp(t, 0, d) / d) - 1) + b
end

function iExerp(t, d, b, c)
	local cp = clmp(t, 0, d)
	if cp == 0 then return b end

	return (c - b) * pow(2, 10 * (cp / d - 1)) + b - (c - b) * 0.001
end

function oExerp(t, d, b, c)
	local cp = clmp(t, 0, d)
	if cp == d then return b + (c - b) end

	return (c - b) * 1.001 * (-pow(2, -10 * cp / d) + 1) + b
end

function ioExerp(t, d, b, c)
	local cp = clmp(t, 0, d)
	if cp == 0 then return b end
	if cp == d then return b + (c - b) end
	if cp < 1 then return (c - b) / 2 * pow(2, 10 * (cp - 1)) + b - (c - b) * 0.0005 end

	return (c - b) / 2 * 1.0005 * (-pow(2, -10 * (cp - 1)) + 2) + b
end

function iCierp(t, d, b, c)
	return -(c - b) * (sqrt(1 - pow(clmp(t, 0, d) / d, 2)) - 1) + b
end

function oCierp(t, d, b, c)
	return (c - b) * sqrt(1 - pow(clmp(t, 0, d) / d - 1, 2)) + b
end

function Berp(t, d, b, c, s)
	s = s or 1.70158
	local cp = clmp(t, 0, d)

	return (c - b) * cp * cp * ((s + 1) * cp - s) + b
end