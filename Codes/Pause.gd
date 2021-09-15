extends Control


func _ready():
	if Input.is_action_pressed("pause"):
		pass

func _on_Audio_pressed():
	pass


func _on_Sfx_pressed():
	pass


func _on_Fps_pressed():
	pass


func _on_Quit_pressed():
	get_tree().quit()
