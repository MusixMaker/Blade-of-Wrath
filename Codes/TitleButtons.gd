extends Control

#Variables made ready on play pressed
onready var ap = $Fade/FadePlayer
onready var map = $AudioStreamPlayer/Musicfader

#Fade variables
var fadequit = false
var fadegame = false

#Fades in screen and music together on play pressed
func _ready():
	ap.play("FadeIn")
	map.play("FadeMusicIn")
	$AudioStreamPlayer.play()


func _on_Play_pressed():
	#Sets player health to full
	PlayerStats.PLAYER_HEALTH = PlayerStats.MAX_PLAYER_HEALTH
	#Fades out screen and music
	ap.play("FadeOut")
	map.play("FadeMusicOut")
	fadegame = true

func _on_Options_pressed():
	get_tree().change_scene("res://Scenes/Options.tscn")
	#Loads the options scene when clicked

func _on_Quit_pressed():
	ap.play("FadeOut")
	map.play("FadeMusicOut")
	fadequit = true
	#Fades out music and screen and sets quit to true

func _on_FadePlayer_animation_finished(FadeOut):
	if fadequit == true:
		get_tree().quit()
		#If game was faded due to quit button being hit, it quits the game
	if fadegame == true:
		get_tree().change_scene('res://Scenes/Test Level.tscn')
		#If game was faded due to play being pressed, it loads the game scene
