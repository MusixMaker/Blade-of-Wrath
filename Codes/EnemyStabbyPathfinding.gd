extends KinematicBody

#State machine declarer
enum{
	IDLE,
	ATTACK,
	STABBED,
	RUN,
	WALK,
	DEAD
}

#Variables
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

#Variables made ready at play
onready var nav = get_parent().get_parent()
onready var player_pos = $"../../../Player"
onready var ap = $AnimationPlayer
onready var attacktimer = $StabTimer
onready var ray = $RayCast

#Function gets called when play is hit
func _ready():
	state = IDLE

#Generates new and quickest path to player
func new_path():
	target = player_pos.global_transform.origin
	path = nav.get_simple_path(global_transform.origin, target)
	path_node = 0
	return path

#Where it all happens
func _physics_process(delta):
	if seen == true:
		
		#If there are more nodes between the enemy and the end of their path, they move
		if path_node < path.size():
			state = RUN
			
			#Generates new path if none are available
		else:
			new_path()
			
	#Sets requirements for death
	if health <= 0:
		state = DEAD
		
		#State machine, for movement and animations
	match state:
		IDLE:
			ap.play("Idle")
		RUN:
			ap.play("Run")
			
			#Gets direction of nect node on path
			var direction = (path[path_node] - global_transform.origin)
			
			#Adds new nodes when there are none left
			if direction.length() < 1:
				path_node += 1
			else:
				#If distance to player is above 1, it moves towards them
				look_at(player_pos.global_transform.origin - direction.normalized(), Vector3.UP)
				move_and_slide(direction.normalized() * speed, Vector3.UP)
				new_path()
		ATTACK:
			ap.play("Stabby")
		DEAD:
			ap.play("Die")
			#Sets dead to true, allowing queue_free of sprite
			dead = true


func _on_SightRange_body_entered(body):
	#If the player enters the area the enemy is aware of them
	if body.is_in_group("Player"):
		seen = true
		path = new_path() #Creates new path towards player
		state = RUN #Starts running
		attacktimer.start() #Starts timer which prevents attacks over and over

		



func _on_SightRange_body_exited(body):
	if body.is_in_group("Player"):
		#When player leaves area around enemy, they 'lose sight' of them and become idle
		seen = false 
		attacktimer.stop() #Stops the attack timer, meaning it can't attack right away when the player comes back
		state = IDLE



func _on_StabTimer_timeout():
	#If the raycast is hitting the player then they are within arms length, and so can stab them
	if ray.is_colliding():
		var hit = ray.get_collider()
		if hit.is_in_group("Player"): #Checks that the body is the player and not just a wall
			PlayerStats.PLAYER_HEALTH -= 10 #Player loses health
			state = ATTACK
			attacktimer.start() #Restarts atack timer


func _on_AnimationPlayer_animation_finished(anim_name):
	if dead == true:
		queue_free() #Deletes this enemy from the game
	else:
		#If yo aint dead, this is ignored here
		pass
