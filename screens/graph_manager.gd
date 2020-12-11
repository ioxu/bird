extends Node

const GraphUtils = preload("res://lib/graph_utils.gd")
onready var graph_utils = GraphUtils.new()

# members
var anchors := []
var structure = {}

func _ready():
	pass


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_line_node_moved(node, vec):
	structure = graph_utils.parse_drawing( anchors )
	graph_utils.set_line_widths(structure)


func _on_topology_changed():
	# walk tree(s) and cache structure
	print("graph_manager _on_topology_changed .. updating")
	structure = graph_utils.parse_drawing( anchors )


func add_anchor(node):
	if anchors.find(node) == -1:
		anchors.append(node)
		self._on_topology_changed()


func remove_anchor(node):
	anchors.remove(anchors.find(node))
	print("graph_manager remove_anchor ", node, " ", anchors)
	self._on_topology_changed()


