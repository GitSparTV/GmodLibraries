local API = api("Inform")
API:AddClientMethod("ChatBasic", "s")
API:AddClientMethod("ChatColor", "su8")
API:AddClientMethod("ChatCustom", "A")
API:AddClientMethod("ChatGlobal", "A")
API:AttachToNetwork()
API:Activate()
inform = {}
COLOR_WHITE = Color(255, 255, 255)
COLOR_BLACK = Color(0, 0, 0)
COLOR_SBOX = Color(18, 149, 241)

ColorLookup = {
	[COLOR_WHITE] = 1,
	[COLOR_BLACK] = 2,
	[COLOR_SBOX] = 3
}

function inform.Chat(ply, text)
	API:Send(ply, "ChatBasic", {text})
end

function inform.CharColor(ply, text, color)
	API:Send(ply, "ChatColor", {text, color})
end

function inform.ChatCustom(ply, table)
	API:Send(ply, "ChatCustom", table)
end

do
	local isstring, isnumber, print, tableconcat = isstring, isnumber, print, table.concat

	function inform.ChatGlobal(tbl)
		API:Send(true, "ChatGlobal", tbl)

		for k = 1, #tbl do
			local v = tbl[k]

			if isstring(v) then
				if v:sub(1, 5) == "LANG_" then
					tbl[k] = LANG[tbl[k]:sub(6)]
				end
			elseif isnumber(v) then
				tbl[k] = ""
			end
		end

		print(tableconcat(tbl))
	end
end

-- function UI.Notus(ply, title, text, color, add)
-- 	API:Send(ply, "sbn.add", {title, text, color, add or {}})
-- end
-- function UI.SkinNotus(ply, title, text, skin, add)
-- 	API:Send(ply, "sbn.skinadd", {title, text, skin, add or {}})
-- end
-- function UI.NotusFrame(ply, title, text)
-- 	API:Send(ply, "sbn.frame", {title, text})
-- end
do
	local print, tableconcat, BLACK, SBOX, WHITE = print, table.concat, ColorLookup[COLOR_BLACK], ColorLookup[COLOR_SBOX], ColorLookup[COLOR_WHITE]

	concommand.Add("sparsay", function(ply, cmd, args, argStr)
		if ply:IsValid() then return end
		print(ply, cmd, args, argStr)
		inform.ChatGlobal({BLACK, "[", SBOX, "LANG_SPAR_BY_CONSOLE", BLACK, "] ", WHITE, tableconcat(args, " ")})
	end, nil, nil, FCVAR_PROTECTED)
end