extends Control

@onready var game_manager :GameManager = %GameManager
@onready var player_items_container = $PlayerItems/PlayerItemsContainer
@onready var brazier_items_container = $BrazierItems/BrazierItemsContainer
@onready var brazier_light_button = $LightBrazierButton
@onready var start_fight_button = $StartFightButton
@onready var brazier_label = $BrazierLabel
@onready var brazier_items_parent = $BrazierItems
@onready var player_items_parent = $PlayerItems
@onready var combat_ui = get_node("/root/MainGameScene/GameManager/CombatScreen/CombatUI")
var encounter_began = true
var player_brazier_locked_in = false
var enemy_brazier_locked_in = false

var player_inventory_icons:Array[Node] = []
var brazier_inventory_icons:Array[Node] = []

func get_player_items() -> Dictionary:
	return game_manager.inventory_manager.get_items()

func get_player_brazier_items() -> Dictionary:
	return game_manager.current_braziers[Enums.BrazierType.PLAYER]

func get_enemy_brazier_items() -> Dictionary:
	return game_manager.current_braziers[Enums.BrazierType.ENEMY]

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_music(load(SoundDb.BGM_BATTLE))
	game_manager.encounter_begin.connect(encouter_began)
	game_manager.fight_started.connect(hide)
	create_timer_for_setup()
	game_manager.item_added_to_brazier.connect(brazier_sync)
	brazier_light_button.connect("pressed",light_brazier)
	start_fight_button.connect("pressed",start_fight)
	brazier_light_button.disabled=true
	
func brazier_sync(item_id:int, item_amount:int, type:Enums.BrazierType)->void:
	clear_brazier_icons()

	var brazier_item_scene = preload("res://scenes/ui_components/brazier_item.tscn")

	var brazier_items = game_manager.current_braziers[type]

	for brazier_item in brazier_items:
		var brazier_item_instance = brazier_item_scene.instantiate()

		brazier_item_instance.item_id = brazier_item.item_id
		brazier_item_instance.quantity = brazier_item.item_count

		var item = game_manager.item_provider.get_item(brazier_item.item_id)

		brazier_item_instance.initialize_item(item)

		brazier_items_container.add_child(brazier_item_instance)

		brazier_inventory_icons.append(brazier_item_instance)

				
			
func clear_brazier_icons():
	for i in brazier_inventory_icons:
		i.queue_free()
	brazier_inventory_icons = []
	
func clear_player_icons():
	for i in player_inventory_icons:
		i.queue_free()
	player_inventory_icons = []

func refresh_player_items():
	# Load the brazier item scene
	clear_player_icons()
	var brazier_item_scene = preload("res://scenes/ui_components/brazier_player_item.tscn")
	var player_items = get_player_items()
	for item_id in player_items.keys():
		var brazier_item_instance = brazier_item_scene.instantiate()
		brazier_item_instance.item_id = item_id
		brazier_item_instance.quantity = player_items[item_id]
		var item = game_manager.item_provider.get_item(item_id)
		brazier_item_instance.initialize_item(item)
		brazier_item_instance.item_clicked.connect(player_item_clicked)
		player_items_container.add_child(brazier_item_instance)
		player_inventory_icons.append(brazier_item_instance)

func encouter_began():
	encounter_began = true
	refresh_player_items()
	
func player_item_clicked(item_id:int)->void:
	var item = RecipieItemResource.new()
	item.item_id = item_id
	item.item_count = 1
	if(player_brazier_locked_in==false):
		game_manager.add_item_to_brazier(item, Enums.BrazierType.PLAYER)
		refresh_player_items()
	else:
		game_manager.add_item_to_brazier(item, Enums.BrazierType.ENEMY)
		refresh_player_items()
	brazier_light_button.disabled=false
	
func light_brazier()->void:
	if(player_brazier_locked_in==false):
		if(game_manager.light_brazier(Enums.BrazierType.PLAYER)):
			player_brazier_locked_in=true
			brazier_label.text = "Enemy Brazier"
			clear_brazier_icons()
			brazier_light_button.disabled=true
	else:
		if(game_manager.light_brazier(Enums.BrazierType.ENEMY)):
			enemy_brazier_locked_in=true
			brazier_label.text = "Locked In"
			brazier_items_parent.hide()
			player_items_parent.hide()
			brazier_light_button.hide()
			start_fight_button.show()
			

func start_fight()->void:
	combat_ui.show()
	encounter_began = true
	player_brazier_locked_in = false
	enemy_brazier_locked_in = false
	brazier_items_parent.show()
	player_items_parent.show()
	brazier_light_button.show()
	start_fight_button.hide()
	game_manager.start_fight()
	clear_brazier_icons()
	clear_player_icons()
	brazier_light_button.disabled=true
	brazier_label.text = "Player Brazier"
	create_timer_for_setup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func create_timer_for_setup():
	# Create a Timer node
	var timer = Timer.new()
	# Set the wait time to 30 seconds
	timer.wait_time = 3
	timer.one_shot=true
	# Connect the timeout signal to a method that executes your code
	timer.connect("timeout",refresh_player_items)
	
	# Add the Timer node to the scene
	add_child(timer)
	# Start the timer
	timer.start()
	
	
