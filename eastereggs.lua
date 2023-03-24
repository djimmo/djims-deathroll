local EventFrame = CreateFrame("frame", "EventFrame")
EventFrame:RegisterEvent("CHAT_MSG_WHISPER")
EventFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")
EventFrame:RegisterEvent("CHAT_MSG_RAID")
EventFrame:RegisterEvent("CHAT_MSG_RAID_LEADER")
EventFrame:RegisterEvent("CHAT_MSG_SYSTEM")

local inventorySlotConstants = {INVSLOT_HEAD, INVSLOT_SHOULDER, INVSLOT_CHEST, INVSLOT_WAIST, INVSLOT_LEGS,
                                INVSLOT_FEET, INVSLOT_WRIST, INVSLOT_HAND, INVSLOT_MAINHAND, INVSLOT_RANGED}

function Djim:RandomFunc()
    EventFrame:SetScript("OnEvent", function(self, event, ...)

        if event == "CHAT_MSG_SYSTEM" then
            local message = ...
            local author, rollResult, rollMin, rollMax = string.match(message, "(.+) rolls (%d+) %((%d+)-(%d+)%)")
            if (author == UnitName("player")) then
                if rollResult == 1 then
                    Djim:Print("You lose!")
                end
                AceComm:SendCommMessage(prefix, rollResult, "WHISPER", Djim.db.profile.deathrollBuddy)
            end
        end

        if (event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_WHISPER" or event ==
            "CHAT_MSG_BN_WHISPER") then
            print(...)
            local text, playerName, _, __, charName = ...
            -- print(text)

            if (text == "!dur") then
                local curTotal = 0
                local maxTotal = 0

                for key, value in pairs(inventorySlotConstants) do
                    local current, maximum = GetInventoryItemDurability(value)
                    curTotal = curTotal + current
                    maxTotal = maxTotal + maximum
                end

                local message =
                    "My durability is " .. math.floor(curTotal / maxTotal * 100) .. "% (" .. curTotal .. "/" .. maxTotal ..
                        ")"
                SendChatMessage(message, "whisper", nil, playerName)
            end

            if (text == "!head") then
                local itemID = GetInventoryItemID("player", INVSLOT_HEAD)
                local _, link = GetItemInfo(itemID)
                SendChatMessage(link, "whisper", nil, playerName)
            end

            if (text == "!gold") then
                local copper = GetMoney()
                local text = "I have " .. math.floor(copper / 100 / 100) .. "g " .. math.floor(copper / 100 % 100) ..
                                 "s " .. copper % 100 .. "c"
                SendChatMessage(text, "whisper", nil, playerName)
            end

            if (text == "!pi") then
                SendChatMessage(playerName .. " wants Power Infusion!", "PARTY")
            end
        end
    end)
end

function Djim:WelcomeText()
    C_Timer.After(5, function()
        print("\124cff00FF7FDjim's Awesome Addon v0.1\124r has been loaded!")
        colors = {{
            title = 'LIGHTBLUE',
            color = 'cff00ccff'
        }, {
            title = 'LIGHTRED',
            color = 'cffff6060'
        }, {
            title = 'SPRINGGREEN',
            color = 'cff00FF7F'
        }, {
            title = 'GREENYELLOW',
            color = 'cffADFF2F'
        }, {
            title = 'BLUE',
            color = 'cff0000ff'
        }, {
            title = 'PURPLE',
            color = 'cffDA70D6'
        }, {
            title = 'GREEN',
            color = 'cff00ff00'
        }, {
            title = 'RED',
            color = 'cffff0000'
        }, {
            title = 'GOLD',
            color = 'cffffcc00'
        }, {
            title = 'GOLD2',
            color = 'cffFFC125'
        }, {
            title = 'GREY',
            color = 'cff888888'
        }, {
            title = 'WHITE',
            color = 'cffffffff'
        }, {
            title = 'SUBWHITE',
            color = 'cffbbbbbb'
        }, {
            title = 'MAGENTA',
            color = 'cffff00ff'
        }, {
            title = 'YELLOW',
            color = 'cffffff00'
        }, {
            title = 'ORANGEY',
            color = 'cffFF4500'
        }, {
            title = 'CHOCOLATE',
            color = 'cffCD661D'
        }, {
            title = 'CYAN',
            color = 'cff00ffff'
        }, {
            title = 'IVORY',
            color = 'cff8B8B83'
        }, {
            title = 'LIGHTYELLOW',
            color = 'cffFFFFE0'
        }, {
            title = 'SEXGREEN',
            color = 'cff71C671'
        }, {
            title = 'SEXTEAL',
            color = 'cff388E8E'
        }, {
            title = 'SEXPINK',
            color = 'cffC67171'
        }, {
            title = 'SEXBLUE',
            color = 'cff00E5EE'
        }, {
            title = 'SEXHOTPINK',
            color = 'cffFF6EB4'
        }}
        function printColors()
            -- print("\124cffFF0000This text is red\124r") --This is red color
            local startLine = '\124'
            local endLine = '\124r'
            for i = 1, table.getn(colors) do
                print(startLine .. colors[i].color .. colors[i].title .. endLine)
            end
        end
        -- printColors()
    end)
end
