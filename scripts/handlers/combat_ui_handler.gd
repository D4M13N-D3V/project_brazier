extends Control

@onready var game_manager :GameManager = %GameManager
@onready var action_button_grid = %ActionGridContainer
@onready var action_tooltip_lbl = %ActionToolTipLbl
@onready var action_tooltip_panel = %ActionDescriptionPanel
@onready var player_familiar_combat_display = %PlayerFamiliarCombatDisplay
@onready var enemy_familiar_combat_display = %EnemyFamiliarCombatDisplay

@onready var player_hp_bar = %PlayerHealthBar
@onready var enemy_hp_bar = %EnemyHealthBar
@onready var brazier_ui = get_node("/root/MainGameScene/GameManager/CombatScreen/BrazierUI")


var action_button_resource = preload("res://scenes/ui_components/action_button.tscn")
var action_buttons : Array[Node] = [] 



# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_music(load(SoundDb.BGM_BATTLE))
	game_manager.fight_started.connect(fight_started)
	game_manager.fight_ended.connect(fight_ended)
	game_manager.player_turn_started.connect(show_action_buttons)
	hide()
	
func fight_ended():
	brazier_ui.show()
	hide()
	
func fight_started():
	set_up_player_familiar_display()
	set_up_enemy_familiar_display()
	set_up_player_hp_bar()
	set_up_enemy_hp_bar()
	set_up_action_buttons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_manager_encounter_begin():
	pass
	
	
func set_description_tooltip(description:String):
	action_tooltip_panel.show()
	action_tooltip_lbl.text = description

func hide_description_tooltip():
	action_tooltip_panel.hide()

func set_up_action_buttons():
	var player_actions = game_manager.get_player_actions()
	for a in player_actions:
		var abutton = action_button_resource.instantiate()
		abutton.set_up_action(a)
		abutton.action_description.connect(set_description_tooltip)
		abutton.mouse_exited.connect(hide_description_tooltip)
		abutton.action_pressed.connect(action_pressed)
		action_button_grid.add_child(abutton)
		action_buttons.append(abutton)
		
func set_up_player_familiar_display():
	var fam = game_manager.get_player_familiar()
	player_familiar_combat_display.set_familiar_sprite(fam.sprite_resource)

func set_up_enemy_familiar_display():
	var fam = game_manager.get_enemy_familiar()
	enemy_familiar_combat_display.set_familiar_sprite(fam.sprite_resource)

func action_pressed(action):
	hide_action_buttons()
	game_manager.execute_player_turn(action.id)

func show_action_buttons():
	for a in action_buttons:
		a.show()

func hide_action_buttons():
	for a in action_buttons:
		a.hide()

func set_up_player_hp_bar():
	var hp_comp = game_manager.player_health
	player_hp_bar.max_value = hp_comp.max_health
	player_hp_bar.value = hp_comp.current_health
	hp_comp.changed.connect(player_hp_changed)

func player_hp_changed(current_hp):
	player_hp_bar.value = current_hp
	
func set_up_enemy_hp_bar():
	var hp_comp = game_manager.enemy_health
	enemy_hp_bar.max_value = hp_comp.max_health
	enemy_hp_bar.value = hp_comp.current_health
	hp_comp.changed.connect(enemy_hp_changed)

func enemy_hp_changed(current_hp):
	enemy_hp_bar.value = current_hp
