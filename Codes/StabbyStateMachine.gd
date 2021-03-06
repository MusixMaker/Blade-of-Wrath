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
var speed = 2
var dead = false
var vel = Vector3()
var gravity : float = 30
var path = []
var current_node = 0
var pos = Position3D
var m = SpatialMaterial.new()
var camrot = 0.0

#Constats
const TURN_SPEED = 2

#Variables loaded on startup
onready var raycast = $RayCast
onready var ap = $AnimationPlayer
onready var eyes = $Eyes
onready var attacktimer = $StabTimer
onready var nav = $"../../Navigation" as Navigation
onready var player = $"../../Player" as KinematicBody
onready var draw = $"../../Navigation/Draw"

#Functions
func _ready():
	#space_state = get_world().direct_space_state
	pass

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
	
	update_path(player.global_transform.origin)
	if current_node < path.size():
		var direction: Vector3 = path[current_node] - global_transform.origin
		if direction.length() < 1:
			current_node += 1
			state = IDLE
		else:
			move_and_slide(direction.normalized() * speed)
			state = RUN
			draw_path(path)
	#if path_node < path.size():
		#state = RUN
	if health <= 0:
		state = DEAD
#
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

#Movement function
#func move_to(target_pos):
	#path = nav.get_simple_path(global_transform.origin, target_pos)
	#path_node = 0

func update_path(target_position):
	path = nav.get_simple_path(global_transform.origin, target_position)

#Attack time
func _on_StabTimer_timeout():
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("Player"):
			print("Hit")
			PlayerStats.PLAYER_HEALTH -= 10
			state = ATTACK
			attacktimer.start()

#Getting deleted
func _on_AnimationPlayer_animation_finished(anim_name):
	if dead == true:
		queue_free()
	else:
		#If yo aint dead, this is ignored here
		pass

func draw_path(path_array):
	var im = get_node("draw")
	im.begin(Mesh.PRIMITIVE_POINTS, null)
	im.add_vertex(path_array[0])
	im.add_vertex(path_array[path_array.size() - 1])
	im.end()
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for x in path:
		im.add_vertex(x)
	im.end()

#func _on_WalkTimer_timeout():
	#move_to(player.global_transform.origin)
