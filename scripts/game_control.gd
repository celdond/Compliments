extends Node2D
var compliment: Label
var slide: Control
var database: Object
var count: int
var random: RandomNumberGenerator
const database_script = preload("res://data/database_access.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	random = RandomNumberGenerator.new()
	database = database_script.new()
	count = database.get_compliment_count()
	compliment = get_node("./Control/Margin/CanvasLayer/Background/Textbox/Compliment")
	slide = get_node("./Control/Margin/CanvasLayer/Slide")
	compliment.text = "Press the button to receive a compliment."
	
func _on_please():
	var selection: int = random.randi_range(1, count)
	compliment.text = database.get_compliment(selection)


func on_exit() -> void:
	get_tree().quit()


func nav_configuration() -> void:
	var config_scene: String = "res://scenes/configuration.tscn"
	get_tree().change_scene_to_file(config_scene)


func on_slide_pressed() -> void:
	pass
