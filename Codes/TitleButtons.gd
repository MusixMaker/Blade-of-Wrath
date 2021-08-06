extends Control
onready var ap = $MenuContainer/Fade/FadePlayer
var fadequit = false
var fadegame = false

func _ready():
	ap.play("FadeIn")


func _on_Play_pressed():
	ap.play("FadeOut")
	fadegame = true

func _on_Options_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	ap.play("FadeOut")
	fadequit = true

func _on_FadePlayer_animation_finished(FadeOut):
	if fadequit == true:
		get_tree().quit()
	if fadegame == true:
		get_tree().change_scene('res://Scenes/Test Level.tscn')
