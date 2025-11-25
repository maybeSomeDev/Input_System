-- How to use:
--[[
1- To create a new action:

got to DefaultActions and register the action name in m.names
```lua
m.names = {
	["normal"] = "normal"
}
```

then go to m.actions, and give it the name, and fill up the input method you want to use for this action
	?: you can have more than one input method for the same action
	!: but you can't have multiple input methods of the same type ( multiple keys )
	
```lua
	["normal"] = {
		["key"] = Enum.KeyCode.F
	}
```

2- To get the action you created and detect when it's used:

```lua
-- required the module
local InputSystem = require(game.ReplicatedStorage.InputSystem)
-- get the names table, an autocomplete for all the action names you created 
local actions = InputSystem.actionsNames
-- get the action
local normal = InputSystem.getAction(actions.normal)

-- detect when the action is used

function activated(name: string)
	print("Player tried to use this action: "..name)
end

action:Connect(activated)
```

3- to remap an action or to link it UIButton
```lua
InputSystem.remap(name,
	{
		["key"] = Enum.KeyCode.G
	})
```

```lua
local jumpButtom = path
InputSystem.remap(name,
	{
		["ui"] = jumpButtom
	})
```
]]

-- What to input, and what it'll return
--[[
{
	["actionName"] { -- from m.names
			[inputType Name] = Input Key ( Enum.KeyCode, and so on)
		},
================================================================

	["test"] = {
		key = Enum.KeyCode.X,
		ui = GuiButton, --> set this using the remap function
		mobileTap = true,
		mouse = Enum.UserInputType.MouseButton1
	},

	["test2"] = {
		key = Enum.KeyCode.C,
		ui = GuiButton, --> set this using the remap function
		mobileTap= {
			tag = "door", --> part tag
			distance = "50" --> distance from camera
		},
		mouse= {
			key = Enum.UserInputType.MouseButton2,
			tag = "player",
			distance = "50" --> distance from camera
		}
	},
================================================================

	-- any action will give its <name>
	-- actions with rays will provide the the <rayinfo>
		--	( mobileTab will always provide it, even without a custom ray )
	-- actions with custom rays will provide <rayinfo> and <target>
	
	InputSystem.getAction(name):Connect(function(name: string, rayinfo: Ray, traget: BasePart | nil )

	end)
]]

-- Files Description
--[[
	InputSystem -> main module
	DefaultActions -> <name>
		DefaultActionsSetup
	signal -> signal module ( u can replace this )
	t -> types
]]