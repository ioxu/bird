extends Node

func convert_drawing_to_scene( drawing_nodes_path, scene_body_path):
	print("physics_utils.convert_drawing_to_scene drawing_nodes_path ", drawing_nodes_path)
	print("physics_utils.convert_drawing_to_scene scene_body_path ", scene_body_path)


func parse_drawing(anchors: Array = []):
	print("graph_utils.parse_graph, anchors: ", anchors.size(), " ", anchors)
	for a in anchors:
		print("  anchor ", a.get_path())
	
	# walk graph from anchors
	#if i.builder_node_type == "line_node":
	
	return {}


func label_drawing(drawing_nodes_root):
	pass
