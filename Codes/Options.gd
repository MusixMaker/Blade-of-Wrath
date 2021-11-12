extends Control

var fps = is_in_group("fps")

func _ready():
	pass
	


func _on_Audio_pressed():
	pass # Replace with function body.


func _on_Fps_pressed():
	fps.hide()


func _on_Return_pressed():
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
