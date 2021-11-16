extends KinematicBody

enum{
	IDLE,
	ATTACK,
	STABBED,
	RUN,
	WALK,
	DEAD
}

var gravity : float = 9.8
var vel = Vector3()
var target = Vector3.ZERO
var space_state
var path = []
var path_node = 0
var show_path = true
var speed = 5
var seen = false
var state = IDLE
var health = 400
var dead = false

onready var nav = get_parent().get_parent()
onready var player_pos = $"../../../Player"
onready var ap = $AnimationPlayer
onready var attacktimer = $StabTimer
onready var ray = $RayCast

func new_path():
	target = player_pos.global_transform.origin
	path = nav.get_simple_path(global_transform.origin, target)
	path_node = 0
	return path

func _physics_process(delta):
	if seen == true:
		
		if path_node < path.size():
			var direction = (path[path_node] - global_transform.origin)
			
			if direction.length() < 1:
				path_node += 1
			else:
				look_at(player_pos.global_transform.origin - direction.normalized(), Vector3.UP)
				move_and_slide(direction.normalized() * speed, Vector3.UP)
				new_path()
			
		else:
			new_path()
	if health <= 0:
		state = DEAD
		
	match state:
		IDLE:
			ap.play("Idle")
		RUN:
			ap.play("Run")
		ATTACK:
			ap.play("Stabby")
		DEAD:
			ap.play("Die")
			dead = true


func _on_SightRange_body_entered(body):
	if body.is_in_group("Player"):
		seen = true
		path = new_path()
		state = RUN
		attacktimer.start()

		



func _on_SightRange_body_exited(body):
	if body.is_in_group("Player"):
		seen = false
		attacktimer.stop()



func _on_StabTimer_timeout():
	if ray.is_colliding():
		var hit = ray.get_collider()
		if hit.is_in_group("Player"):
			print("Hit")
			PlayerStats.PLAYER_HEALTH -= 10
			state = ATTACK
			attacktimer.start()


func _on_AnimationPlayer_animation_finished(anim_name):
	if dead == true:
		queue_free()
	else:
		#If yo aint dead, this is ignored here
		pass
