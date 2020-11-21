extends Area2D

export var grabbable = true
export var deletable = true
export var anchor = false
signal on_moved

var connected_segments = []

var builder_node_type = "line_node"
var activated = false


func _ready():
	$labels/node_label.text = self.get_name()


func connect_segment(segment):
	print("connect segment", segment.get_path(), " to ", self.get_path())
	print("-> connected_segments ", connected_segments)
	connected_segments.append(segment)
	self.translate(Vector2(0,0))

func remove_segment(segment):
	print("remove segement ", segment.get_path(), " from ", self.get_path())
	print("-> connected_segments ", connected_segments)
	var i_segment = connected_segments.find(segment)
	#print("i_segment ", i_segment)
	if i_segment != -1:
		connected_segments.remove(i_segment)
	self.translate(Vector2(0,0))

func set_as_anchor(is_anchor):
	if is_anchor:
		anchor = true
		$Sprite_anchor.show()
	else:
		anchor = false
		$Sprite_anchor.hide()

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
	emit_signal("on_moved", self, self.position)
	update_label_positions()


func update_label(label: String , value ):
	match label:
		"order":
			$labels/graph_labels/PanelContainer/VBoxContainer/order_label.text = "o " + str(value)
		"depth":
			$labels/graph_labels/PanelContainer/VBoxContainer/depth_label.text = "d " + str(value)


func update_label_positions():
	# update labels
	if len(connected_segments) == 0:
		#$labels/order_label.rect_position = Vector2(-20,-20)
		$labels/graph_labels.position = Vector2(-20,-20)
	elif len(connected_segments) > 0:
		var av_vec : Vector2 = Vector2(0,0)
		var n_vectors := 0
		for i in range(len(connected_segments)):
			if connected_segments[i] != null:
				av_vec +=\
					(self.position -\
					get_next_node_by_segment(connected_segments[i]).position).normalized()
				n_vectors += 1
		av_vec = (av_vec / n_vectors).normalized()
		#$labels/order_label.rect_position =\
		$labels/graph_labels.position =\
			av_vec * Vector2( 25, 25) -\
			 ($labels/graph_labels/PanelContainer.rect_size / 2.0)


func get_next_node_by_segment(segment):
	if self == segment.from_line_node:
		return segment.to_line_node
	else:
		return segment.from_line_node


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


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_line_node_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.name == "mouse_area":
		$Sprite_hover.visible = true
		$Sprite.visible = false
		$labels/node_label.visible = true


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_line_node_area_shape_exited(area_id, area, area_shape, self_shape):
	if area.name == "mouse_area":
		$Sprite_hover.visible = false
		$Sprite.visible = true
		$labels/node_label.visible = false
