extends Node

# Set-up SQLite Connection
var db : SQLite = SQLite.new()
const verbosity_level : int = SQLite.VERBOSE
var db_name := "res://data/content/compliments_database"

# Returns the number of rows in the database
# Corresponds to the number of compliments
func get_compliment_count()->int:

	db.path = db_name
	db.verbosity_level = verbosity_level
	db.open_db()
	
	var count = db.select_rows("standard", "", ["COUNT(*)"])[0]["COUNT(*)"]
	
	# Only keep the database open for the duration of the query
	db.close_db()
	return count

# Returns a compliment string from the database
# Selection: id of the compliment in the database to return
func get_compliment(selection: int) -> String:
	
	db.path = db_name
	db.verbosity_level = verbosity_level
	
	var condition: String = "id = " + str(selection)
	db.open_db()
	var compliment: String = db.select_rows("standard", condition, ["compliment"])[0]["compliment"]
	
	# Only keep the database open for the duration of the query
	db.close_db()
	return compliment
