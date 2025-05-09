extends Node

const resolutions: Dictionary = {
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080),
	"1152 x 648": Vector2i(1152, 648)
}

# Function to change the resolution of the game window
# Index: index of the resolution in the above dictionary
func screen_size_change(index: int) -> void:
	DisplayServer.window_set_size(resolutions.values()[index])

# Function to change the display mode of the screen
# Index: integer corresponding to the target window mode
func mode_change(index: int) -> void:
	match index:
		# Fullscreen Borderless
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		# Windowed
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		# Windowed Borderless	
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
