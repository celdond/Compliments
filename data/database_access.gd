extends Node

var db : SQLite = SQLite.new()

const verbosity_level : int = SQLite.VERBOSE

var db_name := "res://data/content/compliments_database"

func get_compliments() -> Array:
	db.path = db_name
	db.verbosity_level = verbosity_level
	db.open_db()
	var selected: Array = db.select_rows("standard", "", ["*"])
	db.close_db()
	return selected
