class_name GameManager
extends Node

@export var starting_items:Array[RecipieItemResource]
@export var current_level = 1
@export var current_section : int = 0
@export var current_encounter :int = 0
var inventory_manager:InventoryManager
var familiar_provider:FamiliarProvider
var item_provider:ItemProvider
var action_provider:ActionProvider

var enemy_timer:SceneTreeTimer
@export var fight_is_started:bool = false
@export var fight_is_complete:bool = false
@export var loot_is_collected:bool = false
@export var player_turn:bool = true
@export var encounter_started:bool = false
var player_health:HealthComponent = null
var enemy_health:HealthComponent = null


var current_braziers:Dictionary = {
	Enums.BrazierType.PLAYER:null,
	Enums.BrazierType.ENEMY:null,
}
var braziers_lit:Dictionary = {
	Enums.BrazierType.PLAYER:false,
	Enums.BrazierType.ENEMY:false,
}
var brazier_familiars:Dictionary = {
	Enums.BrazierType.PLAYER:null,
	Enums.BrazierType.ENEMY:null,
}

signal encounter_begin
signal encounter_end
signal fight_started
signal fight_ended
signal player_turn_started
signal player_action_executed(action_id:int)
signal enemy_action_executed(action_id:int)
signal item_added_to_brazier(item_id:int, item_amount:int, type:Enums.BrazierType)
signal brazier_lit(type:Enums.BrazierType,familiar:FamiliarResource)

signal encounter_change(encounter:int, section:int)
signal section_change(section:int)

func _ready():
	item_provider = ItemProvider.new()
	inventory_manager = InventoryManager.new()
	familiar_provider = FamiliarProvider.new()
	action_provider = ActionProvider.new()
	current_section = 1
	current_encounter = 1
	for i in starting_items:
		inventory_manager.add_item(i.item_id, i.item_count)
	start_encounter()
	

	
func game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func next_encounter() -> void:
	current_level = current_level+1
	current_encounter = current_encounter+1
	if(current_encounter>10):
		current_encounter = 0
		next_section()
	encounter_change.emit(current_encounter)

func next_section() -> void:
	current_section = current_section + 1
	section_change.emit(current_encounter)

func start_encounter() -> void:
	if(encounter_started):
		print("Encounter is already started.")
		return
	encounter_started = true
	encounter_begin.emit()
	
#func add_item_to_brazier(item_id:int, item_amount:int, brazier:Enums.BrazierType)->bool:
	#if(encounter_started==false):
		#return false
	#var hasItem = inventory_manager.has_item(item_id)
	#var itemCount = inventory_manager.has_item(item_id)
	#if(inventory_manager.has_item(item_id) && inventory_manager.has_item(item_id)):
		#if(inventory_manager.remove_item(item_id,item_amount)):
			#if(current_braziers[brazier].has(item_id)):
				#current_braziers[brazier][item_id] = current_braziers[brazier][item_id] + item_amount
			#else:
				#current_braziers[brazier][item_id] = item_amount
			#item_added_to_brazier.emit(item_id, item_amount, brazier)
			#return true
	#return false
	
func add_item_to_brazier(item: RecipieItemResource, brazier:Enums.BrazierType)->bool:
	if(encounter_started==false):
		return false
		
	if  current_braziers[brazier] == null:
		current_braziers[brazier] = []
	
	
	var hasItem = inventory_manager.has_item(item.item_id)
	var itemCount = inventory_manager.count_item(item.item_id)
	if(hasItem && itemCount >= item.item_count):
		if(inventory_manager.remove_item(item.item_id, item.item_count)):
			var found = false
			for i in current_braziers[brazier]:
				if i.item_id == item.item_id:
					i.item_count += item.item_count
					found = true
					break
			if not found:
				current_braziers[brazier].append(item)
			item_added_to_brazier.emit(item.item_id, item.item_count, brazier)
			return true
	return false

func light_brazier(brazier:Enums.BrazierType)->bool:
	if(encounter_started==false && braziers_lit[brazier]==true):
		return false
	if(brazier==Enums.BrazierType.ENEMY):
		if(braziers_lit[Enums.BrazierType.PLAYER]==false):
			return false
	var familiar = familiar_provider.get_familiar(current_braziers[brazier])
	
	# this code makes it so u cant summon this your not high enough level for, disabled for fun
	#if(familiar.level_required<current_level && brazier == Enums.BrazierType.PLAYER):
	#	current_braziers[brazier] = {}
	#	return false
	
	brazier_lit.emit(brazier)
	braziers_lit[brazier] = true
	brazier_familiars[brazier] = familiar
	return true

