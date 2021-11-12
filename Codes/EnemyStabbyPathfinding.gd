extends KinematicBody

const SPEED = 2
var gravity : float = 9.8
var vel = Vector3()




var path = []
var show_path = true
onready var nav = get_parent().get_parent()

onready var player_pos = $"../../../Player"



func _physics_process(delta):
	vel.y -= gravity * delta
	var direction = Vector3()

	# We need to scale the movement speed by how much delta has passed,
	# otherwise the motion won't be smooth.
	var step_size = delta * SPEED

	if path.size() > 0:
		print("more to move")
		# Direction is the difference between where we are now
		# and where we want to go.
		var destination = path[0]
		direction = destination - translation

		# If the next node is closer than we intend to 'step', then
		# take a smaller step. Otherwise we would go past it and
		# potentially go through a wall or over a cliff edge!
		if step_size > direction.length():
			step_size = direction.length()
			# We should also remove this node since we're about to reach it.
			path.remove(0)

		# Move the robot towards the path node, by how far we want to travel.
		# Note: For a KinematicBody, we would instead use move_and_slide
		# so collisions work properly.
		translation += direction.normalized() * step_size

		# Lastly let's make sure we're looking in the direction we're traveling.
		# Clamp y to 0 so the robot only looks left and right, not up/down.
		
			# Direction is relative, so apply it to the robot's location to
			# get a point we can actually look at.
			
			# Make the robot look at the point.
		look_at(player_pos.global_transform.origin, Vector3.UP)
			
	
#	if show_path:
#		#draw_path(path)
#		print("show me the path")


#func draw_path(path_array):
#	print(path)
#	var im = get_node("Draw")
#	im.add_vertex(path_array[0])
#	im.add_vertex(path_array[path_array.size() - 1])
#	im.end()
#	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
#	for x in path:
#		im.add_vertex(x)
#	im.end()


func _on_SightRange_body_entered(body):
	if body.is_in_group("Player"):
		print("creating path")
	#var from = get_position_in_parent()
	#var to = player_pos
		var target_point = nav.get_closest_point_to_segment(global_transform.origin, body.global_transform.origin)
	#print("this shouldn't work")
		path = nav.get_simple_path(global_transform.origin, target_point, true)
