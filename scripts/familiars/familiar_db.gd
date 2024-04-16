extends Node

# Dictionary to store loaded items with their item_id as the key
var familiars = []


func _ready():
	# Load items from the "items" directory and populate the ITEMS dictionary
	for i in DirAccess.get_files_at("res://resources/familiars"):
		if i.ends_with(".tres"):
			var item = load("res://resources/familiars/" + i)
			familiars.append(item) 


# Function to retrieve an item based on its item_id
func get_familiar(id: Enums.Familiar) -> FamiliarResource:
	for f in familiars:
		if f.id ==id:
			return familiars[id]
	return null
