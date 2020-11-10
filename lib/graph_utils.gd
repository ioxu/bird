extends Node

func convert_drawing_to_scene( drawing_nodes_path, scene_body_path):
	print("physics_utils.convert_drawing_to_scene drawing_nodes_path ", drawing_nodes_path)
	print("physics_utils.convert_drawing_to_scene scene_body_path ", scene_body_path)


func parse_drawing(drawing_nodes_root):
	#print("physics_utils.parse_graph drawing_nodes_path ", drawing_nodes_root)
	var anchors := []
	for i in drawing_nodes_root.get_children():
		if i.builder_node_type == "line_node":
			if i.anchor:
				anchors.append(i)

	#print("parse_drawing.anchors ", anchors)

func label_drawing(drawing_nodes_root):
	pass
