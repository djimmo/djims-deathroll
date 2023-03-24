Djim = LibStub("AceAddon-3.0"):NewAddon("Djim's Deathroll", "AceConsole-3.0")
AceGUI = LibStub("AceGUI-3.0")
AceComm = LibStub("AceComm-3.0")

prefix = "djimsdeathroll"

acceptRolls = false

local TT_ENTRY = "|cFFCFCFCF%s:|r %s" -- |cffFFFFFF%s|r"

local djimLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Djim!", {
    type = "launcher",
    text = "Djim!",
    icon = "Interface\\Icons\\inv_misc_dice_01",
    OnClick = function(_, msg)
        if msg == "LeftButton" and not IsModifierKeyDown() then
            Djim:DeathRollRequestWindow()
        elseif msg == "RightButton" and not IsModifierKeyDown() then
            InterfaceOptionsFrame_Show()
            InterfaceOptionsFrame_OpenToCategory("Djim's Deathroll")
        elseif msg == "MiddleButton" and not IsModifierKeyDown() then
            Djim.db.profile.modSilenced = not Djim.db.profile.modSilenced
            if Djim.db.profile.modSilenced then
                Djim:Print("Requests are now silenced")
            else
                Djim:Print("Requests are enabled again")
            end
        end
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then
            return
        end
        tooltip:AddLine("Djim's Deathroll")
        tooltip:AddLine(format(TT_ENTRY, "left click", "Open deathroll overview"))
        tooltip:AddLine(format(TT_ENTRY, "right click", "Open the options menu"))
        tooltip:AddLine(format(TT_ENTRY, "middle click", "Silence the addon"))
    end
})
local icon = LibStub("LibDBIcon-1.0")

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

    self:RegisterChatCommand("deathroll", "DeathRollRequestWindow")
    self:RegisterChatCommand("sneaky", "SneakyFunc")
end

function Djim:OnEnable()

    Djim:WelcomeText()

    AceComm:RegisterComm(prefix, function(prefix, text, channel, sender)
        -- comm received
        -- don't do anything
        if self.db.profile.modSilenced then
            SendChatMessage("I silenced deathrolls for now...", "whisper", nil, sender)
            return
        end
        if UnitAffectingCombat("player") then
            SendChatMessage("I am currently in combat, please try again later!", "whisper", nil, sender)
            return
        end

        if string.find(text, "checkAddon") or string.find(text, "hasAddon") then
            Djim:AddonCheck(text, sender)
        elseif string.find(text, "deathrollchallengerequest:") then
            Djim:DeathRollChallengeRequest(text, sender)
        elseif string.find(text, "deathrollchallengeresponse:") then
            Djim:DeathRollChallengeResponse(text, sender)
        elseif string.find(text, "deathrollchallengeaccept:") then
            Djim:DeathRollChallengeAccept(text, sender)
        elseif string.find(text, "deathrollchallengedecline:") then
            Djim:DeathRollChallengeDecline(text, sender)
        elseif string.find(text, "deathrollinforequest:") then
            Djim:DeathRollInfoRequest(prefix, text, channel, sender)
        elseif string.find(text, "deathrollinforesponse:") then
            Djim:DeathRollInfoResponse(prefix, text, channel, sender)
        else
            Djim:DeathRoll(prefix, text, channel, sender)

        end
    end)

    Djim:RandomFunc()
end

function Djim:OnDisable()
    -- code
end

function Djim:SneakyFunc()
    Djim.db.profile.sneakyMode = not Djim.db.profile.sneakyMode
    Djim:Print("Sneaky mode: " .. tostring(Djim.db.profile.sneakyMode))
end
