class_name FamiliarProvider


#func get_familiar(ingredients: Array[RecipieItemResource]) -> FamiliarResource:

#	for f in FamiliarDb.familiars:
#		for i in ingredients:
#			if !f.ingredients.has(i):
#				return null
#		return FamiliarDb.get_familiar(f.id)

#	return null

func get_familiar(ingredients: Array) -> FamiliarResource:
	for f in FamiliarDb.familiars:
		var is_match = true
		for i in ingredients:
			var found = false
			for r in f.required_items:
				if r.item_id == i.item_id and r.item_count == i.item_count:
					found = true
					break
			if not found:
				is_match = false
				break
		if is_match:
			return FamiliarDb.get_familiar(f.id)
	return null




func sort_dictionary_by_keys(dict:Dictionary)->Dictionary:
	var sorted_keys = dict.keys()
	sorted_keys.sort()
	var sorted_dict = {}
	for key in sorted_keys:
		sorted_dict[key] = dict[key]
	return sorted_dict


func get_familiar_by_ID(id: Enums.Familiar) -> FamiliarResource:
	return FamiliarDb.get_familiar(id)
