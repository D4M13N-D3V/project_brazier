extends Node

# Dictionary to store loaded items with their item_id as the key
var actions = {}


func _ready():
	# Load items from the "items" directory and populate the ITEMS dictionary
	for i in DirAccess.get_files_at("res://resources/actions"):
		if i.ends_with(".tres"):
			var item = load("res://resources/actions/" + i)
			actions[item.id] = item


# Function to retrieve an item based on its item_id
func get_action(id: int) -> ActionResource:
	# Check if the item_id exists in the ITEMS dictionary
	if actions.has(id):
		return actions[id]
	return null
