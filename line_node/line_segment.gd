extends Area2D

export(NodePath) var from_line_node_path
export(NodePath) var to_line_node_path

export var grabbable = false
export var deletable = false

var builder_node_type = "line_segment"

onready var col_shape = $CollisionShape2D

var from_line_node = null
var to_line_node = null

func _ready():
	from_line_node = get_node(from_line_node_path)
	print("from_line_node ", from_line_node)
	to_line_node = get_node(to_line_node_path)
	print("to_line_node ", to_line_node)
	
	$insert_point_marker.visible = false
	
	if from_line_node:
		from_line_node.connect("on_moved", self, "_on_line_node_moved")
		_on_line_node_moved(Vector2(0,0))
	if to_line_node:
		to_line_node.connect("on_moved", self, "_on_line_node_moved")	
		_on_line_node_moved(Vector2(0,0))


func destroy():
	monitoring = false
	monitorable = false
	input_pickable = false
	self.queue_free()

func _input(event):
	#if $insert_point_marker.visible:
		if event is InputEventMouseMotion:
			$insert_point_marker.set_global_position(\
				Geometry.get_closest_point_to_segment_2d(\
					get_global_mouse_position(),\
					from_line_node.position,\
					to_line_node.position)\
				)
		
	#get_global_mouse_pos()


func _on_line_node_moved(vec):
	var from_node = from_line_node
	var to_node = to_line_node
	self.position = from_node.position + ( to_node.position - from_node.position ) / 2.0
	self.rotation = (from_node.position-to_node.position).normalized().angle() + PI/2
	col_shape.set_scale( Vector2( 0.5, ((to_node.position - from_node.position).length() -23.0 ) / 20.0 )  )
	#col_shape.shape.extents = Vector2(10, (to_node.position - from_node.position).length() )


func _on_line_segment_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.name == "mouse_area":
		$insert_point_marker.visible = true

func _on_line_segment_area_shape_exited(area_id, area, area_shape, self_shape):
	if area.name == "mouse_area":
		$insert_point_marker.visible = false
