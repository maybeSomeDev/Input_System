local t = require("./t")

local m = {}

m.actions = {
	["normal"] = {
		["key"] = Enum.KeyCode.F
	},	
}:: {
	[string]: t.inputType
}

-- don't forget to add the actions name from m.action to here
m.names = {
	["normal"] = "normal",
}

return m