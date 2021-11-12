extends Control

onready var fps_label = get_node("ColorRect/fps_label")

func _process(delta):
	$Health.max_value = PlayerStats.MAX_PLAYER_HEALTH
	$Health.value = PlayerStats.PLAYER_HEALTH
	fps_label.set_text(str(Engine.get_frames_per_second()))
