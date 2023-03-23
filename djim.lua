Djim = LibStub("AceAddon-3.0"):NewAddon("djim", "AceConsole-3.0")
AceGUI = LibStub("AceGUI-3.0")
AceComm = LibStub("AceComm-3.0")

local TT_ENTRY = "|cFFCFCFCF%s:|r %s" -- |cffFFFFFF%s|r"
local prefix = "djimsdeathroll"

local EventFrame = CreateFrame("frame", "EventFrame")
EventFrame:RegisterEvent("CHAT_MSG_WHISPER")
EventFrame:RegisterEvent("CHAT_MSG_RAID")
EventFrame:RegisterEvent("CHAT_MSG_RAID_LEADER")
EventFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")
EventFrame:RegisterEvent("CHAT_MSG_SYSTEM")
EventFrame:RegisterEvent("CHAT_MSG_ADDON")

local djimLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Djim!", {
    type = "launcher",
    text = "Djim!",
    icon = "Interface\\Icons\\INV_Misc_Coin_01",
    OnClick = function(_, msg)
        if msg == "LeftButton" and not IsModifierKeyDown() then
            Djim:ShowFrame()
        elseif msg == "RightButton" and not IsModifierKeyDown() then
            InterfaceOptionsFrame_Show()
            InterfaceOptionsFrame_OpenToCategory("Djim's Deathroll")
        end
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then
            return
        end
        tooltip:AddLine("Djim's Deathroll")
        tooltip:AddLine(format(TT_ENTRY, "left click", "Open deathroll overview"))
        tooltip:AddLine(format(TT_ENTRY, "right click", "Open the options menu"))
    end
})
local icon = LibStub("LibDBIcon-1.0")

local defaults = {
    profile = {
        options = {
            block_incoming = false
        },
        database_options = {
            initialized = false
        },
        minimap = {
            hide = false
        }
    }
}

local options = {
    name = "Djims Deathroll!",
    desc = "General",
    descStyle = "inline",
    handler = Djim,
    type = "group",
    args = {
        block_incoming = {
            type = 'toggle',
            name = 'Block Incoming Requests',
            desc = 'Automatically declines incoming requests.',
            set = 'SetBlockIncoming',
            get = 'GetBlockIncoming',
            width = 'full'
        }
    }
}

local inventorySlotConstants = {INVSLOT_HEAD, INVSLOT_SHOULDER, INVSLOT_CHEST, INVSLOT_WAIST, INVSLOT_LEGS,
                                INVSLOT_FEET, INVSLOT_WRIST, INVSLOT_HAND, INVSLOT_MAINHAND, INVSLOT_RANGED}

local AC = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function Djim:OnInitialize()
    -- uses the "Default" profile instead of character-specific profiles
    -- https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
    self.db = LibStub("AceDB-3.0"):New("DjimDB", self.defaults)
    icon:Register("Djims Deathroll!", djimLDB, self.db.profile.minimap)

    -- registers an options table and adds it to the Blizzard options window
    -- https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0
    AC:RegisterOptionsTable("Djim_Options", self.options)
    self.optionsFrame = AceConfigDialog:AddToBlizOptions("Djim_Options", "Djim's Deathroll")

    -- adds a child options table, in this case our profiles panel
    -- local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    -- AC:RegisterOptionsTable("HelloAce_Profiles", profiles)
    -- AceConfigDialog:AddToBlizOptions("HelloAce_Profiles", "Profiles", "Djim's Deathroll")

    Djim.Frame = Djim:NewFrame()
end

function Djim:OnEnable()

    Djim:WelcomeText()

    AceComm:RegisterComm(prefix, function(prefix, text, channel, sender)
        -- comm received
        Djim:DeathRoll(prefix, text, channel, sender)
    end)

    Djim:RandomMeuk()
end

function Djim:OnDisable()
    -- code
end

function Djim:ShowFrame()
    if Djim.Frame:IsShown() then
        Djim.Frame:Hide()
    else
        Djim.Frame:Show()
    end
end

