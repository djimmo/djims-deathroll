local deathRollRequestWindow

function Djim:DeathRollRequestWindow()

    -- Close window if it was open, otherwise recreate
    if deathRollRequestWindow and deathRollRequestWindow:IsShown() then
        deathRollRequestWindow:Release()
        return
    end

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

    -- local checkbox = AceGUI:Create("CheckBox")
    -- checkbox:SetLabel("Manual")
    -- -- checkbox:SetRelativeWidth(1)
    -- f:AddChild(checkbox)

    local opponent = AceGUI:Create("EditBox")
    opponent:SetFullWidth(true)
    opponent:SetLabel("Your opponent")
    opponent:SetText(self.db.profile.deathrollBuddy)
    opponent:SetCallback("OnEnterPressed", function(_, __, playerName)
        self:Print("Opponent changed to " .. playerName)
        self.db.profile.deathrollBuddy = playerName
        Djim:AddonCheck("requestCheckAddon", playerName)
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
    btn:SetText("Deathroll")
    btn:SetCallback("OnClick", function()
        AceComm:SendCommMessage(prefix, "deathrollchallengerequest:" .. Djim.db.profile.deathrollAmount, "WHISPER",
            Djim.db.profile.deathrollBuddy)
        Djim:Print("Challenged " .. Djim.db.profile.deathrollBuddy .. " to a Deathroll for " ..
                       Djim.db.profile.deathrollAmount .. ' gold.')
    end)

    -- Add the button to the container
    f:AddChild(btn)

    -- Add the frame as a global variable under the name `MyGlobalFrameName`
    _G["DjimsDeathRollRequestWindow"] = f.frame
    -- Register the global variable `MyGlobalFrameName` as a "special frame"
    -- so that it is closed when the escape key is pressed.
    tinsert(UISpecialFrames, "DjimsDeathRollRequestWindow")

    f:Show()

    deathRollRequestWindow = f
    -- return f
end

function Djim:DeathRollResponseWindow(playerName, gold)

    Djim:Print(playerName .. " challenged you to a Deathroll for " .. gold .. " gold!")

    PlaySound(SOUNDKIT.READY_CHECK)
    
    local f = AceGUI:Create("Frame")
    f:Hide()
    f:SetWidth(300)
    f:SetHeight(200)
    f:SetCallback("OnClose", function(widget)
        AceGUI:Release(widget)
    end)
    f:SetTitle("Djim's Deathroll")
    f:SetStatusText("Deathrolls for life!")
    f:SetLayout("Flow")

    local label = AceGUI:Create("Label")
    label:SetFullWidth(true)
    label:SetText("It looks like " .. playerName .. " wants to challenge you to a deathroll for " .. gold ..
                      "g. \n\nDo you accept?")
    f:AddChild(label)

    local btn = AceGUI:Create("Button")
    btn:SetFullWidth(true)
    btn:SetWidth(170)
    btn:SetText("Accept")
    btn:SetCallback("OnClick", function()
        self.db.profile.deathrollBuddy = playerName
        self.db.profile.deathrollAmount = gold
        acceptRolls = true
        Djim:Print("Accepted a Deathroll with " .. self.db.profile.deathrollBuddy .. " for " ..
                       self.db.profile.deathrollAmount .. ' gold.')
        AceComm:SendCommMessage(prefix, "deathrollchallengeaccept:" .. Djim.db.profile.deathrollAmount, "WHISPER",
            self.db.profile.deathrollBuddy)
        RandomRoll(1, Djim.db.profile.deathrollAmount * 10)
        AceGUI:Release(f)
    end)
    -- Add the button to the container
    f:AddChild(btn)

    local btn = AceGUI:Create("Button")
    btn:SetFullWidth(true)
    btn:SetWidth(170)
    btn:SetText("Decline")
    btn:SetCallback("OnClick", function()
        acceptRolls = false
        Djim:Print("Declined a Deathroll with " .. self.db.profile.deathrollBuddy .. " for " ..
                       self.db.profile.deathrollAmount .. ' gold.')
        AceComm:SendCommMessage(prefix, "deathrollchallengedecline:" .. Djim.db.profile.deathrollAmount, "WHISPER",
            self.db.profile.deathrollBuddy)
        AceGUI:Release(f)
    end)
    -- Add the button to the container
    f:AddChild(btn)

    -- Add the frame as a global variable under the name `MyGlobalFrameName`
    _G["DjimsDeathRollResponseWindow"] = f.frame
    -- Register the global variable `MyGlobalFrameName` as a "special frame"
    -- so that it is closed when the escape key is pressed.
    tinsert(UISpecialFrames, "DjimsDeathRollResponseWindow")

    f:Show()
end
