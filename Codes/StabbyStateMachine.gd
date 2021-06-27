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
var space_state
var target
var stabby_health = 100

const TURN_SPEED = 2

onready var raycast = $RayCast
onready var ap = $AnimationPlayer
onready var eyes = $Eyes
onready var attacktimer = $StabTimer

func _ready():
	space_state = get_world().direct_space_state

func _on_SightRange_body_entered(body):
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
			var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
			if result.collider.is_in_group("Player"):
				ap.play("Run")
				eyes.look_at(target.global_transform.origin, Vector3.UP)
				rotate_y(deg2rad(-eyes.rotation.y * TURN_SPEED))
			else:
				state = IDLE
		ATTACK:
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			ap.play("Stabby")
	if stabby_health <= 0:
		ap.play("Die")
		queue_free()



func _on_StabTimer_timeout():
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("Player"):
			print("Hit")
			state = ATTACK
			attacktimer.start()

