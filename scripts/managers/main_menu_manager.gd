class_name MainMenuManager
extends Node

@onready var continue_button = %ContinueRun

func _on_continue_run_button_down():
	assert(false, "Not implemented")


func _on_start_new_run_button_down():
	get_tree().change_scene_to_file("res://scenes/main_game_scene.tscn")


func _on_settings_button_down():
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")


func _on_exit_button_down():
	get_tree().quit()


func _ready():
	AudioManager.play_music(
		load("res://thirdparty/audio/music/8-Bit_Character_Computer Guy (loop).wav")
	)
	
	continue_button.hide()
	
	#assert(false, "implement it so if there is a saved run then the continue button is unhidden.")
	
