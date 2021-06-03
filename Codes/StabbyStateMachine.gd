extends Spatial

enum {
	IDLE,
	ATTACK,
	STABBED,
	WALK,
	RUN,
	DEAD
} 

var state = IDLE
var otherstate = WALK

onready var raycast = $RayCast
onready var ap = $AnimationPlayer

func _ready():
	pass # Replace with function body.

func _process(delta):
	match state:
		IDLE:
			ap.play("Idle")
		WALK:
			ap.play("Walk")
		RUN:
			ap.play("Run")
