extends RigidBody2D

var torque = 50000

var this_angle = 0.0

var initial_rot_relative_to_parent = 0.0

export var parent : NodePath

func _ready():
	initial_rot_relative_to_parent = get_rotation_relative_to_parent()



#################################################################################################
# https://github.com/krogank9/godot_stuff/blob/master/addons/PinSpringJoint2D/PinSpringJoint2D.gd
#################################################################################################




func _integrate_forces(state):
	var delta_to_desired_rot = get_rotation_relative_to_parent() - initial_rot_relative_to_parent

	applied_torque =  delta_to_desired_rot * torque

#	var rotation_dir = 0
#	if Input.is_action_pressed("ui_right"):
#		rotation_dir += 1
#	if Input.is_action_pressed("ui_left"):
#		rotation_dir -= 1
#
#	applied_torque = rotation_dir * torque

func get_rotation_relative_to_parent():
	#return self.rotation - get_node(parent).rotation
	return get_node(parent).rotation - self.rotation
