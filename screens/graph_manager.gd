extends Node

const GraphUtils = preload("res://lib/graph_utils.gd")
onready var graph_utils = GraphUtils.new()

# members
var anchors := []
var structure = {}

func _ready():
	pass


func _on_line_node_moved(node, vec):
	#print("graph_manager _on_line_node_moved ", node, " ", vec)
	pass


func _on_topology_changed():
	# walk tree(s) and cache structure
	print("graph_manager _on_topology_changed .. updating")
	structure = graph_utils.parse_drawing( anchors )


func add_anchor(node):
	if anchors.find(node) == -1:
		anchors.append(node)
		self._on_topology_changed()


func remove_anchor(node):
	print("graph_manager remove_anchor ", node)
	anchors.remove(anchors.find(node))
	self._on_topology_changed()


