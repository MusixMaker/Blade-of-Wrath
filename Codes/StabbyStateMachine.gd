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
	
	if raycast.is_colliding():
		state = WALK
	elif Input.is_action_just_released("attack"):
		state = STABBED
	else:
		state = IDLE
	
	match state:
		IDLE:
			ap.play("Idle")
		WALK:
			ap.play("Walk")
		RUN:
			ap.play("Run")
		ATTACK:
			ap.play("Stabby")
		STABBED:
			ap.play("Get_Stabbed")
		DEAD:
			ap.play("")
