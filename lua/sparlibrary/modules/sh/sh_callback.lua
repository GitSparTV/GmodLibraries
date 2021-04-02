callback = {}
local Callbacks = {}

function callback.SwitchProcessor(id, args)
	if falser(Callbacks[id], true, FALSER_TBL) or table.Count(Callbacks[id]) == 0 then return end

	if table.Count(args) == 0 then
		for K, V in pairs(Callbacks[id]) do
			if nil == V.trigger then
				V.callback(V.sendArgs and args or nil)

				if V.deleteAfter then
					Callbacks[id][K] = nil
				end
			end
		end
	end

	for k, v in pairs(args) do
		for K, V in pairs(Callbacks[id]) do
			local vcache = v
			if V.varargid ~= k then continue end

			if V.preVal then
				vcache = V.preVal(vcache)
			end

			if vcache == V.trigger then
				V.callback(V.sendArgs and args or nil)

				if V.deleteAfter then
					Callbacks[id][K] = nil
				end
			end
		end
	end
end

function callback.ResetHandler(name)
	Callbacks[name] = nil
	callback.CreateHandler(name)
end

function callback.CreateHandler(name)
	if istable(Callbacks[name]) then return end
	Callbacks[name] = {}

	hook.Add(name, "callback." .. name, function(...)
		callback.SwitchProcessor(name, {...})
	end)
end

function callback.RegisterCallback(hook, trigger, call, deleteAfter, varargid, preVal, sendArgs)
	falser(hook, FALSER_STR)
	falser(call, FALSER_FUNC)
	falser(deleteAfter, FALSER_BOOL, FALSER_NIL)
	falser(varargid, FALSER_NUM, FALSER_NIL)
	falser(preVal, FALSER_FUNC, FALSER_NIL)
	falser(sendArgs, FALSER_BOOL, FALSER_NIL)

	if not Callbacks[hook] then
		callback.CreateHandler(hook)
	end

	table.insert(Callbacks[hook], {
		trigger = trigger,
		callback = call,
		deleteAfter = deleteAfter,
		varargid = varargid,
		preVal = preVal,
		sendArgs = sendArgs
	})
end

function callback.RemoveCallback(hook, trigger)
	falser(hook, FALSER_STR)
	falser(Callbacks[hook], FALSER_TBL)

	for k, v in pairs(Callbacks[hook]) do
		if v.trigger == trigger then
			table.remove(Callbacks[hook], k)
			break
		end
	end
end