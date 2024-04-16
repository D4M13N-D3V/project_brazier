extends Node

var music_player: AudioStreamPlayer


func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.bus = "music"
	add_child(music_player)


func play_sound_effect(stream: AudioStream):
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.bus = "sfx"
	instance.finished.connect(remove_audio_stream_player)
	add_child(instance)
	instance.play()


func remove_audio_stream_player(instance: AudioStreamPlayer):
	instance.queue_free()


func play_music(stream: AudioStream):
	if music_player.stream == stream:
		return;
	
	if music_player.playing:
		music_player.stop()
	music_player.stream = stream
	music_player.play()
