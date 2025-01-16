extends TextureButton
var onClick: AudioStreamPlayer


func _on_button_down() -> void:
	$ClickDown.play()
	return

func _on_button_up() -> void:
	$Release.play()
	return
