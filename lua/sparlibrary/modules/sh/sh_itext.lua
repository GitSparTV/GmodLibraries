itext = {}
utf8.dash = utf8.char(8212)
utf8.dot3 = "..."

--[[itext.RSuff.Kit--------------------------------------------------------]]
--
-- Конструктор Русских Окончаний
-- 1) Цифры 0 и 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
-- 2) Цифра 1
-- 3) Цифры 2,3,4
do
	itext.RSuff = {}

	function itext.RSuff.Kit(var05, var1, var234)
		return function(num)
			num = num % 100
			local m10 = num % 10
			if m10 == 0 or (num >= 11 and num <= 14) or m10 >= 5 then return var05 end

			return m10 == 1 and var1 or var234
		end
	end

	-- Т, Д
	-- через 0 минут, 1 минуту, 2 минуты
	-- через 0 секунд, 1 секунду, 2 секунды
	itext.RSuff.YU = itext.RSuff.Kit("", "у", "ы")
	-- С
	-- через 0 часов, 1 час, 2 часа
	itext.RSuff.AOV = itext.RSuff.Kit("ов", "", "а")
	-- Д
	-- через 0 дней, 1 день, 2 дня
	itext.RSuff.DAY = itext.RSuff.Kit("дней", "день", "дня")
end

