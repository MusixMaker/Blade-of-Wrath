extends KinematicBody

#State machine
enum{
	IDLE,
	WALK,
	RUN,
	JUMP,
	ATTACK,
	DAMAGE,
	DIE
}

#Stats
#var cur_hp : int = 100
#var max_hp : int = 100
var score : int = 0
var state = IDLE
var melee_damage = 50

#Physics
var walking = false
var sprint = false
var movementSpeed : float = 5
var jumpForce : float = 10
var gravity : float = 30

#Cam look
var minLookAngle : float = -90
var maxLookAngle : float = 90
var loookSensitivity : float = 20

#Vectors
var vel = Vector3() 
var mouseDelta = Vector2()

#components
onready var camera : Camera = get_node("Camera")
onready var ap = $PlayerTryout/AnimationPlayer
onready var hitbox = $Hitbox

func melee():
	#ap.play("Stabby")
	if ap.current_animation == "Stabby":
		#Finds if enemy is inside hitbox and allows the player to hit them if they are
		for body in hitbox.get_overlapping_bodies():
			if body.is_in_group("Enemy"):
				yield(get_tree().create_timer(0.5), "timeout")
				body.health -= melee_damage
				print("damaged")
	yield(ap,"animation_finished")
	state = IDLE
	

func _ready():
	#hide and lock mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 

func _physics_process(delta):
	#Sets velocities and speed
	#print(is_on_floor())#
	#set X and Y velocities to 0
	vel.x = 0
	vel.z = 0
	movementSpeed = 5
	
	var input = Vector2()
	
	#Movement Inputs
	if Input.is_action_pressed("move_forward"):
		input.y += 1
		walking = true
		
	if Input.is_action_just_released("move_forward"):
		walking = false
		
	if Input.is_action_pressed("move_back"):
		input.y -= 1
		walking = true
		
	if Input.is_action_just_released("move_back"):
		walking = false
		
	if Input.is_action_pressed("move_left"):
		input.x += 1
		walking = true
		
	if Input.is_action_just_released("move_left"):
		walking = false
		
	if Input.is_action_pressed("move_right"):
		input.x -= 1
		walking = true
		
	if Input.is_action_just_released("move_right"):
		walking = false
		
	if Input.is_action_pressed("sprint") and walking == true and state != ATTACK:
		walking = false
		sprint = true
		movementSpeed = 10
		state = RUN
		
	if Input.is_action_just_released("sprint"):
		sprint = false
		movementSpeed =5
	
		
	#changes states for movement
	if walking == true and state != ATTACK:
		state = WALK
		
	if walking == true and sprint == true and state != ATTACK:
		state = RUN
		
	if walking == false and sprint == false and state != ATTACK:
		state = IDLE
		
	if Input.is_action_pressed("attack"):
		state = ATTACK
		melee()

	input = input.normalized()
	
	#Get directions
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	var relativeDir = (forward * input.y + right *input.x)
	
	#set the velocity
	vel.x = relativeDir.x * movementSpeed
	vel.z = relativeDir.z * movementSpeed
	
	#set gravity
	vel.y -= gravity * delta
	
	#move player
	vel = move_and_slide(vel, Vector3(1,1,0))
	
	#jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
		state = JUMP
		state = IDLE

func _process(delta):
	#rotate the camera along the x axis
	camera.rotation_degrees.x -= mouseDelta.y * loookSensitivity * delta
	#clamp the camera rotation
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	#rotate player along y axis
	rotation_degrees.y -= mouseDelta.x * loookSensitivity * delta
	#reset the mouse delta vector
	mouseDelta = Vector2()
	
	match state:
		IDLE:
			ap.play("Idle")
		WALK:
			ap.play("Walk")
		RUN:
			ap.play("Run")
		JUMP:
			ap.play("Jump")
		ATTACK:
			ap.play("Stabby")
		DAMAGE:
			ap.play("Get_Stabbed")
		DIE:
			ap.play("Die")

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
