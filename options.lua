Djim.defaults = {
	profile = {
		someToggle = true,
		someRange = 7,
		someInput = "Hello World",
		someSelect = 2, -- Banana
        minimap = {
            hide = false
        },
        deathrollBuddy = "Falci",
        deathrollAmount = 8
	}
}

-- https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables
Djim.options = {
	type = "group",
	name = "Djim's Deathroll Configuration",
	handler = Djim,
	args = {
        deathrollBuddy = {
            type = "input",
            order = 1,
            name = "Who to challenge for Deathroll",
            width = "double",
         	get = "GetValue",
			set = "SetValue",
        },
        deathrollAmount = {
            type = "range",
            order = 2,
            name = "Amount for Deathroll",
			-- this will look for a getter/setter on our handler object
			get = "GetSomeRange",
			set = "SetSomeRange",
			min = 1, max = 1000, step = 1,
        },
		-- someToggle = {
		-- 	type = "toggle",
		-- 	order = 1,
		-- 	name = "a checkbox",
		-- 	desc = "some description",
		-- 	-- inline getter/setter example
		-- 	get = function(info) return Djim.db.profile.someToggle end,
		-- 	set = function(info, value) Djim.db.profile.someToggle = value end,
		-- },
		-- someRange = {
		-- 	type = "range",
		-- 	order = 2,
		-- 	name = "a slider",
		-- 	-- this will look for a getter/setter on our handler object
		-- 	get = "GetSomeRange",
		-- 	set = "SetSomeRange",
		-- 	min = 1, max = 10, step = 1,
		-- },
		-- someKeybinding = {
		-- 	type = "keybinding",
		-- 	order = 3,
		-- 	name = "a keybinding",
		-- 	get = "GetValue",
		-- 	set = "SetValue",
		-- },
		-- group1 = {
		-- 	type = "group",
		-- 	order = 4,
		-- 	name = "a group",
		-- 	inline = true,
		-- 	-- getters/setters can be inherited through the table tree
		-- 	get = "GetValue",
		-- 	set = "SetValue",
		-- 	args = {
		-- 		someInput = {
		-- 			type = "input",
		-- 			order = 1,
		-- 			name = "an input box",
		-- 			width = "double",
		-- 		},
		-- 		deathrollBuddy = {
		-- 			type = "input",
		-- 			order = 1,
		-- 			name = "an input box",
		-- 			width = "double",
		-- 		},
		-- 		someDescription = {
		-- 			type = "description",
		-- 			order = 2,
		-- 			name = function() return format("The current time is: |cff71d5ff%s|r", date("%X")) end,
		-- 			fontSize = "large",
		-- 		},
		-- 		someSelect = {
		-- 			type = "select",
		-- 			order = 3,
		-- 			name = "a dropdown",
		-- 			values = {"Apple", "Banana", "Strawberry"},
		-- 		},
		-- 	},
		-- },
	},
}

function Djim:GetSomeRange(info)
	return self.db.profile.deathrollAmount
end

function Djim:SetSomeRange(info, value)
	self.db.profile.deathrollAmount = value
end

-- for documentation on the info table
-- https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4-1
function Djim:GetValue(info)
	return self.db.profile[info[#info]]
end

function Djim:SetValue(info, value)
	self.db.profile[info[#info]] = value
end