local PublishButtonHandler = {}

local InsertService = game:GetService("InsertService")
local PackageConfig = require(script.Parent.PackageConfig)
local PopupWindowHandler = require(script.PopupWindowHandler)

local bindableEvent = Instance.new("BindableEvent")


local function checkPackage(targetPackageId): PackageLink?
	-- Find package by id
	local targetId = string.format('rbxassetid://%s', targetPackageId)
	
	local packageLink
	for idx, child: PackageLink in game.ServerStorage:GetDescendants() do
		if child.ClassName == 'PackageLink' and child.PackageId == targetId then
			packageLink = child
		end
	end
	return packageLink
end

function PublishButtonHandler.CreateButton(plugin, toolbar: PluginToolbar)
	--NEW_COM деактивация плагина чтобы пользующиеся не использовали его случайно при работе в другом проекте
	if game.PlaceId ~= 14469473789 then return end 
	
	local newScriptButton = toolbar:CreateButton("Export to", "", "rbxassetid://4458901886")
	newScriptButton.ClickableWhenViewportHidden = true
	
	local widget = PopupWindowHandler.getOrCreateWidget(plugin)
	PopupWindowHandler.connectSourceTargetButton()
	PopupWindowHandler.connectFinalButton(bindableEvent)
	newScriptButton.Click:Connect(function()
		if widget.Enabled then
			widget.Enabled = false
			return
		end
		
		PopupWindowHandler.Clean()
		PopupWindowHandler.setWidgetText(PackageConfig.QaPackageId)
		widget.Enabled = true
	end)
end

bindableEvent.Event:Connect(function(keyTable, sourceKey, targetKey)
	--[[NEW_COM
		Функция этого скрипта - получить список локаций которые нужно публиковать (keyTable), и продублировать их в нужные пакеты.
		Для каждой локации есть 4 версии - DEV, QA, RC, PROD. В плагине можно выбирать, что будет source и куда будет импорт (target)
	--]]
	local packages = {}
	local objectToSelect = {}
	for idx, key in keyTable do
		packages[key] = {}
		local sourceId = PackageConfig[sourceKey][key]
		local targetId = PackageConfig[targetKey][key]

		local sourcePackage = InsertService:LoadAsset(sourceId):FindFirstChildOfClass("Folder")
		local targetPackageLink = checkPackage(targetId)
		
		if not (sourcePackage and targetPackageLink) then
			warn('Mising package for', key, 'abort operation')
			return
		end

		packages[key]['SOURCE'] = sourcePackage
		packages[key]['TARGET'] = targetPackageLink.Parent
		table.insert(objectToSelect, targetPackageLink.Parent)
	end
	
	for key, values in packages do
		local sourcePackage = values['SOURCE']
		local targetPackage = values['TARGET']
		
		for idx, child in sourcePackage:GetChildren() do
			if child:IsA("PackageLink") then continue end
			local oldChild = targetPackage:FindFirstChild(child.Name)
			if oldChild then oldChild:Destroy() end
			
			local newChild = child:Clone()
			newChild.Parent = targetPackage
		end
		--NEW_COM Обход ограничений роблокса, необходимый для вывода версии пакета при запуске игры
		targetPackage:WaitForChild("Workspace"):SetAttribute("PackageVersion", targetPackage.PackageLink.VersionNumber+1)
	end

	game:GetService("Selection"):Set(objectToSelect)
end)

return PublishButtonHandler
