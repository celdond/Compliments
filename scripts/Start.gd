extends TextureButton

func _on_pressed():
	var game_scene: String = "res://scenes/compliment.tscn"
	get_tree().change_scene_to_file(game_scene)
