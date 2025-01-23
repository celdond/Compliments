extends Node2D
var config = ConfigFile.new()
var err = config.load("user://settings.cfg")
const util = preload("res://scripts/util.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if err != OK:
		config.set_value("Display", "Mode", 1)
		config.set_value("Display", "Resolution", "1280 x 720")
		config.save("user://settings.cfg")
		return
	else:
		var displayMode = config.get_value("Display", "Mode")
		var resolution = config.get_value("Display", "Resolution")
		pass
