local inputSystem = require("./")
local default = require("./DefaultActions")

for name,inputType in default.actions do
	inputSystem.createAction(name,inputType)
end