extends Spatial



enum {
	IDLE,
	ALERT,
	ATTACK,
	STABBED,
	DEAD
} 

var state = IDLE

onready var raycast = $RayCast

func _ready():
	pass # Replace with function body.
