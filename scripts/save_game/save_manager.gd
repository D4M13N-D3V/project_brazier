extends Node

const SAVE_GAME_PATH := "user://savegame.tres"
const SETTINGS_STORE_PATH := "user://settings.tres"


func write_save_game(save_game: SaveGameResource) -> void:
	ResourceSaver.save(save_game, SAVE_GAME_PATH)


func load_save_game() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null


func write_settings_store(settings_store: SettingsStoreResource) -> void:
	ResourceSaver.save(settings_store, SETTINGS_STORE_PATH)


func load_settings_store() -> Resource:
	if ResourceLoader.exists(SETTINGS_STORE_PATH):
		return load(SETTINGS_STORE_PATH)
	return null
