-- filepath: c:\Users\brandon\Documents\RobloxProjects\tutorial\src\client\ui\ObbyUI.client.luau
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ObbyUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(0, 200, 0, 40)
timerLabel.Position = UDim2.new(0, 10, 0, 10)
timerLabel.BackgroundTransparency = 0.5
timerLabel.Text = "Time: 0.00"
timerLabel.Parent = screenGui

local checkpointLabel = Instance.new("TextLabel")
checkpointLabel.Size = UDim2.new(0, 200, 0, 40)
checkpointLabel.Position = UDim2.new(0, 10, 0, 60)
checkpointLabel.BackgroundTransparency = 0.5
checkpointLabel.Text = "Checkpoint: 0"
checkpointLabel.Parent = screenGui

local startTime = 0
local running = false
local conn

local UI = {}

function UI:StartTimer()
    startTime = tick()
    running = true
    if conn then conn:Disconnect() end
    conn = RunService.RenderStepped:Connect(function()
        if not running then return end
        local elapsed = tick() - startTime
        timerLabel.Text = string.format("Time: %.2f", elapsed)
    end)
end

function UI:UpdateCheckpoint(i)
    checkpointLabel.Text = "Checkpoint: " .. tostring(i)
end

function UI:Finish()
    running = false
    if conn then conn:Disconnect() end
    timerLabel.Text = timerLabel.Text .. " (Finished)"
end

return UI
