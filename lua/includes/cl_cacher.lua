do
	cacher__LocalPlayer = cacher__LocalPlayer or LocalPlayer

	do
		local LP = cacher__LocalPlayer()

		function LocalPlayer()
			return LP
		end

		LPLY = LocalPlayer

		hook.Add("InitPostEntity", "CacheLocalPlayer", function()
			LP = cacher__LocalPlayer()
			hook.Remove("InitPostEntity", "CacheLocalPlayer")
		end)

	end
end

do
	cacher__W,cacher__H = cacher__W or ScrW,cacher__H or ScrH

	do
		local valW,valH = cacher__W(),cacher__H()

		function ScrW()
			return valW
		end

		function ScrH()
			return valH
		end
		
		hook.Add("OnScreenSizeChanged","SBox.OnScreenSizeChangedCache",function(w,h)
			valW,valH = w,h
		end)
	end
end