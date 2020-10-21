extends Area2D

export var grabbable = true
export var deletable = true
signal on_moved

var connected_segments = []

var builder_node_type = "line_node"
var activated = false


#func _ready():
#	pass 


func connect_segment(segment):
	print("connect segment", segment.get_path(), " to ", self.get_path())
	connected_segments.append(segment)


func remove_segment(segment):
	print("remove segement ", segment.get_path(), " from ", self.get_path())	
	connected_segments.remove(connected_segments.find(segment))


func destroy():
	set_process_input(false)
	monitoring = false
	monitorable = false
	input_pickable = false
	var c_s = connected_segments 
	print(self.get_path(), " has n segments ", c_s.size(), " ", c_s)
	for i in range(c_s.size()):
		var o = c_s[i]
		print("destroy segment ", o.get_path())
		c_s[i] = null
		if is_instance_valid(o):
			o.destroy()
	queue_free()

func translate(vec):
	.translate(vec)
	emit_signal("on_moved", self.position)


func get_activated():
	return self.activated


func set_activated():
	activated = true
	$Sprite.visible = false
	$Sprite_hover.visible = false
	$Sprite_activated.visible = true


func set_deactivated():
	activated = false
	$Sprite.visible = true
	$Sprite_hover.visible = false
	$Sprite_activated.visible = false


func _on_line_node_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.name == "mouse_area":
		$Sprite_hover.visible = true
		$Sprite.visible = false


func _on_line_node_area_shape_exited(area_id, area, area_shape, self_shape):
	if area.name == "mouse_area":
		$Sprite_hover.visible = false
		$Sprite.visible = true
