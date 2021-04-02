SBox = SBox or {}
local API = api("Global")
API:Activate()
API:AttachToNetwork()
API:Register()
debug.Point()

do
	local Exists = file.Exists

	hook.Add("EntityEmitSound", "SBox.MissingSound", function(t)
		local n = t.SoundName
		if string.find(n,"^",1,true) or string.find(n,")",1,true) then n = n:sub(2) end
		if not Exists("sound/"..n, "GAME") then return false end
	end)
end


hook.Add("HUDPaint", "a", function()
	-- draw.RoundedBox(4, 0, 0, ScrW(), ScrH(), COLOR_BLACK)
	-- local h = 0

	-- for i = 1, #SBoxFonts do
	-- 	local name = "SBOX_FONT_" .. SBoxFonts[i]
	-- 	draw.SimpleText("Шрифт " .. name, name, 50, 50 + h, Color(255, 255, 255))
	-- 	h = h + tonumber(string.match(name, "(%d+)")) * SCALE
	-- end
	-- draw.NoTexture()
	-- surface.SetDrawColor(COLOR_BLACK)
	-- surface.DrawTexturedRect(0,0,ScrW(),ScrH())
	-- draw.SimpleText("Start","SBOX_FONT_17",0,0,COLOR_WHITE)
end)

--[[
	CHUDQuickInfo	=	true,
	CHudSuitPower	=	true,]]
---

local function layer(n)
    cam.Start2D()
    	draw.NoTexture()
    	surface.SetDrawColor(COLOR_BLACK)
    	surface.DrawTexturedRect(0,0,ScrW(),ScrH())
    	draw.DrawText(string.rep(string.rep(n,140).."\n",37),"SBOX_FONT_30",0,0,COLOR_WHITE)
    cam.End2D()
end

hook.Add( "PreDrawOutlines", "sPreDrawOutlines", function()
	-- outline.Add({Entity(112)}, Color(255,0,0), 1)
end)

hook.Add("HUDPaint","debug",function()
	-- render.SetStencilEnable(true)
	-- render.SetStencilTestMask(255)
	-- render.SetStencilWriteMask(255)
	-- render.SetStencilReferenceValue(1)
	-- render.SetStencilPassOperation(STENCIL_KEEP)
	-- render.SetStencilFailOperation(STENCIL_REPLACE)
	-- render.SetStencilZFailOperation(STENCIL_KEEP)
	-- render.SetStencilCompareFunction(STENCIL_NEVER)
	-- render.OverrideColorWriteEnable(true, false)
		-- draw.RoundedBox(16,300,300,100,100,Color(100,100,100,100))
	-- render.OverrideColorWriteEnable(false)
	-- render.SetStencilCompareFunction(STENCIL_EQUAL)
	-- render.SetStencilFailOperation(STENCIL_KEEP)
		-- draw.RoundedBox(0,300 + absin(SysTime()*2)*101,300,100,100,COLOR_BLACK)
	-- render.SetStencilEnable(false)
end)

local glStencilClear, glStencilEnable, glStencilOp, glStencilFunc, glStencilMask = gl.StencilClear, gl.StencilEnable, gl.StencilOp, gl.StencilFunc, gl.StencilMask
local renderOverrideColorWriteEnable, renderClearBuffersObeyStencil = render.OverrideColorWriteEnable, render.ClearBuffersObeyStencil
local SysTime = SysTime

