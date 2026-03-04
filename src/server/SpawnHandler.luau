-- filepath: c:\Users\brandon\Documents\RobloxProjects\tutorial\src\server\SpawnHandler.server.luau
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local function teleportToStart(character)
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end
    local start = Workspace:FindFirstChild("Obby") and Workspace.Obby:FindFirstChild("StartPlatform")
    if start then
        hrp.CFrame = start.CFrame + Vector3.new(0, 5, 0)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- small delay to ensure character parts exist
        task.wait(0.1)
        teleportToStart(character)
        -- init checkpoint attribute
        player:SetAttribute("LastCheckpoint", 0)
    end)
end)

return {}
