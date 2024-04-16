class_name SettingsManager
extends Node

const CONFIG_FILENAME = "settings.conf"

signal sfx_volume_updated(new_value)
signal music_volume_updated(new_value)
signal master_volume_updated(new_value)

signal resolution_updated(new_value)
signal window_mode_updated(new_value)

enum AudioBusChannels {Master, Music, Sfx}

var sfx_volume = 1.0:
	set(value):
		if(sfx_volume != value):
			sfx_volume = value
			set_bus_volume(AudioBusChannels.Sfx, sfx_volume)

var music_volume = 1.0:
	set(value):
		if(music_volume != value):
			music_volume = value
			set_bus_volume(AudioBusChannels.Music, music_volume)

var master_volume = 1.0:
	set(value):
		if(master_volume != value):
			master_volume = value
			set_bus_volume(AudioBusChannels.Master, master_volume)

var current_resolution = Vector2(1920,1080):
	set(value):
		if (value == null):
			value = Vector2(1280,720)
		if (current_resolution != value):
			current_resolution = value
			set_window_size(current_resolution)
			

var current_window_mode = Window.MODE_WINDOWED:
	set(value):
		if (value == null):
			value = Window.MODE_WINDOWED
		if (current_window_mode != value):
			current_window_mode = value
			set_window_mode(current_window_mode)
			
func _ready():
	load_data()

func set_bus_volume(bus, value):
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus, volume_db)


func set_window_size(size):
	get_window().size = size
	if get_window().mode == Window.MODE_FULLSCREEN:
		set_borderless_mode()

func set_window_mode(mode):
	match mode:
		Window.MODE_FULLSCREEN:
			set_borderless_mode()
		Window.MODE_WINDOWED:
			set_windowed_mode()

func set_borderless_mode():
	get_window().mode = Window.MODE_FULLSCREEN

func set_windowed_mode():
	get_window().mode = Window.MODE_WINDOWED
	
func load_data():
	var options_file = ConfigFile.new()
	
	var status = options_file.load("user://%s" % CONFIG_FILENAME)
	
	if status == OK:
		sfx_volume = options_file.get_value("Options", "sfx_volume")
		music_volume = options_file.get_value("Options", "music_volume")
		master_volume = options_file.get_value("Options", "master_volume")
		
		current_resolution = options_file.get_value("Options", "current_resolution")
		current_window_mode = options_file.get_value("Options", "current_window_mode")
		
		
		sfx_volume_updated.emit()
		music_volume_updated.emit()
		master_volume_updated.emit()
		
		resolution_updated.emit()
		window_mode_updated.emit()

func saveData():
	var options_file = ConfigFile.new()
	
	options_file.set_value("Options", "sfx_volume", sfx_volume)
	options_file.set_value("Options", "music_volume", music_volume)
	options_file.set_value("Options", "master_volume", master_volume)
	
	options_file.set_value("Options", "current_resolution", current_resolution)
	options_file.set_value("Options", "current_window_mode", current_window_mode)
	
	options_file.save("user://%s" % CONFIG_FILENAME)
