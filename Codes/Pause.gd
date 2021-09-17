extends CanvasLayer

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("Pause"):
		$Background.visible = !$Background.visible
		get_tree().paused = !get_tree().paused
		if Input.MOUSE_MODE == Input.MOUSE_MODE_CONFINED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif Input.MOUSE_MODE == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func _on_Audio_pressed():
	pass


func _on_Sfx_pressed():
	pass


func _on_Fps_pressed():
	pass


func _on_Quit_pressed():
	get_tree().quit()
