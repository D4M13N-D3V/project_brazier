class_name ItemProvider

func get_item(item_id: int) -> ItemResource:
	return ItemDb.get_item(item_id)

func generate_loot(familiar: Enums.Familiar) -> Array:
	var result: Array = []
	var loot_table = LootTableDb.get_loot_table(familiar)
	for item in loot_table.items:
		if is_success(item.item_chance) == true:
			var found = false
			for r in result:
				if r.item_id == item.item_id:
					r.item_count += item.item_count
					found = true
					break
			if not found:
				result.append(item)
	return result

func is_success(percentage: float) -> bool:
	var random_number = randf_range(0.0, 1.0)
	return random_number <= percentage / 100.0
