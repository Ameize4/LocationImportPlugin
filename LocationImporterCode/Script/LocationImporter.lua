local module = {}

local cloneLightProperty = require(script.cloneLightProperty)
local terrainSaveLoad = require(script.terrainSaveLoad)

module.destinationFolder = nil

function module.setDestinationFolder(folder)
	module.destinationFolder = folder
end

local function createFolder(name)
	local folder = Instance.new("Folder")
	folder.Parent = game.ServerStorage
	folder.Name = name
	return folder
end

local function replace(parent: Instance, folder: Instance)
	local name = folder.Name
	local oldFolder = parent:FindFirstChild(name)
	if oldFolder then
		oldFolder:Destroy()
	end
	
	folder.Parent = parent
end

local function cloneWorkspace()
	local folder= Instance.new("Folder")
	folder.Name = "Workspace"
	
	for idx, child in workspace:GetChildren() do
		if child.ClassName == 'Camera' or child.ClassName == 'Terrain' or not child.Archivable or child.Name == "AnimSaves" then
			continue
		end
		child:Clone().Parent = folder
	end
	
	folder:SetAttribute("GlobalWind", workspace.GlobalWind)
	return folder
end

local function cloneLight()
	local folder= Instance.new("Folder")
	folder.Name = "Lighting"
	
	local contentFolder = Instance.new("Folder")
	contentFolder.Name = "Content"
	contentFolder.Parent = folder

	for idx, child in game.Lighting:GetChildren() do
		child:Clone().Parent = contentFolder
	end
	
	local lightConfig = cloneLightProperty()
	lightConfig.Parent = folder
	return folder
end

local function cloneTerrainAndCloud(): TerrainRegion
	local terrain = terrainSaveLoad.Save()
	terrain.Name = 'Terrain'
	
	local clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
	clouds = clouds and clouds:Clone()
	if clouds then
		clouds.Parent = terrain
	end
	
	return terrain
end

function module.importAll()
	if not module.destinationFolder then
		warn("Cannot find target package in ServerStorage")
		return
	end
	
	local workspaceFolder = cloneWorkspace()
	local lightFolder = cloneLight()
	local terrain = cloneTerrainAndCloud()

	replace(module.destinationFolder, workspaceFolder)
	replace(module.destinationFolder, lightFolder)
	replace(module.destinationFolder, terrain)
end

return module