function Djim:DeathRoll(prefixa, text, channel, sender)

    if (prefixa == prefix) then
        if (string.find(text, "result:")) then
            InitiateTrade(sender)
            C_Timer.After(1, function()
                if TradeFrame:IsShown() then
                    SetTradeMoney(Djim.db.profile.deathrollAmount * 100 * 100)
                    -- else
                    --     PickupPlayerMoney(1*100*100)
                end
                -- AddTradeMoney()

                SendChatMessage("I LOST AND PAID " .. sender, "PARTY")
            end)
        end

        local rollResult = text
        if (rollResult ~= "1") then
            RandomRoll(1, rollResult)
        else
            Djim:Print("You died!")
            AceComm:SendCommMessage(prefix, "result:", "WHISPER", Djim.db.profile.deathrollBuddy)
        end
    end
end

function Djim:RandomMeuk()
    EventFrame:SetScript("OnEvent", function(self, event, ...)

        if event == "CHAT_MSG_SYSTEM" then
            local message = ...
            local author, rollResult, rollMin, rollMax = string.match(message, "(.+) rolls (%d+) %((%d+)-(%d+)%)")
            if (author == UnitName("player")) then
                AceComm:SendCommMessage(prefix, rollResult, "WHISPER", Djim.db.profile.deathrollBuddy)
            end
        end

        if (event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_WHISPER" or event ==
            "CHAT_MSG_BN_WHISPER") then
            local text, playerName = ...
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

            if (text == "!dr") then
                RandomRoll(1, 10)
                print(roll)
            end
        end
    end)
end

function Djim:NewFrame()

    -- Create a container frame
    local f = AceGUI:Create("Frame")
    f:Hide()
    f:SetWidth(400)
    f:SetHeight(300)
    f:SetCallback("OnClose", function(widget)
        -- AceGUI:Release(widget)
    end)
    f:SetTitle("Djim's Deathroll")
    f:SetStatusText("Deathrolls for life!")
    f:SetLayout("Flow")

    local label = AceGUI:Create("Label")
    label:SetFullWidth(true)
    label:SetText("Start a death roll by choosing your opponent and set the bet amount \nHave fun!!")
    f:AddChild(label)

    local header = AceGUI:Create("Heading")
    header:SetText("Configuration")
    header:SetRelativeWidth(1)
    f:AddChild(header)

    local opponent = AceGUI:Create("EditBox")
    opponent:SetFullWidth(true)
    opponent:SetLabel("Your opponent")
    opponent:SetText(self.db.profile.deathrollBuddy)
    opponent:SetCallback("OnEnterPressed", function(_, __, text)
        self:Print("Opponent changed to " .. text)
        self.db.profile.deathrollBuddy = text
    end)
    f:AddChild(opponent)

    local vspace = AceGUI:Create("Label")
    vspace:SetText(" ")
    f:AddChild(vspace)

    local slider = AceGUI:Create("Slider")
    slider:SetFullWidth(true)
    slider:SetLabel("Deathroll Amount")
    slider:SetSliderValues(1, Djim.db.profile.deathrollMax, 1)
    slider:SetValue(Djim.db.profile.deathrollAmount)
    slider:SetCallback("OnMouseUp", function(_, __, value)
        self:Print("Deathroll amount set to: " .. value)
        self.db.profile.deathrollAmount = value
    end)
    f:AddChild(slider)

    f:AddChild(vspace)

    local btn = AceGUI:Create("Button")
    btn:SetFullWidth(true)
    btn:SetWidth(170)
    -- btn:SetPoint("TOP", self, "BOTTOM", 0, -2)
    btn:SetText("Deathroll")
    btn:SetCallback("OnClick", function()
        RandomRoll(1, Djim.db.profile.deathrollAmount * 10)
    end)
    -- Add the button to the container
    f:AddChild(btn)

    -- Add the frame as a global variable under the name `MyGlobalFrameName`
    _G["DjimsDeathroll"] = f.frame
    -- Register the global variable `MyGlobalFrameName` as a "special frame"
    -- so that it is closed when the escape key is pressed.
    tinsert(UISpecialFrames, "DjimsDeathroll")

    return f
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
