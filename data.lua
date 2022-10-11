local entities = {
	"logistic-chest-active-provider",
	"logistic-chest-storage",
}

for _, entity in pairs(entities) do
	local activeDumpChest = table.deepcopy(data.raw["item"][entity])
	local name = "dump-"..entity

	activeDumpChest.place_result = name
	activeDumpChest.name = name
	activeDumpChest.icon = "__dumpchest__/icons/"..name..".png"

	local recipe = table.deepcopy(data.raw["recipe"][entity])
	recipe.enabled = true
	recipe.name = name
	recipe.ingredients = {{"electronic-circuit",3},{"advanced-circuit",1},{"steel-chest",1}}
	recipe.result = name

	local entity = table.deepcopy(data.raw["logistic-container"][entity])
	entity.name = name
	entity.animation.layers[1].filename = "__dumpchest__/image/"..name..".png"
	entity.animation.layers[1].hr_version.filename = "__dumpchest__/image/hr-"..name..".png"
	entity.minable.result = name

	data:extend{activeDumpChest, recipe, entity}
end

