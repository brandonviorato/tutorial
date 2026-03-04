-- filepath: c:\Users\brandon\Documents\RobloxProjects\tutorial\src\shared\TimerModule.luau
local TimerModule = {}

function TimerModule.format(seconds)
	local s = math.floor(seconds % 60)
	local m = math.floor(seconds / 60)
	return string.format("%02d:%02d", m, s)
end

return TimerModule
