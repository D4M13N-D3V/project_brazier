extends Node

var action_provider: ActionProvider


# Called when the node enters the scene tree for the first time.
func _ready():
	action_provider = ActionProvider.new()
	var action = action_provider.get_action(1)
	print(action.name + " (" + str(action.damage) + ") " + action.description)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
