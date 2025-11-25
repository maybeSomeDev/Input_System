local singal = require("./signal")

export type inputType = {
	key: Enum.KeyCode,
	ui: GuiButton,
	mobileTap: customRay | any,
	mouse: _mouse
}

export type customRay = {
	tag: string,
	distance: number
}

export type _mouse = {
	["key"]: Enum.UserInputType
} & customRay

export type actionSignal = singal.Signal<string, Ray?, Instance?>

return {}