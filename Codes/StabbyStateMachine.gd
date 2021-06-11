extends Spatial

enum {
	IDLE,
	ATTACK,
	STABBED,
	RUN,
	WALK,
	DEAD
} 

var state = IDLE

var target

const TURN_SPEED = 2

onready var raycast = $RayCast
onready var ap = $AnimationPlayer
onready var eyes = $Eyes
onready var attacktimer = $StabTimer

func _ready():
	pass

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		state = RUN
		target = body
		attacktimer.start()

func _on_SightRange_body_exited(body):
	state = IDLE
	attacktimer.stop()

func _process(delta):
	match state:
		IDLE:
			ap.play("Idle")
		RUN:
			ap.play("Run")
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(-eyes.rotation.y * TURN_SPEED))
		ATTACK:
			ap.play("Attack")



func _on_StabTimer_timeout():
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("Player"):
			print("Hit")
