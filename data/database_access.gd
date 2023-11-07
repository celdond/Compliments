extends Node

var db : SQLite = SQLite.new()

const verbosity_level : int = SQLite.VERBOSE

var db_name := "res://data/content/compliments_database"

func get_compliment_count()->int:
	db.path = db_name
	db.verbosity_level = verbosity_level
	db.open_db()
	var count = db.select_rows("standard", "", ["COUNT(*)"])[0]["COUNT(*)"]
	db.close_db()
	return count

func get_compliment(selection: int) -> String:
	db.path = db_name
	db.verbosity_level = verbosity_level
	var condition: String = "id = " + str(selection)
	db.open_db()
	var compliment = db.select_rows("standard", condition, ["compliment"])[0]["compliment"]
	db.close_db()
	return compliment
