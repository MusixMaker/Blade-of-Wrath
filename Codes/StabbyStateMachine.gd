extends KinematicBody

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
var health = 400
var direction
var speed = 20
var dead = false
var vel = Vector3()
var gravity = 30
var path = []
var path_node = 0

const TURN_SPEED = 2

onready var raycast = $RayCast
onready var ap = $AnimationPlayer
onready var eyes = $Eyes
onready var attacktimer = $StabTimer
onready var nav = get_parent()
onready var player = $"Navigation/NavigationMeshInstance/Player"

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

func _physics_process(delta):
	vel.y -= gravity * delta
	if health <= 0:
		state = DEAD
	match state:
		IDLE:
			ap.play("Idle")
		RUN:
			var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
			if result.collider.is_in_group("Player"):
				ap.play("Run")
				eyes.look_at(target.global_transform.origin, Vector3.UP)
				rotate_y(deg2rad(-eyes.rotation.y * TURN_SPEED))
				move_to_target(delta)
			else:
				state = IDLE
		ATTACK:
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			ap.play("Stabby")
		DEAD:
			ap.play("Die")
			dead = true

func move_to_target(delta):
	#vel = move_and_slide(vel, Vector3(1,1,0))
	var direction = (target.transform.origin - transform.origin).normalized()
	move_and_slide(direction * speed * delta, Vector3.UP)

func _on_StabTimer_timeout():
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("Player"):
			print("Hit")
			state = ATTACK
			attacktimer.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if dead == true:
		queue_free()
	else:
		pass
