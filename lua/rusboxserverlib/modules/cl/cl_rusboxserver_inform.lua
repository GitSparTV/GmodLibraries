local API = api("Inform")
API:Activate()
API:AttachToNetwork()
COLOR_WHITE = Color(255, 255, 255)
COLOR_BLACK = Color(0, 0, 0)
COLOR_SBOX = Color(18, 149, 241)
COLOR_GRAY = Color(50,50,50)
COLOR_LIGHTGRAY = Color(127,127,127)
COLOR_BUILDZONE = Color(241,222,18)
ColorLookup = {COLOR_WHITE, COLOR_BLACK, COLOR_SBOX}

do
	local AddText, ColorLookup = chat.AddText, ColorLookup

	API:AddMethod("ChatBasic", function(self, args)
		AddText(COLOR_BLACK, "[", COLOR_SBOX, "SBox", COLOR_BLACK, "]", COLOR_WHITE, " " .. args[1])
	end, "s")

	API:AddMethod("ChatColor", function(self, args)
		AddText(COLOR_BLACK, "[", COLOR_SBOX, "SBox", COLOR_BLACK, "]", ColorLookup[args[2]], " " .. args[1])
	end, "su8")

	do
		local isnumber, unpack, isstring = isnumber, unpack, isstring

		API:AddMethod("ChatCustom", function(self, args)
			args = args[1]

			for i = 1, #args do
				if isnumber(args[i]) then
					args[i] = ColorLookup[args[i]]
				end
			end

			AddText(unpack(args))
		end, "A")

		API:AddMethod("ChatGlobal", function(self, args)
			args = args[1]

			for i = 1, #args do
				local v = args[i]

				if isnumber(v) then
					args[i] = ColorLookup[v]
				elseif isstring(v) and v:sub(1, 5) == "LANG_" then
					args[i] = LANG[v:sub(6)]
				end
			end

			AddText(unpack(args))
		end, "A")
	end
end

-- do
-- -- local SBNAdd,SBNAddSkin,SBNNotusFrame = SBN.Add,SBN.AddSkin,SBN.NotusFrame
-- API:AddMethod("SBNAdd", function(self, args)
-- 	SBN.Add(args[1], args[2], args[3], args[4] or {})
-- end)
-- API:AddMethod("SBNSkinAdd", function(self, args)
-- 	SBN.AddSkin(args[1], args[2], args[3], args[4] or {})
-- end)
-- API:AddMethod("SBNNotusFrame", function(self, args)
-- 	SBN.NotusFrame(args[1], args[2])
-- end)
-- end
API:Register()