--[[itext.RSuff.Kit--------------------------------------------------------]]
--
-- REWRITE
do
	local stringsub, stringfind = string.sub, string.find

	function itext.Split32(text)
		local tbl, caret = {}, 0

		while true do
			local found = stringfind(text, " ", caret, true)

			if not found then
				tbl[#tbl + 1] = #tbl == 0 and text or stringsub(text, caret)
				break
			end

			tbl[#tbl + 1] = stringsub(text, caret, found)
			caret = found + 2
		end

		return tbl
	end
end

do
	local utf8codes, utf8char = utf8.codes, utf8.char

	function itext.SplitEach(text)
		local tbl = {}

		for k, char in utf8codes(text) do
			tbl[#tbl + 1] = utf8char(char)
		end

		return tbl
	end
end

do
	local stringsub = string.sub

	function itext.SplitEachASCII(text)
		local tbl = {}

		for I = 1, #text do
			tbl[I] = stringsub(text, I, I)
		end

		return tbl
	end
end

do
	local stringsub = string.sub

	function itext.Split(text, terminator)
		local tbl, len, ss = {}, #text, 1

		for I = 1, len do
			if stringsub(text, I, I) ~= terminator and I ~= len then
				goto cont
			end

			tbl[#tbl + 1] = stringsub(text, ss, I == len and I or I - 1)
			ss = I + 1
			::cont::
		end

		return tbl
	end
end

-------------------
--  TEXT ASCII ENCODE
-------------------
do
	local tableconcat, stringsub = table.concat, string.sub

	function itext.ASCIIEncode(text)
		local tbl = {}

		for I = 1, #text do
			tbl[I] = stringsub(text, I, I):byte()
		end

		return tableconcat(tbl, " ")
	end
end

-------------------
--  TEXT ASCII TO TABLE
-------------------
do
	local tableconcat, itextSplit32 = table.concat, itext.Split32

	function itext.ASCIIDecode(text)
		local exp = itextSplit32(text)

		for I = 1, #exp do
			exp[I] = exp[I]:char()
		end

		return tableconcat(exp)
	end
end

-------------------
--  TEXT ASCII TO TABLE
-------------------
do
	local stringsub = string.sub

	function itext.ASCIIToTable(text)
		local tbl = {}

		for I = 1, #text do
			tbl[I] = stringsub(text, I, I):byte()
		end

		return tbl
	end
end

--[[
	for k,v in pairs(tbl) do
		if v != "" and v != nil and v != " " then
			if not table.HasValue(ignore,k) then
				if itext.IsASCII2Byte(tbl[k],tbl[k+1]) == 1 then
					table.insert(exit,tbl[k].." "..tbl[k+1])
					table.insert(ignore,k+1)
				else
					table.insert(exit,tostring(tbl[k]))
				end
			end
		end
	end
]]
-- -------------------
-- --  ASCII FINDER
-- -------------------
-- function itext.IsASCII2Byte(F,S)
-- if F == nil or S == nil then return 0 end
-- if F == "" or S == "" then return 0 end
-- if F == " " or S == " " then return 0 end
-- F = tonumber(F) or 0
-- S = tonumber(S) or 0
-- local b1,b2 = 0,0
-- if 194 <= F and F <= 223 and F != 10 then b1 = 1 end
-- if 128 <= S and S <= 191 and S != 10 then b2 = 1 end
-- 	return bit.band(b1,b2)
-- end
-------------------
--  TEXT SIZE IN PIXELS
-------------------
if CLIENT then
	local surfaceGetTextSize, surfaceSetFont = surface.GetTextSize, surface.SetFont

	function itext.TextSize(text, font)
		surfaceSetFont(font)

		return surfaceGetTextSize(text)
	end
end

-------------------
--  TEXT UTF-8 LENGTH 
-------------------
itext.Len = utf8.len

-------------------
--  TEXT UTF-8 ENCODE
-------------------
do
	local utf8codes, tableconcat = utf8.codes, table.concat

	function itext.Encode(text)
		local tbl = {}

		for k, v in utf8codes(text) do
			tbl[#tbl + 1] = v
		end

		return tableconcat(tbl, " ")
	end
end

-------------------
--  TEXT UTF-8 DECODE
-------------------
do
	local tonumber, tableconcat, istable, itextSplit32, utf8char = tonumber, table.concat, istable, itext.Split32, utf8.char

	function itext.Decode(text)
		local exp = istable(text) and text or itextSplit32(text)

		for I = 1, #exp do
			exp[I] = utf8char(tonumber(exp[I]))
		end

		return tableconcat(exp)
	end
end

-------------------
--  NIBBLE NUMERIC CONCATENATION ENCODING
-------------------
-- function itext.NNCEncode(...)
-- 	local t = {...}
-- 	for k, v in pairs(t) do
-- 		if string.find(v, "[^%d]") then return print("FOUND") end
-- 		local cache = ""
-- 		if isstring(v) then
-- 			cache = "1100"
-- 		end
-- 		v = tostring(v)
-- 		for K, V in pairs(itext.ToTable(v)) do
-- 			cache = cache .. math.DecToBin(V, 4)
-- 		end
-- 		t[k] = cache
-- 	end
-- 	return tableconcat(t, "1011")
-- end
-- function itext.NNCDecode(line)
-- 	local t1, t2 = {}, {}
-- 	t1 = itext.Split
-- 	local I, stringFlag = 1, false
-- 	for k, v in pairs(t1) do
-- 		if v == "1100" then
-- 			stringFlag = true
-- 			goto cont
-- 		end
-- 		if v == "1011" then
-- 			I = I + 1
-- 			if not stringFlag then
-- 				t2[I] = tonumber(t2[I])
-- 			end
-- 			stringFlag = false
-- 			goto cont
-- 		end
-- 		t2[I] = (t2[I] or "") .. tonumber(v, 2)
-- 		::cont::
-- 	end
-- 	return t2
-- end
-------------------
--  FORCE ASCII FORMAT
-------------------
do
	local utf8len, stringsub = utf8.len, string.sub

	function itext.ForceEncode(text)
		local s, pos = utf8len(text)

		return s and text or stringsub(text, 1, pos)
	end
end

-------------------
--  TEXT WRAP BY LENGTH
-------------------
do
	local itextSplitEach, tableconcat = itext.SplitEach, table.concat

	function itext.LenWrap(text, charlimit, hardness)
		local input, output, lastn, lastspaceo, lastspacec = itextSplitEach(text), {}, 0, 0

		for caret = 1, #input do
			do
				local char = input[caret]
				output[#output + 1] = char

				if char == "\n" then
					lastn = caret
					lastspaceo, lastspacec = 0, 0
					goto cont
				elseif char == " " then
					lastspaceo, lastspacec = #output, caret
				end
			end

			do
				local lookahead = input[caret + 1]

				if (caret - lastn) >= charlimit and lookahead then
					if lastspaceo ~= 0 and not hardness then
						output[lastspaceo] = "\n"
						lastn = lastspacec
					else
						if lookahead ~= "\n" then
							output[#output + 1] = "\n"
						end

						lastn = caret
					end

					lastspaceo, lastspacec = 0, 0
				end
			end

			::cont::
		end

		return tableconcat(output)
	end
end

-------------------
--  TEXT WRAP BY PIXELS
-------------------
if CLIENT then
	local mathfloor, tableconcat, itextSplitEach, surfaceGetTextSize = math.floor, table.concat, itext.SplitEach, surface.GetTextSize

	function itext.Wrap(text, maxW, hardness, maxY)
		local input, output, buf, lastspaceo, lastspacec, ncount, nsize = itextSplitEach(text), {}, "", 0, 0, 0

		if maxY then
			text, nsize = surfaceGetTextSize(" ")
			maxY = mathfloor(maxY / nsize)
		end

		for caret = 1, #input do
			do
				local char = input[caret]
				output[#output + 1] = char
				buf = buf .. char

				if char == "\n" then
					lastn = caret
					lastspaceo, lastspacec = 0, 0
					ncount = ncount + 1
					goto cont
				elseif char == " " then
					lastspaceo, lastspacec = #output, caret
				end
			end

			do
				local lookahead, len = input[caret + 1]

				if lookahead then
					len = surfaceGetTextSize(buf .. lookahead)
				else
					len = surfaceGetTextSize(buf)
				end

				if len >= maxW then
					if lastspaceo ~= 0 and not hardness then
						output[lastspaceo] = "\n"
						ncount = ncount + 1
						buf = ""
						lastn = lastspacec
					else
						if lookahead ~= "\n" then
							output[#output + 1] = "\n"
							ncount = ncount + 1
							if maxY and ncount >= maxY then return tableconcat(output, "", 1, #output) end
						end

						buf = ""
						lastn = caret
					end

					lastspaceo, lastspacec = 0, 0
				end
			end

			::cont::
		end

		return tableconcat(output)
	end
end

-------------------
--  TEXT FOLD BY LENGTH
-------------------
do
	local utf8offset, stringsub, itextLen = utf8.offset, string.sub, itext.Len
	function itext.LenFold(text, cutsym)
		if itextLen(text) <= cutsym then return text end
		return stringsub(text,1,utf8offset(text,cutsym))
	end
end

-------------------
--  TEXT FOLD BY PIXELS
-------------------
if CLIENT then
	local tableconcat, itextSplitEach, surfaceGetTextSize = table.concat, itext.SplitEach, surface.GetTextSize

	function itext.Fold(text, sizex)
		local input = itextSplitEach(text)
		if surfaceGetTextSize(text) < sizex then return text end
		local lend3 = surfaceGetTextSize("...")

		for I = 1, #input do
			local buf = tableconcat(input, nil, nil, I)
			if surfaceGetTextSize(buf) + lend3 >= sizex then return buf .. "..." end
		end
	end
end

do
	local mathsin, SysTime = math.sin, SysTime

	function itext.Scroll(len, maxlen, speed)
		return mathsin(SysTime() * (speed or 1)) * (len - maxlen) / 2
	end
end

-------------------
--  TEXT FORMAT
-------------------
do
	local itextSplitEach, tableconcat = itext.SplitEach, table.concat

	function itext.Format(text)
		local input, output, skipc, textstart = itextSplitEach(text), {}, 0

		for I = 1, #input do
			local char, lookahead, lookback = input[I], input[I + 1], input[I - 1]

			if skipc > 0 then
				skipc = skipc - 1
				goto skip
			end

			if char == " " then
				if not textstart then
					goto skip
				end

				if lookahead then
					if lookahead == " " or lookahead == "\n" then
						goto skip
					end
				else
					goto skip
				end

				if lookback == "\n" then
					goto skip
				end
			elseif char == "\n" and (not lookahead or lookahead == "\n") then
				goto skip
			elseif char == "-" and lookahead == "-" then
				skipc = 1
				output[#output + 1] = utf8dash
				goto skip
			end

			textstart = true
			output[#output + 1] = char
			::skip::
		end

		return tableconcat(output)
	end
end

--[[-------------------------------------------------------------------------
Garry's mod Text Markdown (Disabled, unused)
---------------------------------------------------------------------------]]
--
--
-- itext.gtm = {}
-- --
-- function itext.gtm.pack(tbl)
-- 	local gtmtable = {}
-- 	local ID = tbl["id"]
-- 	local DATESTAMP = tbl["datestamp"]
-- 	local TEXT = tbl["text"]
-- 	gtmtable["id"] = ID
-- 	gtmtable["datestamp"] = DATESTAMP
-- 	gtmtable["body"] = {
-- 		{
-- 			type = "plain",
-- 			text = TEXT
-- 		}
-- 	}
-- 	gtmtable = itext.gtm.MatchPlain(gtmtable) -- type "ignore"
-- 	gtmtable = itext.gtm.MatchHead(gtmtable) -- type "head"
-- 	gtmtable = itext.gtm.MatchURL(gtmtable) -- type "url"
-- 	gtmtable = itext.gtm.MatchImage(gtmtable) -- key "image"
-- 	return gtmtable
-- end
-- function itext.gtm.MatchPlain(gtmtable)
-- 	if not istable(gtmtable) then return {} end
-- 	local body = gtmtable["body"]
-- 	for k, v in pairs(body) do
-- 		if v["type"] == "plain" then
-- 			local text = v["text"]
-- 			local s, e = string.find(text, "%[plain%].-%[/plain%]")
-- 			if s ~= nil then
-- 				local found = string.sub(text, s, e)
-- 				if string.StartWith(found, "[plain]") and string.EndsWith(found, "[/plain]") then
-- 					found = string.sub(found, 8, #found - 8)
-- 					left = string.Left(text, s - 1)
-- 					right = string.Right(text, #text - e)
-- 					body[k]["text"] = left
-- 					table.insert(body, k + 1, {
-- 						type = "ignore",
-- 						text = found
-- 					})
-- 					table.insert(body, k + 2, {
-- 						type = "plain",
-- 						text = right
-- 					})
-- 				end
-- 			end
-- 		end
-- 	end
-- 	return gtmtable
-- end
-- function itext.gtm.MatchHead(gtmtable)
-- 	if not istable(gtmtable) then return {} end
-- 	local body = gtmtable["body"]
-- 	for k, v in pairs(body) do
-- 		if v["type"] == "plain" then
-- 			local text = v["text"]
-- 			local s, e = string.find(text, "%[h1%].-%[/h1%]")
-- 			if s ~= nil then
-- 				local found = string.sub(text, s, e)
-- 				if string.StartWith(found, "[h1]") and string.EndsWith(found, "[/h1]") then
-- 					found = string.sub(found, 5, #found - 5)
-- 					left = string.Left(text, s - 1)
-- 					right = string.Right(text, #text - e)
-- 					body[k]["text"] = left
-- 					table.insert(body, k + 1, {
-- 						type = "head",
-- 						text = found
-- 					})
-- 					table.insert(body, k + 2, {
-- 						type = "plain",
-- 						text = right
-- 					})
-- 				end
-- 			end
-- 		end
-- 	end
-- 	return gtmtable
-- end
-- function itext.gtm.MatchImage(gtmtable)
-- 	if not istable(gtmtable) then return {} end
-- 	if not gtmtable["images"] then
-- 		gtmtable["images"] = {}
-- 	end
-- 	local body = gtmtable["body"]
-- 	local images = gtmtable["images"]
-- 	for k, v in pairs(body) do
-- 		if v["type"] == "plain" then
-- 			local text = v["text"]
-- 			local s, e = string.find(text, "%[image%].-%[/image%]")
-- 			if s ~= nil then
-- 				local found = string.sub(text, s, e)
-- 				if string.StartWith(found, "[image]") and string.EndsWith(found, "[/image]") then
-- 					found = string.sub(found, 8, #found - 8)
-- 					if string.find(found, "%.[a-z]*%/") ~= nil then
-- 						body[k]["text"] = string.gsub(body[k]["text"], "%[image%]" .. found .. "%[/image%]", "")
-- 						if string.StartWith(found, "http://") then
-- 							found = string.sub(found, 8, #found)
-- 						end
-- 						if string.StartWith(found, "https://") then
-- 							found = string.sub(found, 9, #found)
-- 						end
-- 						found = "http://" .. found
-- 						table.insert(images, found)
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- 	return gtmtable
-- end
-- function itext.gtm.MatchURL(gtmtable)
-- 	if not istable(gtmtable) then return {} end
-- 	local body = gtmtable["body"]
-- 	for k, v in pairs(body) do
-- 		if v["type"] == "plain" then
-- 			local text = v["text"]
-- 			local s, e = string.find(text, "%[url%].-%[/url%]")
-- 			if s ~= nil then
-- 				local found = string.sub(text, s, e)
-- 				if string.StartWith(found, "[url]") and string.EndsWith(found, "[/url]") then
-- 					found = string.sub(found, 6, #found - 6)
-- 					if string.find(found, "%.[a-z]*%/") ~= nil then
-- 						if string.StartWith(found, "http://") or string.StartWith(found, "https://") then
-- 							if string.StartWith(found, "http://") then
-- 								found = string.sub(found, 8, #found)
-- 							end
-- 							if string.StartWith(found, "https://") then
-- 								found = string.sub(found, 9, #found)
-- 							end
-- 							found = "http://" .. found
-- 							left = string.Left(text, s - 1)
-- 							right = string.Right(text, #text - e)
-- 							body[k]["text"] = left
-- 							table.insert(body, k + 1, {
-- 								type = "url",
-- 								text = found
-- 							})
-- 							table.insert(body, k + 2, {
-- 								type = "plain",
-- 								text = right
-- 							})
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- 	return gtmtable
-- end
if CLIENT then
	function ScrollText(text, font, w, speed)
		local len, h = TextSize(text, font)

		return w - (SysTime() * (speed or 120)) % (w + len * 1.5)
	end
end

local CyrUppers = {
	["й"] = "Й",
	["ц"] = "Ц",
	["у"] = "У",
	["к"] = "К",
	["е"] = "Е",
	["н"] = "Н",
	["г"] = "Г",
	["ш"] = "Ш",
	["щ"] = "Щ",
	["з"] = "З",
	["х"] = "Х",
	["ъ"] = "Ъ",
	["ф"] = "Ф",
	["ы"] = "Ы",
	["в"] = "В",
	["а"] = "А",
	["п"] = "П",
	["р"] = "Р",
	["о"] = "О",
	["л"] = "Л",
	["д"] = "Д",
	["ж"] = "Ж",
	["э"] = "Э",
	["я"] = "Я",
	["ч"] = "Ч",
	["с"] = "С",
	["м"] = "М",
	["и"] = "И",
	["т"] = "Т",
	["ь"] = "Ь",
	["б"] = "Б",
	["ю"] = "Ю",
	["ё"] = "Ё"
}

function CyrUpper(text)
	local output = {}

	for k, v in utf8codes(text) do
		local char = utf8char(v)
		output[#output + 1] = CyrUppers[char] and CyrUppers[char] or char:upper()
	end

	return tableconcat(output)
end