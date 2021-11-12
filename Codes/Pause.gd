extends CanvasLayer

#Pause starts off as false
var pause = false
var fps = is_in_group("fps")

func _ready():
	pass

#Pauses the game and everything happening while on pause screen
func _input(event):
	if event.is_action_pressed("Pause"):
		#Pause screen is always there and just hidden
		$Background.visible = !$Background.visible
		get_tree().paused = !get_tree().paused
	
		#Confines mouse so it doesn't move like in-game
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_Audio_pressed():
	#Replace with function body
	pass


func _on_Fps_pressed():
	fps.hide()


func _on_Quit_pressed():
	get_tree().quit()
	#Quits the game


func _on_Restart_pressed():
	get_tree().change_scene("res://Scenes/Test Level.tscn")
	$Background.visible = !$Background.visible
	get_tree().paused = !get_tree().paused
	PlayerStats.PLAYER_HEALTH = PlayerStats.MAX_PLAYER_HEALTH
	if get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
