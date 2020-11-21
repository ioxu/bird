extends Node

func convert_drawing_to_scene( drawing_nodes_path, scene_body_path):
	print("physics_utils.convert_drawing_to_scene drawing_nodes_path ", drawing_nodes_path)
	print("physics_utils.convert_drawing_to_scene scene_body_path ", scene_body_path)


func parse_drawing(anchors: Array = []):
	print("graph_utils.parse_graph, anchors: ", anchors.size(), " ", anchors)
	for a in anchors:
		print("  anchor ", a.get_path())
		var result  = DFS(a)
	
	return {}

func DFS(a):
	print("  DFS")
	print("    root node ", a.get_path())
	var visited := []
	var visited_nodes := []
	var visited_segments := []
	DFS_do(a, null, visited, visited_nodes, visited_segments)
	
func DFS_do(node, previous_segment, visited, visited_nodes, visited_segments):
	# replace array searches (x in Array)
	# with shorter lists
	#print("  DFS_do")
	for s in node.connected_segments:
		#if not(s in visited_segments):
		#print("is s = previous_segment: ", s, " ", previous_segment)
		if s != previous_segment:
			#print("  connected segment ", s, " ", s.get_path())
			visited.append( s )
			visited_segments.append( s )
			for n in s.connected_nodes:
				#if not(n in visited_nodes):
				if n != node:
					#print("  connected node ", n, " ", n.get_path())
					visited.append( n )
					visited_nodes.append(n)
					n.update_label("order", visited_nodes.size() )
					DFS_do(n, s, visited, visited_nodes, visited_segments)


func label_drawing(drawing_nodes_root):
	pass
