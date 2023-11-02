extends Node

var db : SQLite = SQLite.new()

const verbosity_level : int = SQLite.VERBOSE

var db_name := "res://data/database.db"

func _ready():
	db.path = db_name
	db.verbosity_level = verbosity_level

func get_compliments():
	db.open_db()
	var selected = db.select_rows("standard", "", ["*"])
	db.close_db()
	return selected
