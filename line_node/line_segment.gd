extends Area2D

var builder_node_type = "line_segment"

export(NodePath) var from_line_node_path
export(NodePath) var to_line_node_path

export var grabbable = false
export var deletable = true

var connected_nodes = []

onready var col_shape = $CollisionShape2D

var from_line_node = null
var to_line_node = null

# graph attributes
var length := 0.0 setget _set_length, _get_length
var direction : Array = [null, null] setget _set_direction, _get_direction# describes the graph walk direction away from anchor


func _ready():
	from_line_node = get_node(from_line_node_path)
	to_line_node = get_node(to_line_node_path)
	$insert_point_marker.visible = false
	if from_line_node:
		print("line_segment._ready from_line_node ", from_line_node.get_path())
		from_line_node.connect("on_moved", self, "_on_line_node_moved")
		_on_line_node_moved(null, Vector2(0,0))
		connected_nodes.append( from_line_node )
	if to_line_node:
		print("line_segment._ready to_line_node ", to_line_node.get_path())
		to_line_node.connect("on_moved", self, "_on_line_node_moved")	
		_on_line_node_moved(null, Vector2(0,0))
		connected_nodes.append( to_line_node )
	print("  ", self," connected_nodes ", self.connected_nodes)
	$labels/transient_labels.visible = false
	$labels/transient_labels/segment_label.text = self.get_name()
	$direction_sprite.visible = false


func destroy():
	set_process_input(false)
	monitoring = false
	monitorable = false
	input_pickable = false
	if is_instance_valid(from_line_node):
		from_line_node.remove_segment(self)
	if is_instance_valid(to_line_node):
		to_line_node.remove_segment(self)
	self.queue_free()
	return true


func _input(event):
		if event is InputEventMouseMotion:
			if is_instance_valid(from_line_node) and is_instance_valid(to_line_node):
				$insert_point_marker.set_global_position(\
					Geometry.get_closest_point_to_segment_2d(\
						get_global_mouse_position(),\
						from_line_node.position,\
						to_line_node.position)\
					)


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_line_node_moved(node, vec):
	if from_line_node and to_line_node:
		var from_node = from_line_node
		var to_node = to_line_node
		var from_to : Vector2 = from_node.position-to_node.position
		self.position = from_node.position + ( to_node.position - from_node.position ) / 2.0
		self.rotation = (from_to).normalized().angle() + PI/2
		col_shape.set_scale( Vector2( 0.5, ((to_node.position - from_node.position).length() -23.0 ) / 20.0 )  )
		$labels.set_global_rotation(0)
		$labels.set_global_position( Vector2( int(position.x), int(position.y)) )
		self.length = from_to.length()
		
		$line2d.points[0] = Vector2(0.0, -length/2.0)
		$line2d.points[1] = Vector2(0.0, length/2.0)




func _set_direction(new_value):
	$direction_sprite.visible = true
	direction = new_value
	if direction[0] == connected_nodes[0]:
		$direction_sprite.flip_v = true
	else:
		$direction_sprite.flip_v = false


func _get_direction():
	return direction


func _set_length(new_value):
	length = new_value
	$labels/transient_labels/length_label.text = "length %0.2f" % length


func _get_length():
	return length


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_line_segment_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.name == "mouse_area":
		if self.get_node("../../").show_insert_point_marker == true:
			$insert_point_marker.visible = true

		$labels/transient_labels.visible = true
		set_process_input(true)


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_line_segment_area_shape_exited(area_id, area, area_shape, self_shape):
	if area.name == "mouse_area":
		if self.get_node("../../").show_insert_point_marker == true:
			$insert_point_marker.visible = false

		$labels/transient_labels.visible = false
		set_process_input(false)
