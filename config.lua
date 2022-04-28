Config = {}

Config.Locale = 'en'

Config.Delays = {
	Processing = 1000 * 2
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. 

Config.GiveBlack = false -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	WeedField = {coords = vector3(2031.44, 4878.57, 42.89), name = 'blip_weedfield', color = 25, sprite = 496, radius = 100.0},
	ChemicalField = {coords = vector3(1547.21, 3817.65, 30.54), name = 'blip_chemicalfield', color = 25, sprite = 496, radius = 100.0},
	CocaField = {coords = vector3(-2125.3, 1427.3, 284.79), name = 'blip_cocafield', color = 25, sprite = 496, radius = 100.0},
	WeedProcessing = {coords = vector3(2221.95, 5614.73, 54.9), name = 'blip_weedprocessing', color = 25, sprite = 496, radius = 100.0},
	MethProcessing = {coords = vector3(19.83, -2724.57, 6.02), name = 'blip_methprocessing', color = 25, sprite = 496, radius = 100.0},
	CocaProcessing = {coords = vector3(1343.41, 4390.29, 44.34), name = 'blip_cocaprocessing', color = 25, sprite = 496, radius = 100.0},
}