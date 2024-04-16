extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create a Timer node
	var timer = Timer.new()
	# Set the wait time to 30 seconds
	timer.wait_time = 1
	timer.one_shot=true
	# Connect the timeout signal to a method that executes your code
	timer.connect("timeout",_on_timeout)
	# Add the Timer node to the scene
	add_child(timer)
	# Start the timer
	timer.start()

# Method to execute your code after waiting for 30 seconds
func _on_timeout():
	get_node("/root/MainGameScene/GameManager").add_item_to_brazier(1,1, Enums.BrazierType.PLAYER)
	get_node("/root/MainGameScene/GameManager").add_item_to_brazier(1,1, Enums.BrazierType.ENEMY)
	get_node("/root/MainGameScene/GameManager").light_brazier(Enums.BrazierType.PLAYER)
	get_node("/root/MainGameScene/GameManager").light_brazier(Enums.BrazierType.ENEMY)
	get_node("/root/MainGameScene/GameManager").start_fight()
	get_node("/root/MainGameScene/GameManager").execute_player_turn(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
