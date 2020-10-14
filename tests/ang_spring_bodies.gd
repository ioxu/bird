extends Node2D

# - world anchor
# - - pin joint
# - - - rb2d
# - - - - pin joint
# - - - - - rb2d
# - - - - - - pin joint
# - - - - - - - etc ..

func _ready():
	print(get_node("RigidBody2D").transform.get_rotation())
	get_node("RigidBody2D").this_angle = get_node("RigidBody2D").transform.get_rotation()
	print(get_node("RigidBody2D2").transform.get_rotation())
	get_node("RigidBody2D2").this_angle = get_node("RigidBody2D2").transform.get_rotation()
	
	# find the world anchor (StaticBody2D)
	var children = get_all_children( self.get_tree().get_root() )
	print("immediate children ", get_tree().get_root().get_children() )
	var joints := []
	var rigid_bodies := []
	print("children ",children)
	for c in children:
		if c is StaticBody2D:
			print("found world anchor: ", c)
		elif c is PinJoint2D:
			joints.append( c )
		elif c is RigidBody2D:
			rigid_bodies.append( c )
	
	print("joints ", joints)
	print("bodies ", rigid_bodies)
	
	# work out which pint joints join to it
#	print("joints:")
#	for j in joints:
#		if j.get_node(j.node_a) is StaticBody2D:
#
#		print(j.get_path(), " ", j.get_node(j.node_a))
#		print(j.get_path(), " ", j.get_node(j.node_b))
	
	print("anchor rotation ",get_node("StaticBody2D").rotation )
	
	pass


func _process(delta):
#	print("---")
#	print(get_node("RigidBody2D").this_angle)
#	print(get_node("RigidBody2D2").this_angle)
	pass


func get_all_children(node):
	var array = []
	_do_get_all_children(node, array)
	return array


func _do_get_all_children(node, array):
	for N in node.get_children():
		if N.get_child_count() > 0:
			_do_get_all_children(N, array)
		else:
			array.append(N)
	array.append(node)
