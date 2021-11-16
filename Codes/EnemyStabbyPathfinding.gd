extends KinematicBody


var gravity : float = 9.8
var vel = Vector3()
var target = Vector3.ZERO




var path = []
var path_node = 0
var show_path = true
var speed = 1
var seen = false
onready var nav = get_parent().get_parent()

onready var player_pos = $"../../../Player"

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
			
		else:
			new_path()
		if $RayCast.is_colliding():
			if $RayCast.get_collider().is_in_group("Player"):
				pass
			elif $RayCast.get_collider():
				pass



func _on_SightRange_body_entered(body):
	if body.is_in_group("Player"):
		print("see player")
		seen = true
		path = new_path()

		



func _on_SightRange_body_exited(body):
	return
	if body.is_in_group("Player"):
		print("not see player")
		seen = false
