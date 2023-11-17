Collection of GMod libraries made for my server when I was developing it.

# Partial documentation:
```lua
-- API

SHARED 		api(index)														-- Creates API module
SERVER	 	api.flags = bit.bor
SERVER	 	api.flag = bit.band
SERVER	 	api.getflags(flags)
SHARED		GetAPI(name)
SHARED		API:Register()
SHARED		API:GetAPIName()
SHARED		API:GetName()
SHARED		API:IsActive()
SHARED		API:Activate()
SHARED		API:Deactivate()
SHARED		API:CanBeCalledFromNetwork()
SHARED		API:AttachToNetwork()
SHARED		API:Call(method, args, [SV] ply)
SERVER		API:AddClientMethod(name, networkWriter)
CLIENT	 	API:AddServerMethod(name, networkWriter)
SHARED		API:Send([SV] ply, method, args)
SHARED		API:AddMethod(name, callback, [SV] flags, networkReader, id)
SHARED		API:GetMethod(methodid)
SERVER		API:CheckAccess(methodid, ply)
SHARED		API_CLIENT
SHARED		API_CONSOLE
SHARED		API_REPLICATED
SHARED		API_NOTMINGE
SHARED		API_ADMINONLY
SHARED		API_SUPERADMINONLY
NET_STRING = "s"
NET_FLOAT = "f"
NET_DOUBLE = "d"
NET_BOOL = "b"
NET_BIT = "."
NET_COLOR = "c"
NET_VECTOR = "v"
NET_ANGLE = "a"
NET_ENT = "e"
NET_PLAYER = "p"
NET_INT = "i"
NET_UINT = "u"
NET_TABLE = "t"
NET_ARRAY = "A"

-- ITEXT

SHARED		itext.RSuff.Kit(var05, var1, var234)
SHARED		itext.RSuff.YU(num)
SHARED		itext.RSuff.AOV(num)
SHARED		itext.RSuff.DAY(num)
SHARED		itext.Split32(text)
SHARED		itext.SplitEach(text)
SHARED		itext.SplitEachASCII(text)
SHARED		itext.Split(text, terminator)
SHARED		itext.ASCIIEncode(text)
SHARED		itext.ASCIIDecode(text)
SHARED		itext.ASCIIToTable(text)
CLIENT		itext.TextSize(text,font)
SHARED		itext.Len = utf8.len
SHARED		itext.Encode(text)
SHARED		itext.Decode(text)
SHARED		itext.ForceEncode(text)
SHARED		itext.LenWrap(text, charlimit, hardness)
SHARED		itext.Wrap(text, font, maxW, hardness, maxY)
SHARED		itext.LenFold(text,cutsym)
SHARED		itext.Fold(text, font, sizex)
SHARED		itext.Format(text)

-- ERP

CLIENT 		vgui:AddErp(mode, time, from, to)	-- Adds erp handler if didn't exists. Adds new Erp ID.
CLIENT 		vgui:AddThinkHook(function)		-- Adds erp handler if didn't exists. Adds function to execute as Think 
CLIENT 		vgui:SetErpRange(id, a, b)		-- Changes Erp range
CLIENT 		vgui:GetErpRange(id)			-- Returns Erp range
CLIENT 		vgui:SetErpMode(id,function)	-- Changes Erp function 
CLIENT 		vgui:IsErpCompleted(id)			-- Returns whether Erp complete animation or not
CLIENT 		vgui:SetErpOn(id,b)				-- Changes Erp active state
CLIENT 		vgui:SetErpEndTime(id,a)		-- Changes Erp animation time
CLIENT 		vgui:DeleteErp(id)				-- Deletes Erp ID
CLIENT 		vgui:DeleteAllErp()				-- Deletes all Erp IDs
CLIENT 		vgui:SwitchErp(id,bool)			-- Switches Erp polarity. Automatically feeds Erp clock
CLIENT 		vgui:GetErpTime(id)				-- Returns Erp passed clock time
CLIENT 		vgui:FeedErpClock(id)			-- Feeds Erp clock time
CLIENT 		vgui:SetErpClock(id,s)			-- Sets Erp clock time
CLIENT 		vgui:GetErpClock(id)			-- Returns Erp clock time
CLIENT 		vgui:GetErpState(id)			-- Returns Erp state

SHARED iQerp ,oQerp ,ioQerp ,iCuerp ,oCuerp ,iQaerp ,oQaerp ,ioQaerp ,iQuerp ,oQuerp ,
ioQuerp ,iSerp ,oSerp ,ioSerp ,iExerp ,oExerp ,ioExerp ,iCierp ,oCierp ,Berp

-- DATABASE

SERVER 		database(path, pretty)					-- Creates database object
SERVER		database:ValidPath()
SERVER		database:GetPath()
SERVER		database:UpdateEach(n)
SERVER		database:Update()
SERVER		database:Setup()
SERVER		database:Close()
SERVER		database:Clear()
SERVER		database:LoadFile()
SERVER		database:GetHandle()
SERVER		database:GetTable()
SERVER		database:Sync()

-- UTIL

SHARED 		ColorLookup
SHARED      COLOR_WHITE = Color(255,255,255)
SHARED      COLOR_BLACK = Color(0,0,0)
SHARED      COLOR_SBOX = Color(18, 149, 241)
SHARED 		datastamp(bool)										-- Returns datastamp string [d-m-Y_H-M-S or d.m.Y H:M:S]
SHARED 		topf(num)											-- Returns pretty print of float. Precision can be lost
SHARED		tosafe = bit.tobit
SHARED		newset(...)
SHARED		createtable(n, t)
SHARED 		createunpack(n)
SHARED		cprint(txt,newline mode)							-- Prints text in console without limits
SHARED		numbool(bool) 										-- Converts bools to number
SHARED		absin(s)
SHARED		bit.flag(n)
SHARED 		retry(func_exec,func_case,time,attempts)			-- Makes a loop timer for executing something
SHARED		printt = PrintTable

-- TABLE

SHARED		table.GetValueKey(tbl, value)
SHARED		table.FromSet(tbl)
SHARED		table.iGetValueKey(tbl, value, len)
SHARED		table.ToSet(tbl)

-- CHAT

SERVER		inform.Chat(ply, text)
SERVER		inform.CharColor(ply, text, color)
SERVER		inform.ChatCustom(ply, table)
SERVER		inform.ChatGlobal(tbl)

-- CALLBACK

-- SHARED		[USELESS?] callback.SwitchProcessor(id,args)													-- Processes hooks args into callback system
-- SHARED		callback.CreateHandler(name)														-- Creates handler into hook for callback system
-- SHARED 		callback.RegisterCallback(hook,trigger,deleteAfter,varargid,preVal,sendArgs)		-- Registers callback for value in hook args
-- SHARED		callback.ResetHandler(name)															-- Resets callback handler
-- SHARED		callback.RemoveCallback(hook,trigger) 												-- Removes callback from hook

-- DEBUG

SHARED 		debug.GetArgs(func)		-- Returns args name

-- MATH

SHARED 		math.mean(t)				-- Returns mean value from all args
SHARED 		math.sign(n)				-- Sign value
SHARED 		math.square(n)				-- Makes square wave
SHARED		math.BitsRequired(max)
SHARED		math.ClampMap(input,inmin,inmax,outmin,outmax)

```
