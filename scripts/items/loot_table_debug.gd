extends Node

var item_provider: ItemProvider


# Called when the node enters the scene tree for the first time.
func _ready():
	item_provider = ItemProvider.new()
	var loot = item_provider.generate_loot(1)
	for i in loot:
		var item = item_provider.get_item(i)
		print(item.Name + " - " + str(loot[i]))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
