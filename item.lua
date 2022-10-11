--item.lua

local activeDumpChest = table.deepcopy(data.raw["item"]["logistic-chest-active-provider"])

activeDumpChest.place_result = "active-provider-dumpchest"
activeDumpChest.name = "active-provider-dumpchest"
activeDumpChest.icons = {
	{
	icon = activeDumpChest.icon,
	tint = {r=1,g=0,b=0,a=0.3}
	},
}

local recipe = table.deepcopy(data.raw["recipe"]["logistic-chest-active-provider"])
recipe.enabled = true
recipe.name = "active-provider-dumpchest"
recipe.ingredients = {{"electronic-circuit",3},{"advanced-circuit",1},{"steel-chest",1}}
recipe.result = "active-provider-dumpchest"

local entity = table.deepcopy(data.raw["logistic-container"]["logistic-chest-active-provider"])
entity.name = "active-provider-dumpchest"
entity.animation.layers[1].tint = {r=1,g=0,b=0,a=0.3}
entity.animation.layers[1].hr_version.tint = {r=1,g=0,b=0,a=0.3}
entity.minable.result = "active-provider-dumpchest"
--entity.animation.layers[1].filename = "image/"

data:extend{activeDumpChest, recipe, entity}