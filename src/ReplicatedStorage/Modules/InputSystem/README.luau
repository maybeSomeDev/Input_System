-- https://github.com/maybeSomeDev/Input_System

--[[
# How to Use
1- Create a new action

Go to [DefaultActions.luau](src/ReplicatedStorage/Modules/InputSystem/DefaultActions.luau) and add the action name in the `m.names`
```lua
m.names = {
	["normal"] = "normal"
}
```

Then in `m.actions`, create an action with the same name, and set the input method and key you want 
	?: You can have more than one input method for the same action
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
-- to have autocomplete for all the actions you created 
local actions = InputSystem.actionsNames
-- get the action
local normal = InputSystem.getAction(actions.normal)

-- detect when the action is used
function activated(name: string, rayinfo: Ray?, target: BasePart?)
	print("Player tried to use this action: "..name)
end

action:Connect(activated)
```
]]