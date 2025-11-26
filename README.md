# Input_System
An input wrapper for Roblox.

This is a personal project.

## Table of Contents
* [How to Use](#how-to-use)
* [Example Actions](#example-actions)
* [Input Methods & Returns](#input-methods--returns)
* [Pros](#pros)
* [Cons](#cons)
* [Reasons to Use](#reasons-to-use)

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
function activated(name: string)
	print("Player tried to use this action: "..name)
end

action:Connect(activated)
```

3- to remap an action or to link it to a UIButton
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

## Example Actions
in [DefaultActions.luau](src/ReplicatedStorage/Modules/InputSystem/DefaultActions.luau) / `m.actions`
```lua
["actionName"] { -- from m.names
  [inputType Name] = Input Key ( Enum.KeyCode, and so on)
}
```
```lua
["test"] = {
  key = Enum.KeyCode.X,
  ui = GuiButton, --> set this using the remap function
  mobileTap = true,
  mouse = Enum.UserInputType.MouseButton1
},

["test2"] = {
key = Enum.KeyCode.C,
ui = GuiButton, --> set this using the remap function
-- example of custom rays
  -- the module will fire a ray when this action is used, and (if found) return a part with the tag specified here
mobileTap = {
  tag = "door", --> part tag
  distance = "50" --> distance from camera
},
mouse = {
  key = Enum.UserInputType.MouseButton2,
  tag = "player",
  distance = "50" --> distance from camera
}
```

## Input Methods & Returns
| Input Method | Key Type | Accepts Custom Rays | Returns |
|:---:|:---:|:---:|:---:|
| key | Enum.KeyCode | ❌ | name |
| ui | GuiObject | ❌ | name |
| mouse | Enum.UserInputType | ✅ | name, rayinfo`?`, target`?` |
| mobileTap | true | ✅ | name, rayinfo, target`?` |

- All actions will return their `name`
- Actions with rays will provide the `rayinfo` (`mobileTab` will always provide it, even without a custom ray)
  - `rayinfo`: A Unit ray from the player camera toward the tap/mouse position.
- Actions with custom rays will return `rayinfo` and `target`
  - `target`: The module will fire a ray and return the instance found
```lua
InputSystem.getAction(name):Connect(function(name: string, rayinfo: Ray, target: BasePart | nil )

end)
```
## Pros
- Server Side Only

## Cons
- You don't get to pick between "InputBegan" and "InputEnded"
- Only one key per Input Method

## Reasons to Use
