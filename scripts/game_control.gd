extends Node2D
var compliment: Label
var slide: AnimationPlayer
var slideButton: TextureButton
var slideState: bool
var database: Object
var util: Object
var count: int
var random: RandomNumberGenerator
var popup: TextureRect
var configPopup: TextureRect
var fade: ColorRect
const database_script = preload("res://scripts/database_access.gd")
const util_script = preload("res://scripts/util.gd")
var config = ConfigFile.new()
var err = config.load("user://settings.cfg")

# Settings
var volume: float
var settingsChanged: bool
var windowMode: int
var newMode: int
var resolution: int
var newRes: int

# Called when the node enters the scene tree for the first time.
func _ready():
	random = RandomNumberGenerator.new()
	database = database_script.new()
	util = util_script.new()
	count = database.get_compliment_count()
	compliment = get_node("./Control/Margin/CanvasLayer/Background/Textbox/Compliment")
	slide = get_node("./Control/Margin/CanvasLayer/Slide/AnimationPlayer")
	slideButton = get_node("./Control/Margin/CanvasLayer/Slide/SlideButton")
	slideState = false
	popup = get_node("./Control/Margin/CanvasLayer/ExitPopup")
	configPopup = get_node("./Control/Margin/CanvasLayer/ConfigPopup")
	fade = get_node("./Control/Margin/CanvasLayer/FadeLayer")
	compliment.text = "Press the button to receive a compliment."

	# default volume
	volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	windowMode = config.get_value("Display", "Mode")
	newMode = windowMode
	resolution = config.get_value("Display", "Resolution")
	newRes = resolution
	settingsChanged = false
	
	$Control/Margin/CanvasLayer/ConfigPopup/volumeSlider.set_value_no_signal(volume)
	$Control/Margin/CanvasLayer/ConfigPopup/resolution.selected =  windowMode
	$Control/Margin/CanvasLayer/ConfigPopup/screen_size.selected = resolution
	print(resolution)
	
func _on_please():
	var selection: int = random.randi_range(1, count)
	var c: String = database.get_compliment(selection)
	compliment.text = c

func on_ask_exit() -> void:
	$UIButtons.play()
	fade.visible = true
	popup.visible = true

func cancel_exit() -> void:
	$UIButtons.play()
	popup.visible = false
	fade.visible = false

func on_exit() -> void:
	get_tree().quit()

func nav_configuration() -> void:
	$UIButtons.play()
	fade.visible = true
	configPopup.visible = true

func on_slide_pressed() -> void:
	if slideState == false:
		slide.play("slide")
		slideButton.flip_h = false
		slideState = true
	else:
		slide.play_backwards("slide")
		slideButton.flip_h = true
		slideState = false

func exit_config() -> void:
	settingsChanged = false
	$UIButtons.play()
	configPopup.visible = false
	fade.visible = false
	$Control/Margin/CanvasLayer/ConfigPopup/apply.visible = false
	return

func cancel_config() -> void:
	if newMode != windowMode:
		_on_resolution_item_selected(windowMode)
		$Control/Margin/CanvasLayer/ConfigPopup/resolution.selected =  windowMode
	if newRes != resolution:
		_on_screen_size_item_selected(resolution)
		$Control/Margin/CanvasLayer/ConfigPopup/screen_size.selected = resolution
	exit_config()
	return

func apply_config() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	config.set_value("Audio", "Volume", volume)
	if newMode != windowMode:
		windowMode = newMode
		config.set_value("Display", "Mode", newMode)
	
	if newRes != resolution:
		config.set_value("Display", "Resolution", newRes)
		resolution = newRes
	if settingsChanged:
		config.save("user://settings.cfg")
	exit_config()
	return

# Setting Functions
func _volume_changed(value: float) -> void:
	if value:
		volume = $Control/Margin/CanvasLayer/ConfigPopup/volumeSlider.value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("TestBus"), volume)
		if !settingsChanged:
			settingsChanged = true
			$Control/Margin/CanvasLayer/ConfigPopup/apply.visible = true
	$Control/Margin/CanvasLayer/ConfigPopup/TestSound.play()

func _on_resolution_item_selected(index: int) -> void:
	util.mode_change(index)
	_on_screen_size_item_selected(newRes)
	get_window().move_to_center()
	if !settingsChanged:
			settingsChanged = true
			$Control/Margin/CanvasLayer/ConfigPopup/apply.visible = true
	newMode = index

func _on_screen_size_item_selected(index: int) -> void:
	util.screen_size_change(index)
	get_window().move_to_center()
	if !settingsChanged:
			settingsChanged = true
			$Control/Margin/CanvasLayer/ConfigPopup/apply.visible = true
	newRes = index
