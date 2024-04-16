extends Node

var item_provider: ItemProvider


# Called when the node enters the scene tree for the first time.
func _ready():
	item_provider = ItemProvider.new()
	print(item_provider.get_item(1).name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
