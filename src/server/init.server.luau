-- POC obby bootstrap (added by apply_obby_patch.ps1)
local ObbyManager = require(script.ObbyManager)
local SpawnHandler = require(script.SpawnHandler)

if ObbyManager and type(ObbyManager.Generate) == "function" then
	ObbyManager:Generate(12)
end
