extends Node

func convert_drawing_to_scene( drawing_nodes_path, scene_body_path):
	print("physics_utils.convert_drawing_to_scene drawing_nodes_path ", drawing_nodes_path)
	print("physics_utils.convert_drawing_to_scene scene_body_path ", scene_body_path)


func parse_drawing(anchors: Array = []):
	print("graph_utils.parse_graph, anchors: ", anchors.size(), " ", anchors)
	for a in anchors:
		print("  anchor ", a.get_path())
		a.update_label("order", 0 )
		a.update_label("depth", 0 )
		var _result  = DFS(a)
		#print("  result: ", result)
	return {}


func DFS(a):
	var visited := []
	var visited_nodes := []
	var visited_segments := []
	DFS_do(a, null, 0 , visited, visited_nodes, visited_segments)
	return {"visited": visited,
		"visited_nodes": visited_nodes,
		"visited_segments": visited_segments}


func DFS_do(node, previous_segment, previous_depth , visited, visited_nodes, visited_segments):
	for s in node.connected_segments:
		if s != previous_segment:
			visited.append( s )
			visited_segments.append( s )
			for n in s.connected_nodes:
				if n != node:
					visited.append( n )
					visited_nodes.append(n)
					n.update_label("order", visited_nodes.size() )
					var depth = previous_depth + 1
					n.update_label("depth", depth )
					DFS_do(n, s, depth, visited, visited_nodes, visited_segments)

