local hasAddon

function Djim:AddonCheck(text, playerName)
    if text == "requestCheckAddon" then
        -- Djim:Print("RequestCheckAddon")
        hasAddon = false
        AceComm:SendCommMessage(prefix, "checkAddon", "WHISPER", playerName)
        C_Timer.After(2, function()
            if not hasAddon then
                SendChatMessage(
                    "I want to Deathroll with you, please download Djim's Deathroll Mod here: https://www.curseforge.com/wow/addons/djims-deathroll",
                    "whisper", nil, playerName)
            end
        end)
    end

    if text == "checkAddon" then
        -- Djim:Print("CheckAddon")
        AceComm:SendCommMessage(prefix, "hasAddon", "WHISPER", playerName)
    end

    if text == "hasAddon" then
        -- Djim:Print("HasAddon")
        hasAddon = true
        AceComm:SendCommMessage(prefix, "deathrollinforequest:", "WHISPER", playerName)
    end

end

function Djim:DeathRollInfoRequest(prefix, text, channel, sender)
    -- Djim:Print("DeathRollInfoRequest")
    local playerName = UnitName("player")
    AceComm:SendCommMessage(prefix, "deathrollinforesponse:" .. playerName .. ":" .. GetMoney(), "WHISPER",
        Djim.db.profile.deathrollBuddy)
end

function Djim:DeathRollInfoResponse(prefix, text, channel, sender)
    -- Djim:Print("DeathRollInfoResponse")
    local prefix, player, money = string.match(text, "(.+):(.+):(%d+)")
    if self.db.profile.sneakyMode then
        Djim:Print(player .. " has " .. money / 10000 .. " gold")
    end
end

function Djim:DeathRollChallengeRequest(text, player)
    local _, gold = string.match(text, "(.+):(%d+)")
    Djim:DeathRollResponseWindow(player, gold)
end

function Djim:DeathRollChallengeResponse(text, player)

end

function Djim:DeathRollChallengeAccept(text, player)
    local _, gold = string.match(text, "(.+):(%d+)")
    Djim:Print(player .. " accepted your Deathroll challenge for " .. gold .. " gold. :)")
    acceptRolls = true
end

function Djim:DeathRollChallengeDecline(text, player)
    local _, gold = string.match(text, "(.+):(%d+)")
    Djim:Print(player .. " declined your Deathroll challenge for " .. gold .. " gold. :()")
    acceptRolls = false
end

function Djim:DeathRoll(prefixa, text, channel, sender)

    if (prefixa == prefix and acceptRolls) then
        if (string.find(text, "result:")) then
            InitiateTrade(sender)
            C_Timer.After(1, function()
                if TradeFrame:IsShown() then
                    TradePlayerInputMoneyFrameGold:SetFocus()
                    MoneyInputFrame_SetCopper(TradePlayerInputMoneyFrame, Djim.db.profile.deathrollAmount * 100 * 100)
                    -- SetTradeMoney(Djim.db.profile.deathrollAmount * 100 * 100)
                    -- else
                    -- PickupPlayerMoney(Djim.db.profile.deathrollAmount * 100 * 100)
                    -- AddTradeMoney()
                end

                -- SendChatMessage("I LOST AND PAID " .. sender, "PARTY")
                acceptRolls = false
            end)
        end

        local rollResult = text
        if (rollResult ~= "1") then
            RandomRoll(1, rollResult)
        else
            Djim:Print("You win!")
            acceptRolls = false
            AceComm:SendCommMessage(prefix, "result:", "WHISPER", Djim.db.profile.deathrollBuddy)
        end
    end
end
