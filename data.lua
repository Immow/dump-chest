local entities = {
	["logistic-chest-active-provider"] = {"logistic-system"},
	["logistic-chest-storage"] = {"construction-robotics", "logistic-robotics"}
}

for entity, techs in pairs(entities) do
	local activeDumpChest = table.deepcopy(data.raw["item"][entity])
	local name = "dump-"..entity

	activeDumpChest.place_result = name
	activeDumpChest.name = name
	activeDumpChest.icons = {
		{
			icon = "__dumpchest__/icons/"..name..".png",
			icon_size = 64,
			icon_mipmaps = 4,
		}
	}

	local recipe = table.deepcopy(data.raw["recipe"][entity])

	recipe.name = name
	recipe.ingredients = {{"electronic-circuit",3},{"advanced-circuit",1},{"steel-chest",1}}
	recipe.result = name

	for _, tech in pairs(techs) do
		local effects = data.raw.technology[tech].effects
		effects[#effects+1] = {
			type = "unlock-recipe",
			recipe = name
		}
	end

	local entity = table.deepcopy(data.raw["logistic-container"][entity])
	entity.name = name
	entity.animation.layers[1].filename = "__dumpchest__/image/"..name..".png"
	entity.animation.layers[1].hr_version.filename = "__dumpchest__/image/hr-"..name..".png"
	entity.minable.result = name

	data:extend{activeDumpChest, recipe, entity}
end



