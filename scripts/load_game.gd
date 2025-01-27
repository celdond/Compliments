extends Node2D
var config = ConfigFile.new()
var err = config.load("user://settings.cfg")
const util_script = preload("res://scripts/util.gd")
var util: Object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	util = util_script.new()
	if err != OK:
		config.set_value("Display", "Mode", 1)
		config.set_value("Display", "Resolution", 0)
		config.set_value("Audio", "Volume", 0.0)
		config.save("user://settings.cfg")
		return
	else:
		var displayMode = config.get_value("Display", "Mode")
		var resolution = config.get_value("Display", "Resolution")
		var volume = config.get_value("Audio", "Volume")
		print(resolution)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
		util.screen_size_change(resolution)
		util.mode_change(displayMode)
		get_window().move_to_center()
