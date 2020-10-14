extends Area2D

export(NodePath) var from_line_node_path
export(NodePath) var to_line_node_path

export var grabbable = false
export var deletable = false

var builder_node_type = "line_segment"

onready var col_shape = $CollisionShape2D

var from_line_node
var to_line_node

func _ready():
	from_line_node = get_node(from_line_node_path)
	print("from_line_node ", from_line_node)
	to_line_node = get_node(to_line_node_path)
	print("to_line_node ", to_line_node)
	
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


func _on_line_node_moved(vec):
	var from_node = from_line_node
	var to_node = to_line_node
	self.position = from_node.position + ( to_node.position - from_node.position ) / 2.0
	self.rotation = (from_node.position-to_node.position).normalized().angle() + PI/2
	col_shape.set_scale( Vector2( 0.5, ((to_node.position - from_node.position).length() -15.0 ) / 20.0 )  )
	#col_shape.shape.extents = Vector2(10, (to_node.position - from_node.position).length() )
