extends KinematicBody

"""var gravity = -9.8
var velocity = Vector3()
var camera

const SPEED = 6
const ACCELERATION = 3
const DE_ACCELERATION = 5

func _ready():
	camera = get_node("Camera").get_global_transform()

func _physics_process(delta):
	var dir = Vector3()
	
	if(Input.is_action_pressed("move_forward")):
		dir += -camera.basis[2]
	if(Input.is_action_pressed("move_back")):
		dir += camera.basis[2]
	if(Input.is_action_pressed("move_left")):
		dir += -camera.basis[0]
	if(Input.is_action_pressed("move_right")):
		dir += camera.basis[0]
		
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y += delta * gravity
	
	var hv = velocity
	hv.y = 0
	
	var new_pos = dir * SPEED
	var accel = DE_ACCELERATION
	
	if (dir.dot(hv) > 0):
		accel = ACCELERATION
		
	hv = hv.linear_interpolate(new_pos, accel * delta)
	
	velocity.x = hv.x
	velocity.z = hv.z
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))"""
#Stats
var cur_hp : int = 10
var max_hp : int = 10
var score : int = 0

#Physics
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

func _ready():
	#hide and lock mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 

func _physics_process(delta):
	print(is_on_floor())
	#set X and Y velocities to 0
	vel.x = 0
	vel.z = 0
	movementSpeed = 5
	
	var input = Vector2()
	
	#Movement Inputs
	if Input.is_action_pressed("move_forward"):
		input.y += 1
	if Input.is_action_pressed("move_back"):
		input.y -= 1
	if Input.is_action_pressed("move_left"):
		input.x += 1
	if Input.is_action_pressed("move_right"):
		input.x -= 1
	if Input.is_action_pressed("sprint"):
		movementSpeed = 10
	
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

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
