local PackageConfig = {}

--NEW_COM вместо нулей должны быть id. но вы сами понимаете
PackageConfig.PlaceIdConfig = {
	--LocImportExample = 0,
	Hub = 0,
	Australia = 0,
	Chicago = 0,
	SantaMonica = 0,
	Seoul = 0,
	Toronto = 0,
}

PackageConfig.PackageId = {
	--LocImportExample=14298530220,
	Hub=0,
	Australia=0,
	Chicago=0,
	SantaMonica=0,
	Seoul=0,
	Toronto=0,
}

PackageConfig.QaPackageId = {
	--LocImportExample=14298530220,
	Hub=0,
	Australia=0,
	Chicago=0,
	SantaMonica=0,
	Seoul=0,
	Toronto=0,
}

PackageConfig.RcPackageId = {
	--LocImportExample=14298530220,
	Hub=0,
	Australia=0,
	Chicago=0,
	SantaMonica=0,
	Seoul=0,
	Toronto=0,
}

PackageConfig.PRODPackageId = {
	--LocImportExample=14298530220,
	Hub=0,
	Australia=0,
	Chicago=0,
	SantaMonica=0,
	Seoul=0,
	Toronto=0,
}

function PackageConfig.GetPlaceKeyById(id): number?
	for k, v in PackageConfig.PlaceIdConfig do
		if id == v then
			return k
		end
	end
	return nil
end

return PackageConfig
