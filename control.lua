script.on_event(defines.events.on_player_changed_position,
	function(event)
		local player = game.get_player(event.player_index)
		-- player.character_personal_logistic_requests_enabled = false
		-- player.character_personal_logistic_requests_enabled = true
		do_the_job(player)
	end
)

function do_the_job(player)
	local px = player.position.x
	local py = player.position.y
	local trash_inventory = player.get_inventory(defines.inventory.character_trash)
	if trash_inventory == nil then return end

	local chests_entities = player.surface.find_entities_filtered({
		area = {{-10 + px, -10 + py}, {10 + px, 10 + py}},
		name = "active-provider-dumpchest"
	})

	local table_insert = table.insert
	local table_remove = table.remove

	local trash_to_clean = {}
	for j = #trash_inventory, 1, -1 do
		local trash_slot = trash_inventory[j]
		if trash_slot.count > 0 then
			table_insert(trash_to_clean, trash_slot)
		end
	end

	for i = 1, #chests_entities do
		local chest_inventory = chests_entities[i].get_inventory(defines.inventory.item_main)
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