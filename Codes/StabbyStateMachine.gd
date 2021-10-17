extends KinematicBody
#State Machine
enum {
	IDLE,
	ATTACK,
	STABBED,
	RUN,
	WALK,
	DEAD
} 
#Variables
var state = IDLE
var space_state
var target
var health = 400
var direction
var speed = 20
var dead = false
var vel = Vector3()
var gravity = 30

#Constats
const TURN_SPEED = 2

#Variables loaded on startup
onready var raycast = $RayCast
onready var ap = $AnimationPlayer
onready var eyes = $Eyes
onready var attacktimer = $StabTimer

#Functions
func _ready():
	space_state = get_world().direct_space_state

#If The player is in it's sights
func _on_SightRange_body_entered(body):
	if body.is_in_group("Player"):
		#Makes enemy run towards player
		state = RUN
		target = body #Target is the player
		attacktimer.start() #Starts timer for the attack animation

#When the player leaves the sight of the enemy it goes idle again
func _on_SightRange_body_exited(body):
	state = IDLE
	attacktimer.stop()

#State machine and death time
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

#Movement function
func move_to_target(delta):
	#vel = move_and_slide(vel, Vector3(1,1,0))
	var direction = (target.transform.origin - transform.origin).normalized()
	move_and_slide(direction * speed * delta, Vector3.UP)

#Attack time
func _on_StabTimer_timeout():
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("Player"):
			print("Hit")
			state = ATTACK
			attacktimer.start()

#Getting deleted
func _on_AnimationPlayer_animation_finished(anim_name):
	if dead == true:
		queue_free()
	else:
		#If yo aint dead, this is ignored here
		pass
