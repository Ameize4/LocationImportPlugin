local ImportButtonHandler = {}

local LocationImporter = require(script.Parent.LocationImporter)
local PackageConfig = require(script.Parent.PackageConfig)
local TextConfig = require(script.Parent.TextConfig)

local PopupWindowHandler = require(script.PopupWindowHandler)

local currentGameId = game.GameId
local currentPlaceId = game.PlaceId

local currentPlaceKey = PackageConfig.GetPlaceKeyById(currentPlaceId)
local targetPackageId = currentPlaceKey and PackageConfig.PackageId[currentPlaceKey]

function ImportButtonHandler.CreateButton(plugin, toolbar: PluginToolbar)
	local newScriptButton = nil
	
	if not currentPlaceKey then
		local pluginTooltip = "Plugin not configured for this place"
		newScriptButton = toolbar:CreateButton("Import location", pluginTooltip, "rbxassetid://4458901886")
		newScriptButton.Enabled = false
		return
	else
		newScriptButton = toolbar:CreateButton("Import location", "Import location", "rbxassetid://4458901886")
		newScriptButton.ClickableWhenViewportHidden = true
	end


	local function checkPackage(): PackageLink
		local targetId = string.format('rbxassetid://%s', targetPackageId)

		local packageLink
		for idx, child: PackageLink in game.ServerStorage:GetDescendants() do
			if child.ClassName == 'PackageLink' and child.PackageId == targetId then
				packageLink = child
			end
		end
		return packageLink
	end

	newScriptButton.Click:Connect(function()
		local widget = PopupWindowHandler.getOrCreateWidget(plugin)
		widget.Enabled = true
		local packageLink = checkPackage()

		if not packageLink then
			PopupWindowHandler.setWidgetText(TextConfig.TextLabel.NoLocation)
			warn(string.format('https://create.roblox.com/marketplace/asset/%s', targetPackageId))
			return
		end

		PopupWindowHandler.setWidgetText(TextConfig.TextLabel.OK)
		LocationImporter.setDestinationFolder(packageLink.Parent)
		LocationImporter.importAll()
		
		packageLink.Parent:WaitForChild("Workspace"):SetAttribute("PackageVersion", packageLink.VersionNumber+1)

		game:GetService("Selection"):Set({packageLink.Parent})
	end)

end

return ImportButtonHandler
