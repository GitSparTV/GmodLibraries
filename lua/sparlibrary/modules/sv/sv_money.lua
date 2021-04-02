-- money = {}

-- function money.add(who, to, count, reason)
--     local ply = isentity(to) and to or player.Find(to)
--     if ply == nil then return end
--     local mney = tosafe(count)
--     if mney <= 0 then return print("Zero or negative") end
--     if not reason or not who then return end
--     money.modify(ply, mney, "От " .. who .. " (" .. reason .. ")")
-- end

-- function money.send(from, to, count, fee)
--     if not IsValid(from) or not IsValid(to) then return end
--     local Profile1, Profile2 = from:GetProfile(), to:GetProfile()

--     if count > Profile1:GetNumber("Money", 0) then
--         UI.SkinNotus(ply, "Ошибка", "Недостаточно денег!", "Error")

--         return false
--     end

--     if from == to then return true end
--     money.modify(from, -(count + (fee or 0)), "Перевод игроку " .. to:Nick())
--     money.modify(to, count, "Перевод от " .. from:Nick())
-- end

-- function money.modify(ply, count, comment, chatonly)
--     if count == 0 then return end
--     local Profile = ply:GetProfile()

--     if count < 0 and Profile:GetNumber("Money", 0) - math.abs(count) < 0 then
--         UI.SkinNotus(ply, "Ошибка", "Недостаточно денег!", "Error")

--         return false
--     end

--     Profile:AddNumber("Money", count)

--     if chatonly ~= "nohistory" then
--         StoreKit.History(Profile, (count > 0 and "Пополнение" or "Списание") .. " " .. math.abs(count) .. " $SBox" .. (comment and ". Комментарий: " .. comment or ""), chatonly)
--     end

--     return true
-- end