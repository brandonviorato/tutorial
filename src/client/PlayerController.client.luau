-- filepath: c:\Users\brandon\Documents\RobloxProjects\tutorial\src\client\PlayerController.client.luau
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = Shared:WaitForChild("Events")
local CheckpointEvent = Events:WaitForChild("CheckpointUpdate")
local FinishEvent = Events:WaitForChild("ObbyFinished")

local ui = require(script.Parent.ui.ObbyUI)

local currentCheckpoint = 0
local started = false

player.CharacterAdded:Connect(function()
	currentCheckpoint = 0
	started = true
	ui:StartTimer()
end)

CheckpointEvent.OnClientEvent:Connect(function(index)
	currentCheckpoint = index
	ui:UpdateCheckpoint(index)
end)

FinishEvent.OnClientEvent:Connect(function()
	ui:Finish()
end)
