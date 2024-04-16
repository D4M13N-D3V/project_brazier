extends Control

signal resolution_changed(resolution: Vector2)

@onready var sfx_slider = %SoundEffectVolumeSlider
@onready var master_slider = %MasterVolumeSlider
@onready var music_slider = %MusicVolumeSlider

func _ready():
	sfx_slider.value = GameSettingsManager.sfx_volume
	music_slider.value = GameSettingsManager.music_volume
	master_slider.value = GameSettingsManager.master_volume
	
	GameSettingsManager.load_data()

func _on_4k_button_down():
	var res = Vector2(3840, 2160)
	GameSettingsManager.current_resolution = res


func _on_1440_button_down():
	var res = Vector2(2560, 1440)
	GameSettingsManager.current_resolution = res


func _on_1080p_button_down():
	var res = Vector2(1920, 1080)
	GameSettingsManager.current_resolution = res


func _on_768p_button_down():
	var res = Vector2(1366, 768)
	GameSettingsManager.current_resolution = res


func _on_720p_button_down():
	var res = Vector2(1280, 720)
	GameSettingsManager.current_resolution = res


func _on_back_to_main_menu_button_down():
	GameSettingsManager.saveData()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_windowed_button_down():
	GameSettingsManager.current_window_mode = Window.MODE_WINDOWED


func _on_borderless_button_down():
	GameSettingsManager.current_window_mode = Window.MODE_FULLSCREEN



func _on_sound_effect_volume_slider_value_changed(value):
	GameSettingsManager.sfx_volume = value


func _on_music_volume_slider_value_changed(value):
	GameSettingsManager.music_volume = value


func _on_master_volume_slider_value_changed(value):
	GameSettingsManager.master_volume = value


func _on_test_sfx_button_button_down():
	AudioManager.play_sound_effect(load(SoundDb.SFX_BUTTON_PRESS))