hook.Add( "PostDrawOpaqueRenderables", "Stencil Tutorial Example", function()

	-- local e = Entity(111)
	-- STENS = SysTime()
	-- glStencilClear()

	-- glStencilEnable(true)
	-- glStencilOp(STENCIL_REPLACE, STENCIL_REPLACE, STENCIL_KEEP)
	-- glStencilFunc(STENCIL_NEVER,2,255)
	-- glStencilMask(255)

	-- render.OverrideDepthEnable(true,false)
	-- renderOverrideColorWriteEnable( true, false)
	-- e:DrawModel()
	-- renderOverrideColorWriteEnable( false)
	-- render.OverrideDepthEnable(false)
	
	-- -- gl.StencilFunc(STENCIL_NOTEQUAL,0,255)
	-- -- layer(2)

	-- glStencilOp(STENCIL_REPLACE, STENCIL_REPLACE, STENCIL_INCRSAT)
	-- glStencilFunc(STENCIL_NOTEQUAL,2,255)
 --    -- cam.Start2D()
 --    -- 	draw.NoTexture()
 --    -- 	surface.SetDrawColor(COLOR_BLACK)
 --    -- 	surface.DrawTexturedRect(0,0,ScrW(),ScrH())
 --    -- 	draw.DrawText(string.rep(string.rep("1",140).."\n",37),"SBOX_FONT_30",0,0,COLOR_WHITE)
 --    -- cam.End2D()
	-- -- -- -- gl.StencilMask(0)
	-- -- render.OverrideDepthEnable(true,false)
	-- render.OverrideDepthEnable(true,false)
	-- renderOverrideColorWriteEnable( true, false)
	-- e:SetModelScale(1.1)
	-- e:DrawModel()
	-- e:SetModelScale(1)
	-- renderOverrideColorWriteEnable( false)
	-- render.OverrideDepthEnable(false)
	-- -- 

	-- glStencilOp(STENCIL_KEEP, STENCIL_KEEP, STENCIL_REPLACE)
	-- glStencilFunc(STENCIL_EQUAL,1,255)
	-- -- layer(1)
	-- -- -- render.SetColorMaterial()
	-- -- -- render.DrawBox(e:GetPos(),e:GetAngles(),e:OBBMins(),e:OBBMaxs(),Color(255,255,255))
	-- renderClearBuffersObeyStencil(255,0,0,0)

	-- glStencilEnable(false)
	-- STENE = SysTime()
--[[
render.SetStencilEnable( boolean newState )
render.SetStencilTestMask( number mask ) 0-255
render.SetStencilWriteMask( number mask ) 0-255
render.SetStencilReferenceValue( number referenceValue )
render.SetStencilCompareFunction(STENCIL1)
render.SetStencilPassOperation(STENCIL2)
render.SetStencilFailOperation(STENCIL2)
render.SetStencilZFailOperation(STENCIL2)
render.ClearStencil()
render.ClearStencilBufferRectangle( number originX, number originY, number endX, number endY, number stencilValue )
render.ClearBuffersObeyStencil( number r, number g, number b, number a, boolean depth )
render.PerformFullScreenStencilOperation()
]]
--[[
STENCIL1
STENCIL_NEVER				Never passes.
STENCIL_LESS			<	Passes where the reference value is less than the stencil value.
STENCIL_EQUAL			==	Passes where the reference value is equal to the stencil value.
STENCIL_LESSEQUAL		<=	Passes where the reference value is less than or equal to the stencil value.
STENCIL_GREATER			>	Passes where the reference value is greater than the stencil value.
STENCIL_NOTEQUAL		!=	Passes where the reference value is not equal to the stencil value.
STENCIL_GREATEREQUAL	>=	Passes where the reference value is greater than or equal to the stencil value.
STENCIL_ALWAYS 				Always passes.
STENCIL2
STENCIL_KEEP				Preserves the existing stencil buffer value.
STENCIL_ZERO				Sets the value in the stencil buffer to 0.
STENCIL_REPLACE				Sets the value in the stencil buffer to the reference value, set using render.SetStencilReferenceValue.
STENCIL_INCRSAT				Increments the value in the stencil buffer by 1, clamping the result.
STENCIL_DECRSAT				Decrements the value in the stencil buffer by 1, clamping the result.
STENCIL_INVERT				Inverts the value in the stencil buffer.
STENCIL_INCR				Increments the value in the stencil buffer by 1, wrapping around on overflow.
STENCIL_DECR				Decrements the value in the stencil buffer by 1, wrapping around on overflow.
]]
	-- render.Clear(255,255,255,255,true,true)
	--    render.OverrideAlphaWriteEnable( true, true )
    -- render.Clear( 0, 0, 0, 0 )
	--render.OverrideBlendFunc( true, BLEND_ZERO, BLEND_SRC_ALPHA, BLEND_DST_ALPHA, BLEND_ZERO )
	-- render.OverrideBlendFunc(false)
    -- render.OverrideAlphaWriteEnable( false )
   
    -- if input.IsKeyDown(KEY_UP) and s < SysTime() then
    -- a = Angle(math.random(-2,2)*90,math.random(-2,2)*90,math.random(-2,2)*90)
    -- chat.AddText(tostring(EyeAngles()).."\n"..tostring(a))
    -- s = SysTime() + 0.2
    -- end
    -- local a = EyeAngles()
    -- a:RotateAroundAxis(a:Right(), 90)
    -- a:RotateAroundAxis(a:Up(), -90)
-- + 
    -- cam.Start3D2D(EyePos() + EyeVector() * 3.1,a,0.01)

    -- cam.End3D2D() -- 
    -- layer(0)

		-- local X,Y = gui.MousePos()
		-- local x, y = self:LocalToScreen(0,0)
		-- cam.Start3D(Vector(60,0,0),Angle(0,180,0),90, x, y, w, t)
		-- 	render.SetScissorRect(x,y,x+w,y+t, true )
		-- 	FF.C:SetAngles(Angle(0,0,0))
		-- 	FF.C:DrawModel()
		-- 	render.SetScissorRect( 0, 0, 0, 0, false )
		-- cam.End3D()
end)