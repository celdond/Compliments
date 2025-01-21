extends Node2D
var compliment: Label
var slide: AnimationPlayer
var slideButton: TextureButton
var slideState: bool
var database: Object
var count: int
var random: RandomNumberGenerator
var popup: TextureRect
var config: TextureRect
var fade: ColorRect
const database_script = preload("res://data/database_access.gd")
const resolutions: Dictionary = {
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080),
	"1152 x 648": Vector2i(1152, 648)
}

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
	count = database.get_compliment_count()
	compliment = get_node("./Control/Margin/CanvasLayer/Background/Textbox/Compliment")
	slide = get_node("./Control/Margin/CanvasLayer/Slide/AnimationPlayer")
	slideButton = get_node("./Control/Margin/CanvasLayer/Slide/SlideButton")
	slideState = false
	popup = get_node("./Control/Margin/CanvasLayer/ExitPopup")
	config = get_node("./Control/Margin/CanvasLayer/ConfigPopup")
	fade = get_node("./Control/Margin/CanvasLayer/FadeLayer")
	compliment.text = "Press the button to receive a compliment."
	
	# default volume
	volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	windowMode = 0
	newMode = windowMode
	resolution = 0
	newRes = resolution
	settingsChanged = false
	
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
	config.visible = true

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
	config.visible = false
	fade.visible = false
	$Control/Margin/CanvasLayer/ConfigPopup/apply.disabled = true

func cancel_config() -> void:
	if newMode != windowMode:
		_on_resolution_item_selected(windowMode)
	if newRes != resolution:
		_on_screen_size_item_selected(resolution)
	exit_config()

func apply_config() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	windowMode = newMode
	resolution = newRes
	exit_config()

# Setting Functions
func _volume_changed(value: float) -> void:
	if value:
		volume = $Control/Margin/CanvasLayer/ConfigPopup/volumeSlider.value
		print(volume)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("TestBus"), volume)
		if !settingsChanged:
			settingsChanged = true
			$Control/Margin/CanvasLayer/ConfigPopup/apply.disabled = false
	$Control/Margin/CanvasLayer/ConfigPopup/TestSound.play()


func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	if !settingsChanged:
			settingsChanged = true
			$Control/Margin/CanvasLayer/ConfigPopup/apply.disabled = false
	newMode = index


func _on_screen_size_item_selected(index: int) -> void:
	DisplayServer.window_set_size(resolutions.values()[index])
	get_window().move_to_center()
	if !settingsChanged:
			settingsChanged = true
			$Control/Margin/CanvasLayer/ConfigPopup/apply.disabled = false
	newRes = index
