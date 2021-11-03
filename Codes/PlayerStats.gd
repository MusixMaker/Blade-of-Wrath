extends Node

var MAX_PLAYER_HEALTH = 100
var PLAYER_HEALTH = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		PLAYER_HEALTH -= 10
	if Input.is_action_just_pressed("ui_up"):
		PLAYER_HEALTH += 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
