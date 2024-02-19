return function()
	--NEW_COM в роблоксе нельзя получить список всех пропертей объекта, поэтому здесь пошли простым путем и просто выписали нужное
	local properties = {"Ambient", "Brightness", "ClockTime", "ColorShift_Bottom", "ColorShift_Top", "EnvironmentDiffuseScale", "EnvironmentSpecularScale", "ExposureCompensation", "FogColor", "FogEnd", "FogStart", "GeographicLatitude", "GlobalShadows", "OutdoorAmbient", "Outlines", "ShadowColor", "ShadowSoftness", "TimeOfDay"}

	local Lighting = game:GetService("Lighting")
	local configuration = Instance.new("Configuration")

	for _, property in pairs(properties) do
		local value = Lighting[property]
		local valueInstance = nil

		if typeof(value) == "boolean" then
			valueInstance = Instance.new("BoolValue")
		elseif typeof(value) == "number" then
			valueInstance = Instance.new("NumberValue")
		elseif typeof(value) == "string" then
			valueInstance = Instance.new("StringValue")
		elseif typeof(value) == "Color3" then
			valueInstance = Instance.new("Color3Value")
		else
			continue
		end

		valueInstance.Name = property
		valueInstance.Value = value
		valueInstance.Parent = configuration
	end
	
	return configuration
end