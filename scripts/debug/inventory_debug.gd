extends Node
var inventory_manager:InventoryManager
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory_manager = InventoryManager.new()
	print(str(inventory_manager.get_items()))
	print("Adding 1 of Item 1")
	inventory_manager.add_item(1,1)
	print(str(inventory_manager.get_items()))
	print("Adding 5 of Item 2")
	inventory_manager.add_item(2,5)
	print(str(inventory_manager.get_items()))
	print("Removing 3 of Item 1")
	if(inventory_manager.remove_item(1,3)):
		print("Succeed")
	else:
		print("Failed")
	print(str(inventory_manager.get_items()))
	print("Removing 5 of Item 2")
	
	if(inventory_manager.remove_item(2,5)):
		print("Succeed")
	else:
		print("Failed")
		
	print(str(inventory_manager.get_items()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
