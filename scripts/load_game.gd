extends Node2D

# Load Libraries
var util: Object
const util_script = preload("res://scripts/util.gd")

# Load Configuration File
var config = ConfigFile.new()
var err = config.load("user://settings.cfg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	util = util_script.new()
	
	# If there is an error, generate a new config file with default settings
	if err != OK:
		config.set_value("Display", "Mode", 1)
		config.set_value("Display", "Resolution", 1)
		config.set_value("Audio", "Volume", 0.0)
		config.save("user://settings.cfg")
		return
	
	# Else retrieve saved configurations
	else:
		var displayMode = config.get_value("Display", "Mode")
		var resolution = config.get_value("Display", "Resolution")
		var volume = config.get_value("Audio", "Volume")
		
		# Apply the settings from the saved configuration file
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
		util.screen_size_change(resolution)
		util.mode_change(displayMode)
		get_window().move_to_center()
