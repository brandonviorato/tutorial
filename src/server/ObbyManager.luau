-- filepath: c:\Users\brandon\Documents\RobloxProjects\tutorial\src\server\ObbyManager.server.luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:FindFirstChild("Shared") or Instance.new("Folder", ReplicatedStorage)
Shared.Name = "Shared"
local Events = Shared:FindFirstChild("Events") or Instance.new("Folder", Shared)
Events.Name = "Events"

local CheckpointEvent = Events:FindFirstChild("CheckpointUpdate")
if not CheckpointEvent then
	CheckpointEvent = Instance.new("RemoteEvent", Events)
	CheckpointEvent.Name = "CheckpointUpdate"
end

local FinishEvent = Events:FindFirstChild("ObbyFinished")
if not FinishEvent then
	FinishEvent = Instance.new("RemoteEvent", Events)
	FinishEvent.Name = "ObbyFinished"
end

local ObbyFolder = Workspace:FindFirstChild("Obby")
if not ObbyFolder then
	ObbyFolder = Instance.new("Folder", Workspace)
	ObbyFolder.Name = "Obby"
end

local function createPlatform(index, pos)
	local part = Instance.new("Part")
	part.Size = Vector3.new(8, 1, 8)
	part.Position = pos
	part.Anchored = true
	part.Name = "Platform_" .. tostring(index)
	part.Parent = ObbyFolder
	local idx = Instance.new("IntValue", part)
	idx.Name = "Index"
	idx.Value = index
	return part
end

local function createCheckpoint(index, platform)
	local cp = Instance.new("Part")
	cp.Size = Vector3.new(6, 2, 6)
	cp.CFrame = platform.CFrame * CFrame.new(0, 1.5, 0)
	cp.Anchored = true
	cp.CanCollide = false
	cp.Transparency = 0.5
	cp.Name = "Checkpoint_" .. tostring(index)
	cp.Parent = ObbyFolder

	cp.Touched:Connect(function(hit)
		local character = hit.Parent
		local player = Players:GetPlayerFromCharacter(character)
		if not player then
			return
		end
		-- set attribute on player for server-side state
		player:SetAttribute("LastCheckpoint", index)
		CheckpointEvent:FireClient(player, index)
		-- finish if last checkpoint
		if index == ObbyFolder:GetAttribute("TotalCheckpoints") then
			FinishEvent:FireClient(player)
		end
	end)
end

local ObbyManager = {}

function ObbyManager:Generate(length)
	-- clean-up
	for _, child in ipairs(ObbyFolder:GetChildren()) do
		child:Destroy()
	end

	local startX = 0
	local step = 12
	local totalPlatforms = length or 10
	local totalCheckpoints = 0

	local startPlatform = createPlatform(0, Vector3.new(startX, 3, 0))
	startPlatform.Name = "StartPlatform"
	startPlatform.BrickColor = BrickColor.new("Bright green")

	for i = 1, totalPlatforms do
		local pos = Vector3.new(startX + i * step, 3, 0)
		local p = createPlatform(i, pos)
		if i % 3 == 0 then
			totalCheckpoints = totalCheckpoints + 1
			createCheckpoint(totalCheckpoints, p)
		end
	end

	-- flag finish platform
	local finishPos = Vector3.new(startX + (totalPlatforms + 1) * step, 3, 0)
	local finish = createPlatform(totalPlatforms + 1, finishPos)
	finish.BrickColor = BrickColor.new("Bright yellow")
	finish.Name = "FinishPlatform"

	ObbyFolder:SetAttribute("TotalCheckpoints", totalCheckpoints)
	return true
end

return ObbyManager
