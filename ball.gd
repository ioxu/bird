extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("ui_up"):
		apply_central_impulse(Vector2(0.0, -20.0))
#
#func jump():
#	applied_force = Vector2(10.0, 0.0)
#
#func _physics_process(delta):
#	jump()
