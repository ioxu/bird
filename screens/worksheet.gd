extends Node2D

var zoom_factor = 1.1
var _panning = false
var mouse_last_position := Vector2.ZERO

signal changed_zoom

func _input(event):
	if event is InputEventMouse:
		if event.is_pressed() and not event.is_echo():
			var mouse_position = event.position
			# zoom
			if event.button_index == BUTTON_WHEEL_UP:
				_zoom_at_point(zoom_factor, mouse_position)
			elif event.button_index == BUTTON_WHEEL_DOWN:
				_zoom_at_point(1 / zoom_factor, mouse_position)
			if event.button_index == BUTTON_MIDDLE:
					# start panning
					mouse_last_position = mouse_position
					_panning = true
	
	if event is InputEventMouseButton:
		if not event.is_pressed() and not event.is_echo():
			if event.button_index == BUTTON_MIDDLE:
				# stop panning
				mouse_last_position = event.position
				_panning = false

func _zoom_at_point(zoom_change, mouse_position):
	scale = scale * zoom_change
	emit_signal("changed_zoom", scale)
	var delta_x = (mouse_position.x - global_position.x) * (zoom_change - 1)
	var delta_y = (mouse_position.y - global_position.y) * (zoom_change - 1)
	global_position.x = global_position.x - delta_x
	global_position.y = global_position.y - delta_y
	

func _process(dt):
	var ref = get_viewport().get_mouse_position()
	if _panning:
		global_position.x += (ref.x - mouse_last_position.x)
		global_position.y += (ref.y - mouse_last_position.y)
	mouse_last_position = ref
	

func get_tree_nodes():
	return $tree_nodes.get_children()


func reset_transform():
	self.scale = Vector2.ONE
	self.position = Vector2.ZERO
	emit_signal("changed_zoom", self.scale)
