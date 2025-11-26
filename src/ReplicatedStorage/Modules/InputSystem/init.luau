--!nocheck
local m = {}
local UserInputService = game:GetService("UserInputService")

local signal = require(script.Signal)
local t = require(script.t)

-- (name: string)
local actionAdded = signal.new():: signal.Signal<string>

-- Created Actions
local actionsSignals = {} :: {
	[string]: t.actionSignal
}

local inputConnections = {} :: {
	[string]: { -- action name
		-- action input type (keyboard, ui, mobile)
		-- input connection like : <UserInputService.InputBegan>, <UserInputService.TouchTapInWorld> and so on
		[string]: signal.Signal
	}
}

local activeInputKeys = {}

m.actionsNames = require(script.DefaultActions).names

--[[================================================================]]

local useInput = {
	["key"] = function(name: string,key: Enum.KeyCode)
		if not actionsSignals[name] then return end
		if not key or typeof(key) ~= "EnumItem" then return end
		if tostring(key.EnumType) ~= "KeyCode" then return end
		local _type = "key"
		
		updateConnection(name,_type)
		
		inputConnections[name][_type] = UserInputService.InputBegan:Connect(function(object, focusUI)
			if focusUI then return end
			if not (object.KeyCode == key) then return end -- continue if same key
			if not actionsSignals[name] then return end
			
			actionsSignals[name]:Fire(_type)
		end)
	end,
	
	["mouse"] = function(name: string, key: Enum.UserInputType)
		if not actionsSignals[name] then return end
		if not key or typeof(key) ~= "EnumItem" then return end
		if key.EnumType ~= Enum.UserInputType then return end
		local customRay = if typeof(key) == "table" then key else false
		local _type = "mouse"
		
		updateConnection(name,_type)
		
		inputConnections[name][_type] = UserInputService.InputBegan:Connect(function(object, focusUI)
			if focusUI then return end
			if not (object.UserInputType == key) then return end
			local cam = workspace.CurrentCamera
			local mousePos = UserInputService:GetMouseLocation()
			local rayInfo = cam:ViewportPointToRay(mousePos.X,mousePos.Y)
			
			local target = false
			if customRay then
				target = fireRay({
					["Origin"] = rayInfo.Origin,
					["Direction"] = rayInfo.Direction * customRay["distance"],
					["tag"] = key.tag
				}
				,RaycastParams.new())
			end 
			
			actionsSignals[name]:Fire(_type,rayInfo,target)
		end)
	end,

	["ui"] = function(name: string, key: GuiButton)
		if not actionsSignals[name] then return end
		if not key or typeof(key) ~= "Instance" then return end
		if not key:IsA("GuiButton") then return end
		local _type = "ui"

		updateConnection(name,_type)
		
		inputConnections[name][_type] = key.Activated:Connect(function()
			actionsSignals[name]:Fire(_type)
		end)
		
	end,
	["mobileTap"] = function(name: string,key: t.customRay?)
		if not actionsSignals[name] then return end
		if not key then return end
		local customRay = if typeof(key) == "table" then key else false
		local _type = "screen"
		
		updateConnection(name,_type)
		
		inputConnections[name][_type] = UserInputService.TouchTapInWorld:Connect(function(pos, focusUI)
			if focusUI then return end
			local rayInfo = workspace.CurrentCamera:ViewportPointToRay(pos.X,pos.Y)
			local target = false
			if customRay then
				target = fireRay({
					["Origin"] = rayInfo.Origin,
					["Direction"] = rayInfo.Direction * customRay["distance"],
					["tag"] = key.tag
				}
				,RaycastParams.new())
			end 
			
			actionsSignals[name]:Fire(_type,rayInfo,target)
		end)
	end,
}

function fireRay(rayInfo: Ray & {tag: string}, params: RaycastParams): Instance | nil
	local newRay = workspace:Raycast(rayInfo.Origin,rayInfo.Direction,params)
	if newRay and newRay.Instance:HasTag(rayInfo.tag) then
		return newRay.Instance
	end
	
	return nil
end

-- clean up old input connection
function updateConnection(name: string,_type: string)
	local hasConnection = inputConnections[name][_type]
	if hasConnection then
		hasConnection:Disconnect()
	end
end

--[[================================================================]]

function m.createAction(name: string,inputKeys: t.inputType): t.actionSignal
	inputConnections[name] = {}
	actionsSignals[name] = signal.new()
	activeInputKeys[name] = inputKeys
	
	for inputType,key in inputKeys do
		setupAction(name,inputType,key)
	end
	
	actionAdded:Fire(name)
	return actionsSignals[name]
end

function m.remap(name: string, inputKeys: t.inputType)
	for inputType,key in inputKeys do
		activeInputKeys[inputType] = inputKeys[inputType]
		setupAction(name,inputType,key)
	end
end

function setupAction(name: string, inputType, key)
	if not useInput[inputType] then return end
	useInput[inputType](name,key)
end

-- the action signal will return: the action name, and info if found
-- the action info for MobileTap is a ray
function m.getAction(name: string) : t.actionSignal
	if not name or typeof(name) ~= "string" or not m.actionsNames[name] then
		error("Incorrect action name")
	end
	
	if not actionsSignals[name] then
		return waitForAction(name)
	end

	return actionsSignals[name]
end

function waitForAction(name: string)
	local added = actionAdded:Wait()
	
	if added == name then
		return actionsSignals[name]
	end

	return waitForAction(name)
end

function m.getAllSignals()
	return actionsSignals
end

function m.getActionsConfig()
	return activeInputKeys
end

return m