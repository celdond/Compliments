extends TextureButton

func _on_pressed():
	$".".disabled = true
	var game_scene: String = "res://scenes/compliment.tscn"
	$ClickDown.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(game_scene)
	return

#Ignore / Overwrite
func _on_button_down() -> void:
	pass
