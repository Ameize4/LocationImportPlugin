local RunService = game:GetService("RunService")
if not RunService:IsEdit() then return end -- Prevent plugin script errors in runtime

-- Insert asset id here
local AssetPackageId = 1


local success, asset = pcall(function()
	return game.InsertService:LoadAsset(AssetPackageId)
end)
if not success then
	warn(string.format("Cannot load plugin from package '%s'.", AssetPackageId))
	return
end

local pluginCode = require(asset:FindFirstChildOfClass("Folder"):FindFirstChildOfClass("ModuleScript"))

pluginCode.Init(plugin)