local module = {}

function module.Init(plugin)
	local ImportButtonHandler = require(script.ImportButtonHandler)
	local ExportButtonHandler = require(script.ExportButtonHandler)

	-- Create toolbar
	local toolbar = plugin:CreateToolbar("toolbar")

	ImportButtonHandler.CreateButton(plugin, toolbar)
	ExportButtonHandler.CreateButton(plugin, toolbar)
end

return module