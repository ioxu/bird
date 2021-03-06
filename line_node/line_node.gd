extends Area2D

var builder_node_type = "line_node"

export var grabbable = true
export var deletable = true
export var anchor = false
export var leaf = false setget _set_leaf, _get_leaf
signal on_moved

var connected_segments = []
var incoming_segment = null

var activated = false

# graph attributes
var distance_from_anchor := 0.0 setget _set_distance_from_anchor, _get_distance_from_anchor
var order := 0 setget _set_order, _get_order
var depth := 0 setget _set_depth, _get_depth

func _ready():
	$labels/transient_labels/node_label.text = self.get_name()
	$labels/transient_labels/node_instance_name_label.text = str(self)
	self.distance_from_anchor = 0.0


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


func _set_order(new_value):
	order = new_value
	$labels/transient_labels/order_label.text = "order %d" % order
	#$labels/graph_labels/PanelContainer.rect_size = Vector2(0,0)
	#update_label_positions()


func _get_order():
	return order


func _set_depth(new_value):
	depth = new_value
	$labels/graph_labels/PanelContainer/VBoxContainer/depth_label.text = "d %d" % depth
	$labels/graph_labels/PanelContainer.rect_size = Vector2(0,0)
	update_label_positions()


func _get_depth():
	return depth


func update_label_positions():
	if len(connected_segments) == 0:
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
		$labels/graph_labels/PanelContainer.rect_size = Vector2(0,0)
		$labels/graph_labels.position =\
			av_vec * Vector2( 20, 20) -\
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
		$labels/transient_labels.visible = true


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_line_node_area_shape_exited(area_id, area, area_shape, self_shape):
	if area.name == "mouse_area":
		$Sprite_hover.visible = false
		$Sprite.visible = true
		$labels/transient_labels.visible = false


func _set_distance_from_anchor(new_value):
	distance_from_anchor = new_value
	$labels/transient_labels/distance_from_anchor_label.text = "distance %0.2f" % distance_from_anchor


func _get_distance_from_anchor():
	return distance_from_anchor


func _set_leaf(new_value):
	leaf = new_value
	$Sprite_leaf.visible = new_value
	
func _get_leaf():
	return leaf
