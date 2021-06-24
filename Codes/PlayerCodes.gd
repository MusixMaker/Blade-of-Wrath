extends KinematicBody

enum{
	IDLE,
	WALK,
	RUN,
	ATTACK,
	DAMAGE,
	DIE
}

#Stats
var cur_hp : int = 10
var max_hp : int = 10
var score : int = 0
var state = IDLE

#Physics
var walking = false
var sprint = false
var movementSpeed : float = 10
var jumpForce : float = 5
var gravity : float = 15

#Cam look
var minLookAngle : float = -90
var maxLookAngle : float = 90
var loookSensitivity : float = 20

#Vectors
var vel = Vector3() 
var mouseDelta = Vector2()

#components
onready var camera : Camera = get_node("Camera")
onready var ap = $Player/AnimationPlayer

func _ready():
	#hide and lock mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 

func _physics_process(delta):
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
		
	if Input.is_action_pressed("move_back"):
		input.y -= 1
		walking = true
		
	if Input.is_action_pressed("move_left"):
		input.x += 1
		walking = true
		
	if Input.is_action_pressed("move_right"):
		input.x -= 1
		walking = true
		
		
		
	if Input.is_action_pressed("sprint") and walking == true:
		walking = false
		sprint = true
		movementSpeed = 10
		state = RUN
	
		
	#changes statses for movement
	if walking == true:
		state = WALK
		
	if walking == false and sprint == false:
		state = IDLE

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
		ATTACK:
			ap.play("Stabby")
		DAMAGE:
			ap.play("Get_Stabbed")
		DIE:
			ap.play("Die")

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
