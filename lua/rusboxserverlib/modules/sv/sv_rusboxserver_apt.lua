local count = 0
local info = database("sboxserver/AddonUpdater.dat")
info:Setup()
local dbh = info:GetHandle()
local MODE_INCLUDE = 1
local MODE_GITHUB = 2
local MODE_NOUPDATECHECK = 4

local FAILFUNC = function(...)
	print("FAIL", ...)
end

-- local workshop = {
-- 	["Simfphys Base"] = {
-- 		id = "771487490"
-- 	},
-- 	["Adv. Ballsocket"] = {
-- 		id = "107257490"
-- 	},
-- 	["Advanced Duplicator 2"] = {
-- 		id = "773402917",
--		path = "wiremod/advdupe2",
-- 		mode = MODE_GITHUB
-- 	},
-- 	["Anti-NoClip"] = {
-- 		id = "150642811"
-- 	},
-- 	["Axis and Ballsocket Centre"] = {
-- 		id = "457466766"
-- 	},
-- 	["Easy Advanced Ballsocket"] = {
-- 		id = "644370097"
-- 	},
-- 	["Easy Ballsocket"] = {
-- 		id = "260402394"
-- 	},
-- 	["Empty Hands SWEP"] = {
-- 		id = "245482078"
-- 	},
-- 	["Extended SpawnMenu"] = {
-- 		id = "104603291"
-- 	},
-- 	["Fading Doors"] = {
-- 		id = "1194927696"
-- 	},
-- 	["Fin 2"] = {
-- 		id = "165509582"
-- 	},
-- 	["gm_bigcity"] = {
-- 		id = "105982362"
-- 	},
-- 	["gm_bigcity navmesh"] = {
-- 		id = "710889135"
-- 	},
-- 	["LED Signs"] = {
-- 		id = "1784911999"
-- 	},
-- 	["Make Spherical"] = {
-- 		id = "136318146"
-- 	},
-- 	["Material Tool"] = {
-- 		id = "746600040"
-- 	},
-- 	["Material Menu"] = {
-- 		id = "110666990"
-- 	},
-- 	["Measuring Stick"] = {
-- 		id = "107086721"
-- 	},
-- 	["MediaPlayer"] = {
-- 		id = "546392647"
-- 	},
-- 	["MIDI Driver"] = {
-- 		id = "492931567"
-- 	},
-- 	["More Materials"] = {
-- 		id = "105841291"
-- 	},
-- 	["OptiWeld"] = {
-- 		id = "1693027072"
-- 	},
-- 	["Parent Tool"] = {
-- 		id = "111929524"
-- 	},
-- 	["Synthesizers"] = {
-- 		id = "922947756"
-- 	},
-- 	["Precision tool"] = {
-- 		id = "104482086"
-- 	},
-- 	["Precision Alignment"] = {
-- 		id = "457478322"
-- 	},
-- 	["Shared Attachments"] = {
-- 		id = "852242061"
-- 	},
-- 	["RTCam"] = {
-- 		id = "106944414"
-- 	},
-- 	["SBox Content"] = {
-- 		id = "949191667"
-- 	},
-- 	["Seat Anywhere"] = {
-- 		id = "108176967"
-- 	},
-- 	["Simfphys Shared Textures"] = {
-- 		id = "1258744627"
-- 	},
-- 	["Simfphys Other Pack"] = {
-- 		id = "792139827"
-- 	},
-- 	["SmartSnap"] = {
-- 		id = "104815552"
-- 	},
-- 	["SProps"] = {
-- 		id = "173482196"
-- 	},
-- 	["Stacker"] = {
-- 		id = "104479831"
-- 	},
-- 	["SubMaterial"] = {
-- 		id = "405793043"
-- 	},
-- 	["TFA Base"] = {
-- 		id = "415143062",
-- 	},
-- 	["TFA CSO2 Heavy"] = {
-- 		id = "938487228"
-- 	},
-- 	["TFA CSO2 Main"] = {
-- 		id = "938487773"
-- 	},
-- 	["TFA CSO2 Small"] = {
-- 		id = "938487898"
-- 	},
-- 	["SimpleThirdPerson"] = {
-- 		id = "207948202"
-- 	},
-- 	["Track Assembly"] = {
-- 		id = "287012681"
-- 	},
-- 	["ULib"] = {
-- 		id = "557962238",
-- 	},
-- 	["ULX"] = {
-- 		id = "557962280",
-- 		path = "TeamUlysses/ulx",
-- 		mode = MODE_INCLUDE + MODE_GITHUB
-- 	},
-- 	["UTime"] = {
-- 		id = "657474627"
-- 	},
-- 	["Weight Tool"] = {
-- 		id = "492447696"
-- 	},
-- 	["Weld Smart"] = {
-- 		id = "131586620"
-- 	},
-- 	["Wire Extras"] = {
-- 		path = "wiremod/wire-extras",
-- 		mode = MODE_GITHUB
-- 	},
-- 	["Wiremod"] = {
-- 		id = "160250458",
-- 		path = "wiremod/wire",
-- 		mode = MODE_INCLUDE + MODE_GITHUB
-- 	},
-- 	["World Brand Logos"] = {
-- 		id = "1643960529"
-- 	},
-- 	["WUMA"] = {
-- 		id = "1117436840"
-- 	}
-- }
local GetUpdates,UpdateAll

