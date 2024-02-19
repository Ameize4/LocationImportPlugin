local module = {}

local widget

local function fillWidget(widget)
	local textColor = Color3.new(0,0,0)
	
	local studioTheme = settings().Studio.Theme
	if studioTheme and studioTheme.Name == 'Dark' then
		textColor = Color3.new(1,1,1)
	end
	
	local button = Instance.new("TextButton")
	button.BorderSizePixel = 0
	button.TextSize = 20
	button.AnchorPoint = Vector2.new(0.5, 0)
	button.Size = UDim2.new(0.64, 0, 0.15, 0)
	button.Position = UDim2.new(0.5, 0, 0.8, 0)
	button.TextColor3 = textColor
	button.Text = "OK"
	button.Parent = widget
	
	local textLabel = Instance.new("TextLabel")
	textLabel.BorderSizePixel = 0
	textLabel.BackgroundTransparency = 1
	textLabel.TextSize = 20
	textLabel.Size = UDim2.new(1, 0, 0.8, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.TextScaled = true
	textLabel.TextColor3 = textColor
	textLabel.Text = ''
	textLabel.Parent = widget
	
	local UITextSizeConstraint = Instance.new('UITextSizeConstraint')
	UITextSizeConstraint.MaxTextSize = 14
	UITextSizeConstraint:Clone().Parent = textLabel
	UITextSizeConstraint:Clone().Parent = button
	
	button.Activated:Connect(function()
		if not widget then return end
		widget.Enabled = false
	end)
end

function module.getOrCreateWidget(plugin)
	-- throw plugin as input because we can access plugin only from root script, not from modules
	
	if widget ~= nil then return widget end
	
	local info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 50, 50, 1, 1)
	widget = plugin:CreateDockWidgetPluginGui("TestWidget", info)
	
	fillWidget(widget)
	return widget
end

function module.setWidgetText(text)
	if not widget then
		return
	end
	
	widget.TextLabel.Text = text
end

return module
