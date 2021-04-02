-- local API = APIs["UI"]

-- API:AddCall("vote.receive",function(self,ply,args)
--     UI.voteProcessor(ply,args[1],args[2])
-- end)

-- UI.Votes = {}
-- function UI.voteProcessor(ply,ID,vote)
--     if not UI.Votes[ID] or not UI.Votes[ID].options[vote] then return UI.voteCloseForPlayer(ply,ID) end
--     UI.Votes[ID].options[vote].count = UI.Votes[ID].options[vote].count + 1
--     UI.Votes[ID].totalVotes = UI.Votes[ID].totalVotes + 1

--     if not UI.Votes[ID].hide then
--         for k,v in pairs(UI.Votes[ID].voters) do
--             chat.AddCustomTextTo(v,{Color(200,200,200),ply:Nick()," проголосовал: ",UI.Votes[ID].options[vote].name})
--         end
--     end
--     if UI.Votes[ID].totalVotes == #UI.Votes[ID].voters then UI.voteDone(ID) end
-- end

-- function UI.voteDone(ID)
--     if not UI.Votes[ID] or not istable(UI.Votes[ID]) then return end
--     if UI.Votes[ID].totalVotes == 0 then for k,v in pairs(UI.Votes[ID].voters) do UI.voteCloseForPlayer(v,ID) end return end

--     local winning = {0,""}
--     for k,v in pairs(UI.Votes[ID].options) do
--         if winning[2] == "" then winning = {v.count,v.name} continue end
--         if winning[1] < v.count then winning = {v.count,v.name} continue end
--         if winning[1] == v.count then if istable(winning[2]) then table.insert(winning[2],v.name) else winning = {v.count,{winning[2],v.name}} end continue end
--     end

--     if not istable(winning[2]) then for K,V in pairs(UI.Votes[ID].options) do if winning[2] == V.name then winning[3] = K end end end


--     if not UI.Votes[ID].hide then
--         for k,v in pairs(UI.Votes[ID].voters) do
--             UI.voteCloseForPlayer(v,ID)
--             if istable(winning[2]) or winning[1] == 0 then
--                 chat.AddCustomTextTo(v,{Color(0,0,0),"[",Color(18,149,241),"SBox",Color(0,0,0),"]",Color(255,255,255)," Голосование завершено. "..#winning[2].." вариант"..itext.RSuff.AOV(#winning[2]).." набрало одинаковое количество голосов."})
--             else
--                 chat.AddCustomTextTo(v,{Color(0,0,0),"[",Color(18,149,241),"SBox",Color(0,0,0),"]",Color(255,255,255)," Голосование завершено. Выиграл вариант: "..winning[2]})
--             end
--             for K,V in pairs(UI.Votes[ID].options) do
--                 if V.count == 0 then continue end
--                 chat.AddCustomTextTo(v,{Color(200,200,200),"Вариант \"",Color(255,255,255),V.name,Color(200,200,200),"\" набрал "..V.count.." голос"..itext.RSuff.AOV(V.count)})
--             end
--         end
--     else
--         for k,v in pairs(UI.Votes[ID].voters) do UI.voteCloseForPlayer(v,ID) end
--     end

--     if not istable(winning[2]) or winning[1] == 0 then
--         if not UI.Votes[ID].triggerOn then
--             UI.Votes[ID].doOnTrigger(winning[3])
--         else
--             if UI.Votes[ID].triggerOn == winning[3] then
--                 UI.Votes[ID].doOnTrigger(winning[3])
--             end
--         end
--     end
--     UI.Votes[ID] = nil
-- end

-- function UI.voteCreate(tp,title,options,timeout,callback,triggeropt,targets,hide)
--     local ID = CurTime()
--     UI.Votes[ID] = {}
--     UI.Votes[ID].options = {}
--     UI.Votes[ID].hide = hide or false
--     UI.Votes[ID].voters = targets
--     UI.Votes[ID].type = tp
--     UI.Votes[ID].totalVotes = 0
--     UI.Votes[ID].triggerOn = triggeropt
--     UI.Votes[ID].doOnTrigger = callback
--     for k,v in pairs(options) do
--         UI.Votes[ID].options[k] = {}
--         UI.Votes[ID].options[k].name = v
--         UI.Votes[ID].options[k].count = 0
--     end
--     timeout = timeout or 15
--     timer.Simple(timeout,function() if not istable(UI.Votes[ID]) then return end UI.voteDone(ID) end)

--     if #targets == 0 then
--         API:Send(true,"vote.create",{ID,title,options,timeout})
--     elseif #targets == 1 then
--         API:Send(targets[1],"vote.create",{ID,title,options,timeout})
--     else
--         for k,v in pairs(targets) do
--             API:Send(v,"vote.create",{ID,title,options,timeout})
--         end
--     end
-- end

-- function UI.voteIsTypeRunning(tp)
--     for k,v in pairs(UI.Votes) do
--         if v.type == tp then return true end
--     end
--     return false
-- end

-- -- UI.voteCreate("id","Test",{"opt1","opt2","opt3","opt4","opt5"},10,function(num) print("VOTE GET") print(num) end,nil,{SparEnt()},false)

-- function UI.voteCloseForPlayer(ply,ID)
--     API:Send(ply,"vote.close",{ID})
-- end
--     