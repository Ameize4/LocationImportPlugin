local module = {}

--NEW_COM внутри скрипта лежал интерфейс как объект, с чем и работает код. Для понимания цели кода гуи не нужен, и мне очень лень его импортить
local gui = script.Frame
local widget
local event: BindableEvent
local conn: RBXScriptConnection?

local publishKeys = {}
local sourcePackageKey, targetPackageKey

function module.getOrCreateWidget(plugin)
	-- throw plugin as input because we can access plugin only from root script, not from modules
	
	if widget ~= nil then return widget end
	
	local info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left, false, false, 50, 50, 1, 1)
	widget = plugin:CreateDockWidgetPluginGui("TestWidget2", info)
	
	--fillWidget(widget)
	gui:Clone().Parent = widget
	return widget
end

function module.Clean()
	table.clear(publishKeys)
	
	for i, v in widget.Frame.Container:GetChildren() do
		if v:IsA("TextButton") and v.Visible then
			v:Destroy()
		end
	end
end

function module.setWidgetText(content)
	if not widget then
		return
	end
	
	local template = widget.Frame.Container.TextButton
	for key, item in content do
		local tem = template:Clone()
		tem.Parent = template.Parent
		tem.Name = key
		tem.Text = key
		tem.Visible = true
		tem.Active = true
		tem.Activated:Connect(function()
			local savedIdx = table.find(publishKeys, key)
			if savedIdx then
				table.remove(publishKeys, savedIdx)
				tem.UIStroke.Enabled = false
			else
				table.insert(publishKeys, key)
				tem.UIStroke.Enabled = true
			end
		end)
	end
end

function module.connectSourceTargetButton()
	local inp = {
		"PackageId",
		"QaPackageId",
		"RcPackageId",
		"PRODPackageId",
	}
	sourcePackageKey = inp[1]
	targetPackageKey = inp[2]
	widget.Frame.Header.Source.Text = sourcePackageKey
	widget.Frame.Header.Target.Text = targetPackageKey
	
	local function getNextValue(_table, value)
		local idx = table.find(_table, sourcePackageKey)
		idx += 1
		if idx > #_table then idx = 1 end
		return _table[idx]
	end
	
	widget.Frame.Header.Source.Activated:Connect(function()
		sourcePackageKey = getNextValue(inp, sourcePackageKey)
		widget.Frame.Header.Source.Text = sourcePackageKey
	end)
	widget.Frame.Header.Target.Activated:Connect(function()
		targetPackageKey = getNextValue(inp, targetPackageKey)
		widget.Frame.Header.Target.Text = targetPackageKey
	end)
	
end

function module.connectFinalButton(event: BindableEvent)
	if conn then
		conn:Disconnect()
	end
	local button = widget.Frame.TextButton
	conn = button.Activated:Connect(function()
		event:Fire(publishKeys, sourcePackageKey, targetPackageKey)
	end)
end

return module
