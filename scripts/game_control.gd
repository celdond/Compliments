extends Node2D

# Compliment Handling Variables
var compliment: Label
var count: int
var random: RandomNumberGenerator

# Component Handling Variables
var slide: AnimationPlayer
var slideButton: TextureButton
var slideState: bool
var popup: TextureRect
var configPopup: TextureRect
var fade: ColorRect

# Load Library Scripts
const database_script = preload("res://scripts/database_access.gd")
const util_script = preload("res://scripts/util.gd")
var database: Object
var util: Object

# Load Configuration
var config = ConfigFile.new()
var err = config.load("user://settings.cfg")

# Settings Variables
var volume: float
var settingsChanged: bool
var windowMode: int
var newMode: int
var resolution: int
var newRes: int

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Create Instances for later calls
	random = RandomNumberGenerator.new()
	database = database_script.new()
	util = util_script.new()
	
	# Get all related assets for manipulation
	compliment = get_node("./Control/Margin/CanvasLayer/Background/Textbox/Compliment")
	slide = get_node("./Control/Margin/CanvasLayer/Slide/AnimationPlayer")
	slideButton = get_node("./Control/Margin/CanvasLayer/Slide/SlideButton")
	popup = get_node("./Control/Margin/CanvasLayer/ExitPopup")
	configPopup = get_node("./Control/Margin/CanvasLayer/ConfigPopup")
	fade = get_node("./Control/Margin/CanvasLayer/FadeLayer")
	slideState = false
	
	# Set-up Initial Compliment Handling
	count = database.get_compliment_count()
	compliment.text = "Press the button to receive a compliment."

	# Set Settings Values
	volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	windowMode = config.get_value("Display", "Mode")
	resolution = config.get_value("Display", "Resolution")
	
	# Variables for Setting Alterations
	newMode = windowMode
	newRes = resolution
	settingsChanged = false
	
	$Control/Margin/CanvasLayer/ConfigPopup/VolumeBox/volumeSlider.set_value_no_signal(volume)
	$Control/Margin/CanvasLayer/ConfigPopup/DisplayBox/display_mode.selected =  windowMode
	$Control/Margin/CanvasLayer/ConfigPopup/ResolutionBox/screen_size.selected = resolution

# Function to select a random compliment for display on button press
func _on_please():
	
	# Select a random id from 1 to the size of the compliment table
	var selection: int = random.randi_range(1, count)
	
	var c: String = database.get_compliment(selection)
	compliment.text = c

# Show Exit Pop-up on Exit Button Click
func on_ask_exit() -> void:
	$UIButtons.play()
	fade.visible = true
	popup.visible = true

# Close Exit Pop-up when canceling the exit game action
func cancel_exit() -> void:
	$UIButtons.play()
	popup.visible = false
	fade.visible = false

# Closes the game
func on_exit() -> void:
	get_tree().quit()

# Display Configuration Menu
func nav_configuration() -> void:
	$UIButtons.play()
	fade.visible = true
	configPopup.visible = true

# Function to handle sliding menu animation
# Plays the slide animation and then flips the arrow button
func on_slide_pressed() -> void:
	# Slide Opens
	if slideState == false:
		slide.play("slide")
		slideButton.flip_h = false
		slideState = true
	# Slide Closes
	else:
		slide.play_backwards("slide")
		slideButton.flip_h = true
		slideState = false

# Close Configuration Pop-up
func exit_config() -> void:
	settingsChanged = false
	$UIButtons.play()
	configPopup.visible = false
	fade.visible = false
	$Control/Margin/CanvasLayer/ConfigPopup/apply.visible = false
	return

# Pop-up Process for clearing changes and applying the saved configuration
func cancel_config() -> void:
	# In the case the temporary setting is different, change back to original
	if newMode != windowMode:
		_on_display_item_selected(windowMode)
		$Control/Margin/CanvasLayer/ConfigPopup/DisplayBox/display_mode.selected =  windowMode
	if newRes != resolution:
		_on_screen_size_item_selected(resolution)
		$Control/Margin/CanvasLayer/ConfigPopup/ResolutionBox/screen_size.selected = resolution
	exit_config()
	return

# Pop-up Process for enacting and saving changes to the configuration
func apply_config() -> void:
	# Audio Setting
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	config.set_value("Audio", "Volume", volume)
	
	# Display Mode
	if newMode != windowMode:
		windowMode = newMode
		config.set_value("Display", "Mode", newMode)
	
	# Resolution
	if newRes != resolution:
		config.set_value("Display", "Resolution", newRes)
		resolution = newRes
	
	# Apply changes to the user's configuration file
	if settingsChanged:
		config.save("user://settings.cfg")
	
	exit_config()
	return

# Set the Test Audiobus Level for User Testing
func _volume_changed(value: float) -> void:
	volume = $Control/Margin/CanvasLayer/ConfigPopup/volumeSlider.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("TestBus"), volume)
	if !settingsChanged:
		settingsChanged = true
		$Control/Margin/CanvasLayer/ConfigPopup/apply.visible = true
	$Control/Margin/CanvasLayer/ConfigPopup/TestSound.play()

# Alters the Display Mode of the screen
func _on_display_item_selected(index: int) -> void:
	util.mode_change(index)
	_on_screen_size_item_selected(newRes)
	get_window().move_to_center()
	if !settingsChanged:
			settingsChanged = true
			$Control/Margin/CanvasLayer/ConfigPopup/apply.visible = true
	newMode = index

# Alters the Resolution of the screen
func _on_screen_size_item_selected(index: int) -> void:
	util.screen_size_change(index)
	get_window().move_to_center()
	if !settingsChanged:
			settingsChanged = true
			$Control/Margin/CanvasLayer/ConfigPopup/apply.visible = true
	newRes = index
