extends Node

# Dictionary to store loaded items with their item_id as the key
var items = {}


func _ready():
	# Load items from the "items" directory and populate the ITEMS dictionary
	for i in DirAccess.get_files_at("res://resources/items"):
		if i.ends_with(".tres"):
			var item = load("res://resources/items/" + i)
			items[item.id] = item


# Function to retrieve an item based on its item_id
func get_item(id: int) -> ItemResource:
	# Check if the item_id exists in the ITEMS dictionary
	if items.has(id):
		print("Item DB found an item matching the ID.")
		return items[id]

	print("Item DB could not find an item matching the ID.")
	return null
