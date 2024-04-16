extends Node

# Array to store loaded items
var loot_tables = []

func _ready():
	# Load items from the "loot_tables" directory and populate the loot_tables array
	for i in DirAccess.get_files_at("res://resources/loot_tables"):
		if i.ends_with(".tres"):
			var item = load("res://resources/loot_tables/" + i)
			loot_tables.append(item)

# Function to retrieve an item based on its id
func get_loot_table(id: Enums.Familiar) -> LootTableResource:
	# Check if the item_id exists in the loot_tables array
	for item in loot_tables:
		if item.id == id:
			print("Loot table DB found loot table matching ID.")
			return item

	print("Loot table DB could not find loot table matching ID.")
	return null