do
	local toupdate,PrintUpdates = {}

	do
		local print, pairs, info, istable, ostime = print, pairs, info, istable, os.time

		function PrintUpdates()
			if count <= -1 then return end

			if count > 0 then
				print("[Addon Updater] Some addons were failed to fetch the version!")
				count = -1

				return
			end

			count = -1
			local shownonce = false

			for k, v in pairs(info:GetTable()) do
				if istable(v) and v.CurrentVersion and v.LatestVersion and v.CurrentVersion ~= v.LatestVersion then
					shownonce = true
					toupdate[#toupdate + 1] = k
					print("[Addon Updater] Addon \"" .. k .. "\" (" .. (v.id or v.path) .. ") has new version [" .. v.LatestVersion .. "]. Current: [" .. v.CurrentVersion .. "]")
				elseif istable(v) and not v.LatestVersion then
					print("[Addon Updater] Addon \"" .. k .. "\" (" .. (v.id or v.path) .. ") doesn't have information about the latest version!")
				end
			end

			if not shownonce then
				print("[Addon Updater] No updates or nothing to compare.")
			end

			dbh.LastUpdate = ostime()
		end
	end

	function UpdateAll()
		for k=1, #toupdate do
			apt_get.upgrade(toupdate[k])
		end
	end

	local GetWorkshopVersion

	do
		local httpFetch, stringfind, fileWrite, error, stringgmatch = http.Fetch, string.find, file.Write, error, string.gmatch

		function GetWorkshopVersion(name, id)
			httpFetch("https://steamcommunity.com/workshop/filedetails/?id=" .. id, function(body)
				local backup = body
				local _, e = stringfind(body, "<div class=\"detailsStatsContainerRight\">", 1, true)

				if not e then
					fileWrite("updaterbodyerror_workshop.txt", backup)
					error("[Addon Updater] Can't find 1 for " .. id)
				end

				body = body:sub(e, -1)
				local found = {}

				for k in stringgmatch(body, "<div class=\"detailsStatRight\">(.-)</div>") do
					found[#found + 1] = k
				end

				if #found == 0 or #found == 1 then
					fileWrite("updaterbodyerror_workshop.txt", backup)
					error("[Addon Updater] Can't find 2 for " .. id)
				end

				dbh[name].LatestVersion = found[3] or found[2]
				count = count - 1

				if count == 0 then
					PrintUpdates()
				end
			end, FAILFUNC)
		end

		local GetGitHubVersion

		do
			local stringmatch = string.match

			function GetGitHubVersion(name, path)
				httpFetch("https://github.com/" .. path .. "/commits/master", function(body)
					local date = stringmatch(body, "<div class=\"commit%-group%-title\">%s-<svg class=\"octicon octicon%-git%-commit\" .-></svg>Commits on (.-)%s-</div>")

					if not date then
						fileWrite("updaterbodyerror_github.txt", "https://github.com/" .. path .. "\n\n" .. body)
						error("[Addon Updater] Can't find 3 in " .. path)
					end

					dbh[name].LatestVersion = date
					count = count - 1

					if count == 0 then
						PrintUpdates()
					end
				end, FAILFUNC)
			end
		end

		do
			local pairs, istable, bitband, resourceAddWorkshop, timerSimple = pairs, istable, bit.band, resource.AddWorkshop, timer.Simple

			function GetUpdates()
				if count > 0 then return end
				local i = 0

				for k, v in pairs(info:GetTable()) do
					if not istable(v) then
						goto cont
					end

					if v.mode then
						if bitband(v.mode, MODE_INCLUDE) == MODE_INCLUDE then
							resourceAddWorkshop(v.id)
						end

						if bitband(v.mode, MODE_NOUPDATECHECK) == 0 then
							count = count + 1

							if bitband(v.mode, MODE_GITHUB) == MODE_GITHUB then
								timerSimple(i, function()
									GetGitHubVersion(k, v.path)
									i = i + 0.1
								end)
							else
								timerSimple(i, function()
									GetWorkshopVersion(k, v.id)
									i = i + 0.1
								end)
							end
						else
							resourceAddWorkshop(v.id)
						end
					else
						count = count + 1

						timerSimple(i, function()
							GetWorkshopVersion(k, v.id)
							i = i + 0.1
						end)

						resourceAddWorkshop(v.id)
					end

					::cont::
				end

				print("[Addon Updater] Fetching information about " .. count .. " addons...")
				timerSimple(60, PrintUpdates)
			end
		end
	end
end

local GetAddonsInfo

do
	local pairs, tostring = pairs, tostring

	function GetAddonsInfo()
		for k, v in pairs(info:GetTable()) do
			print(k .. " (" .. (v.id or v.path) .. ")\t\t\tLatest: " .. tostring(v.LatestVersion) .. "\tCurrent: " .. tostring(v.CurrentVersion))
		end
	end
end

local function GetAddonsChecked()
	return count
end

local UpdateAddon

do
	local tostring = tostring

	function UpdateAddon(name)
		if not dbh[name] then
			print("[Addon Updater] No such addon \"" .. name .. "\"!")

			return
		end

		if not dbh[name].LatestVersion then
			print("[Addon Updater] This addon doesn't have information about the latest version!")

			return
		end

		print("[Addon Updater] Addon \"" .. name .. "\" was updated to \"" .. tostring(dbh[name].LatestVersion) .. "\" (Currently: \"" .. tostring(dbh[name].CurrentVersion) .. "\")")
		dbh[name].CurrentVersion = dbh[name].LatestVersion
	end
end

local function AddAddon(name, tbl)
	print("Added "..name)
	dbh[name] = tbl
end

local function RemoveAddon(name)
	dbh[name] = nil
end

apt_get = {
	update = GetUpdates,
	upgradeall = UpdateAll,
	list = GetAddonsInfo,
	updaten = GetAddonsChecked,
	check = PrintUpdates,
	upgrade = UpdateAddon,
	install = AddAddon,
	remove = RemoveAddon
}

if os.difftime(os.time(), dbh.LastUpdate or 0) >= 86400 then
	timer.Simple(60, GetUpdates)
end