script.on_init(
	function ()
		game.forces.player.reset_technology_effects()
	end
)

local whitelist = {
	["dump-logistic-chest-active-provider"] = true,
	["dump-logistic-chest-storage"] = true,
}

local function dumpInChests(player)
	local px = player.position.x
	local py = player.position.y
	local trash_inventory = player.get_inventory(defines.inventory.character_trash)
	if trash_inventory == nil then return end
	if #trash_inventory == 0 then return end
	
	local chests_entities = player.surface.find_entities_filtered{
		area = {{-10 + px, -10 + py}, {10 + px, 10 + py}},
		type = "logistic-container"
	}

	for k, entity in pairs(chests_entities) do
		if not whitelist[entity.name] then chests_entities[k] = nil end
	end

	if #chests_entities == 0 then return end

	local table_insert = table.insert
	local table_remove = table.remove

	local trash_to_clean = {}
	for j = #trash_inventory, 1, -1 do
		local trash_slot = trash_inventory[j]
		if trash_slot.count > 0 then
			table_insert(trash_to_clean, trash_slot)
		end
	end

	for _, entity in pairs (chests_entities) do
		local chest_inventory = entity.get_inventory(defines.inventory.item_main)
		for j = #trash_to_clean, 1, -1 do
			local trash_candidate = trash_to_clean[j]
			if chest_inventory.can_insert(trash_candidate) then
				local prev_count = trash_candidate.count
				local inserted_count = chest_inventory.insert(trash_candidate)
				if prev_count == inserted_count then
					trash_candidate.clear()
					table_remove(trash_to_clean, j)
				else
					trash_candidate.count = trash_candidate.count - inserted_count
				end
			end
		end
	end
end

script.on_event(defines.events.on_player_changed_position,
	function(event)
		local player = game.get_player(event.player_index)
		if not player.character then return end
		if not player.character_personal_logistic_requests_enabled then return end
		dumpInChests(player)
	end
)