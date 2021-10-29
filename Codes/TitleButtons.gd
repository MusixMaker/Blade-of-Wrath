extends Control
onready var ap = $Fade/FadePlayer
onready var map = $AudioStreamPlayer/Musicfader
var fadequit = false
var fadegame = false

func _ready():
	ap.play("FadeIn")
	map.play("FadeMusicIn")
	$AudioStreamPlayer.play()


func _on_Play_pressed():
	PlayerStats.PLAYER_HEALTH = PlayerStats.MAX_PLAYER_HEALTH
	ap.play("FadeOut")
	map.play("FadeMusicOut")
	fadegame = true

func _on_Options_pressed():
	get_tree().change_scene("res://Scenes/Options.tscn")

func _on_Quit_pressed():
	ap.play("FadeOut")
	map.play("FadeMusicOut")
	fadequit = true

func _on_FadePlayer_animation_finished(FadeOut):
	if fadequit == true:
		get_tree().quit()
	if fadegame == true:
		get_tree().change_scene('res://Scenes/Test Level.tscn')
