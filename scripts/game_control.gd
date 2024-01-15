extends Node2D
var compliment: Label
var database: Object
var count: int
var random: RandomNumberGenerator
const database_script = preload("res://data/database_access.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	random = RandomNumberGenerator.new()
	database = database_script.new()
	count = database.get_compliment_count()
	compliment = get_node("./Control/Margin/CanvasLayer/Background/Textbox/Margin/Compliment")	
	compliment.Text = "Press the button to receive a compliment."
	
func _on_please():
	var selection: int = random.randi_range(0, count)
	compliment.Text = database.get_compliment(selection)
