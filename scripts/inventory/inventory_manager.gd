class_name InventoryManager

var player_inventory:Dictionary = {}

signal item_recieved(id:int, amount:int)
signal item_taken(id:int, amount:int)
signal inventory_change(inventory:Dictionary)

func add_item(id:int, amount:int):
	print(str(id)+" of "+str(amount))
	if(player_inventory.has(id)):
		player_inventory[id] = player_inventory[id]+amount
	else:
		player_inventory[id] = amount
	item_recieved.emit(id, amount)
	inventory_change.emit(player_inventory)

func remove_item(id:int, amount:int)->bool:
	if(player_inventory.has(id)):
		if(player_inventory[id]>=amount):
			player_inventory[id] = player_inventory[id]-amount
			if(player_inventory[id]==0):
				player_inventory.erase(id)
				item_taken.emit(id, amount)
				inventory_change.emit(player_inventory)
			return true
	return false

func get_items()->Dictionary:
	return player_inventory
	
func has_item(id:int)->bool:
	return player_inventory.has(id)

func count_item(id:int)->int:
	if(player_inventory.has(id)):
		return player_inventory[id]
	else:
		return 0
