extends TextureButton

# Runs when the button on the start_menu scene is pressed
func _on_pressed():
	
	# Disables the button so the user cannot rapidly press it
	$".".disabled = true
	
	# Set-up Transition
	var game_scene: String = "res://scenes/compliment.tscn"
	$ClickDown.play()
	
	# Wait for the sound to finish
	await get_tree().create_timer(0.1).timeout
	
	# Transition to Main Game Scene
	get_tree().change_scene_to_file(game_scene)
	return

# Ignore / Overwrite inherited signal from button scene
func _on_button_down() -> void:
	pass
