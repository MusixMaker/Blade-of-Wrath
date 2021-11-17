extends Control

#Variables made ready on play
onready var fps_label = get_node("ColorRect/fps_label")

func _process(delta):
	#Sets max bar value to max player health and current bar value to current player health
	$Health.max_value = PlayerStats.MAX_PLAYER_HEALTH
	$Health.value = PlayerStats.PLAYER_HEALTH
	#Tells the fps label to print the engine's fps
	fps_label.set_text(str(Engine.get_frames_per_second()))
