Djim.defaults = {
	profile = {
		modSilenced = false,
		options = {
            block_incoming = false
        },
        database_options = {
            initialized = false
        },
        minimap = {
            hide = false
        },
        deathrollBuddy = "",
        deathrollAmount = 100,
		deathrollMax = 10000
	}
}

-- https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables
Djim.options = {
	type = "group",
	name = "Djim's Deathroll Configuration",
	handler = Djim,
	args = {
        -- deathrollBuddy = {
        --     type = "input",
        --     order = 1,
        --     name = "Who to challenge for Deathroll",
        --     width = "double",
        --  	get = "GetValue",
		-- 	set = "SetValue",
        -- },
        deathrollMax = {
            type = "range",
            order = 2,
            name = "Max Amount Slider for Deathroll",
			-- this will look for a getter/setter on our handler object
			get = "GetSomeRange",
			set = "SetSomeRange",
			min = 1, max = 10000, step = 1,
        },
		modSilenced = {
			type = "toggle",
			order = 1,
			name = "Silence the add-on",
			desc = "Silence",
			-- inline getter/setter example
			get = function(info) return Djim.db.profile.modSilenced end,
			set = function(info, value) Djim.db.profile.modSilenced = value end,
		},
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
	return self.db.profile.deathrollMax
end

function Djim:SetSomeRange(info, value)
	self.db.profile.deathrollMax = value
end

-- for documentation on the info table
-- https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4-1
function Djim:GetValue(info)
	return self.db.profile[info[#info]]
end

function Djim:SetValue(info, value)
	self.db.profile[info[#info]] = value
end