func end_encounter() -> void:
	if(loot_is_collected==true):
		encounter_end.emit()
		fight_is_started = false
		fight_is_complete = false
		loot_is_collected = false
		player_health = null
		enemy_health = null
		player_turn = true
		encounter_started = false
		current_braziers = {
			Enums.BrazierType.PLAYER:null,
			Enums.BrazierType.ENEMY:null,
		}
		braziers_lit = {
			Enums.BrazierType.PLAYER:false,
			Enums.BrazierType.ENEMY:false,
		}
		brazier_familiars = {
			Enums.BrazierType.PLAYER:null,
			Enums.BrazierType.ENEMY:null,
		}
		next_encounter()

func start_fight() -> void:
	if(braziers_lit[Enums.BrazierType.ENEMY]==true && braziers_lit[Enums.BrazierType.PLAYER]==true):
		if(brazier_familiars[Enums.BrazierType.ENEMY]==null || brazier_familiars[Enums.BrazierType.PLAYER]==null):
			game_over()	
			return
		player_turn = true
		player_health = HealthComponent.new()
		enemy_health = HealthComponent.new()
		player_health.died.connect(game_over)
		enemy_health.died.connect(stop_fight)
		fight_is_started = true
		fight_started.emit()
	
func stop_fight() -> void:
	if(fight_is_started):
		fight_is_complete=true
		fight_ended.emit()
		loot()
		end_encounter()
		start_encounter()

func loot() -> void:
	if(fight_is_complete):
		var loot_table = brazier_familiars[Enums.BrazierType.ENEMY].id
		var loot = item_provider.generate_loot(loot_table)
		for i in loot:
			inventory_manager.add_item(i.item_id, i.item_count)
		loot_is_collected=true


func execute_player_turn(action_id:int)->bool:
	if(player_turn==true && fight_is_started && fight_is_complete==false):
		var familiar = brazier_familiars[Enums.BrazierType.PLAYER]
		if(familiar.available_actions.has(action_id)):
			player_action_executed.emit(action_id)
			var action = action_provider.get_action(action_id)
			if(action.type==Enums.ActionType.DAMAGE):
				enemy_health.damage(action.damage)
			else:
				player_health.heal(action.damage)
			enemy_timer = get_tree().create_timer(2)  
			enemy_timer.timeout.connect(execute_enemy_turn)
			player_turn=false  
			return true
	return false

func execute_enemy_turn()->void:
	var familiar = brazier_familiars[Enums.BrazierType.ENEMY]
	if(fight_is_complete==true || familiar==null):
		return
	enemy_timer.timeout.disconnect(execute_enemy_turn)
	var actions = familiar.available_actions
	var random_action = pick_random_enemy_action(actions)
	var action = action_provider.get_action(random_action)
	if(action.type==Enums.ActionType.DAMAGE):
		player_health.damage(action.damage)
	else:
		enemy_health.heal(action.damage)
	enemy_action_executed.emit(action.id)
	player_turn = true
	player_turn_started.emit()

func get_player_familiar() -> FamiliarResource:
	var fam = brazier_familiars[Enums.BrazierType.PLAYER]
	return fam;
	
func get_enemy_familiar() -> FamiliarResource:
	var fam = brazier_familiars[Enums.BrazierType.ENEMY]
	return fam;

func pick_random_enemy_action(arr: Array):
	if arr.size() == 0:
		return null # or handle empty array however you prefer
	var random_index = randi() % arr.size()
	return arr[random_index]

func get_player_actions() -> Array[ActionResource]:
	var action_ids:Array[int] = brazier_familiars[Enums.BrazierType.PLAYER].available_actions
	var result:Array[ActionResource]
	for i in action_ids:
		result.append(action_provider.get_action(i))
	return result
	
func get_enemy_actions() -> Array[ActionResource]:
	var action_ids:Array[int] = brazier_familiars[Enums.BrazierType.ENEMY].available_actions
	var result:Array[ActionResource]
	for i in action_ids:
		result.append(action_provider.get_action(i))
	return result
