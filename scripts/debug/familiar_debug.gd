extends Node

var familiar_provider: FamiliarProvider


# Called when the node enters the scene tree for the first time.
func _ready():
	familiar_provider = FamiliarProvider.new()
	print(familiar_provider.get_familiar({}).name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
