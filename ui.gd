extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var mouse_area : Area2D = $mouse_area


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass


func _input(event):
   if event is InputEventMouseMotion:
	   mouse_area.position = event.position


func _notification(notification):
	match notification:
		NOTIFICATION_WM_MOUSE_EXIT:
			mouse_area.visible = false
			print('Mouse left window')
		NOTIFICATION_WM_MOUSE_ENTER:
			mouse_area.visible = true
			print('Mouse entered window')
