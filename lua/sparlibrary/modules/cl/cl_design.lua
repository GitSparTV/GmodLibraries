gl = {}

do
	local SetStencilFailOperation, SetStencilZFailOperation, SetStencilPassOperation = render.SetStencilFailOperation, render.SetStencilZFailOperation, render.SetStencilPassOperation

	function gl.StencilOp(fail, zfail, pass)
		SetStencilFailOperation(fail)
		SetStencilZFailOperation(zfail)
		SetStencilPassOperation(pass)
	end
end

gl.StencilClear = render.ClearStencil
gl.StencilEnable = render.SetStencilEnable
gl.StencilMask = render.SetStencilWriteMask

do
	local SetStencilCompareFunction, SetStencilReferenceValue, SetStencilTestMask = render.SetStencilCompareFunction, render.SetStencilReferenceValue, render.SetStencilTestMask

	function gl.StencilFunc(func, ref, mask)
		SetStencilCompareFunction(func)
		SetStencilReferenceValue(ref)
		SetStencilTestMask(mask)
	end
end

do
	local Matrix = Matrix
	local Vector = Vector

	function gl.MatrixFor3D2D(vec, ang, scale)
		local m = Matrix()
		m:SetAngles(ang)
		m:SetTranslation(vec)
		m:SetScale(Vector(scale, -scale, 1))

		return m
	end
end

do
	local SetColorMaterial, DrawBox, DrawWireframeBox, DepthRange = render.SetColorMaterial, render.DrawBox, render.DrawWireframeBox, render.DepthRange
	local Ang0, Vec0 = ANGLE_ZERO, VECTOR_ZERO

	function gl.DrawOutlinedBox(BoxColor, LineColor, vec1, vec2)
		SetColorMaterial()
		DepthRange(0.35, 1)
		DrawBox(vec1, Ang0, Vec0, vec2, BoxColor, true)
		DepthRange(0, 1)
		DrawWireframeBox(vec1, Ang0, Vec0, vec2, LineColor, true)
	end
end

do
	local Depth = render.OverrideDepthEnable

	do
		local PushCam = cam.PushModelMatrix

		function gl.Push3D2D(M)
			Depth(true, false)
			PushCam(M)
		end
	end

	do
		local PopCam = cam.PopModelMatrix

		function gl.Pop3D2D(M)
			PopCam()
			Depth(false)
		end
	end
end

do
	local SetColor = surface.SetDrawColor

	function gl.SetColor(color)
		SetColor(color.r, color.g, color.b, color.a)
	end
end

do
	local SetColor = surface.SetDrawColor
	local DrawRect = surface.DrawRect
	local floor, min, ceiloor = math.floor, math.min, math.ceiloor
	local SetTexture, DrawTexturedRectUV = surface.SetTexture, surface.DrawTexturedRectUV
	local tex_corner8 = surface.GetTextureID("gui/corner8")
	local tex_corner16 = surface.GetTextureID("gui/corner16")
	local tex_corner32 = surface.GetTextureID("gui/corner32")
	local tex_corner64 = surface.GetTextureID("gui/corner64")
	local tex_corner512 = surface.GetTextureID("gui/corner512")

	function gl.RoundedBoxEx(bordersize, x, y, w, h, color, tl, tr, bl, br)
		SetColor(color.r, color.g, color.b, color.a)

		if bordersize <= 0 then
			DrawRect(x, y, w, h)

			return
		end

		x = ceiloor(x)
		y = ceiloor(y)
		bordersize = min(bordersize, floor(w / 2), floor(h / 2))
		DrawRect(x + bordersize, y, w - bordersize * 2, h)
		DrawRect(x, y + bordersize, bordersize, h - bordersize * 2)
		DrawRect(x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2)
		local tex = tex_corner8

		if bordersize > 8 and bordersize < 16 then
			tex = tex_corner16
		elseif bordersize < 32 then
			tex = tex_corner32
		elseif bordersize < 64 then
			tex = tex_corner64
		else
			tex = tex_corner512
		end

		SetTexture(tex)

		if (tl) then
			DrawTexturedRectUV(x, y, bordersize, bordersize, 0, 0, 1, 1)
		else
			DrawRect(x, y, bordersize, bordersize)
		end

		if (tr) then
			DrawTexturedRectUV(x + w - bordersize, y, bordersize, bordersize, 1, 0, 0, 1)
		else
			DrawRect(x + w - bordersize, y, bordersize, bordersize)
		end

		if (bl) then
			DrawTexturedRectUV(x, y + h - bordersize, bordersize, bordersize, 0, 1, 1, 0)
		else
			DrawRect(x, y + h - bordersize, bordersize, bordersize)
		end

		if (br) then
			DrawTexturedRectUV(x + w - bordersize, y + h - bordersize, bordersize, bordersize, 1, 1, 0, 0)
		else
			DrawRect(x + w - bordersize, y + h - bordersize, bordersize, bordersize)
		end
	end
end

function render.Mask(mask, scope)
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilTestMask(1)
	render.SetStencilWriteMask(1)
	render.SetStencilReferenceValue(1)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_REPLACE)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.SetStencilCompareFunction(STENCIL_NEVER)
	render.OverrideColorWriteEnable(true, false)
	mask()
	render.OverrideColorWriteEnable(false)
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilFailOperation(STENCIL_KEEP)
	scope()
	render.SetStencilEnable(false)
end

function draw.TextBox(round, text, font, x, y, colorb, colort, outx, outy)
	local len, h = itext.TextSize(text, font)
	outx = outx or SCALEW * 10
	outy = outy or SCALEH * 5
	draw.RoundedBox(round, x - len / 2 - outx / 2, y - h / 2 - outy / 2, len + outx, h + outy, colorb)
	draw.DrawText(text, font, x, y, colort, 1, 1)
end