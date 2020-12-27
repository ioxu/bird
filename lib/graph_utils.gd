extends Node

#var drawing_data := {}

var rng_branch_colour = RandomNumberGenerator.new()

var random_colours := []

func convert_drawing_to_scene( drawing_nodes_path, scene_body_path):
	print("physics_utils.convert_drawing_to_scene drawing_nodes_path ", drawing_nodes_path)
	print("physics_utils.convert_drawing_to_scene scene_body_path ", scene_body_path)


func parse_drawing(anchors: Array = []):
	var drawing_data := {}
	#print("graph_utils.parse_graph, anchors: ", anchors.size(), " ", anchors)
	for a in anchors:
		#print("  anchor ", a.get_path())
		a.order = 0
		a.depth = 0
		#drawing_data[a] =  DFS(a)
		drawing_data[a] =  DFS(a)
	return drawing_data


func DFS(a):
	var visited := []
	var visited_nodes := []
	var visited_segments := []
	var leaves := []
	DFS_do(a, null, 0 , 0.0, visited, visited_nodes, visited_segments, leaves)
	return {"visited": visited,
		"visited_nodes": visited_nodes,
		"visited_segments": visited_segments,
		"leaves": leaves}


func DFS_do(node,
	previous_segment,
	previous_depth,
	previous_distance,
	visited,
	visited_nodes,
	visited_segments,
	leaves):

	node.leaf = false

	if node.connected_segments.size() == 1 and not node.anchor:
		leaves.append(node)
		node.leaf = true
		node.incoming_segment = previous_segment

	if node.anchor:
		node.distance_from_anchor = 0.0

	for s in node.connected_segments:
		if s != previous_segment and is_instance_valid(s):
			visited.append( s )
			visited_segments.append( s )
			for n in s.connected_nodes:
				if n != node:
					visited.append( n )
					visited_nodes.append(n)
					var depth = previous_depth + 1
					var distance = previous_distance + s.length
					n.order = visited_nodes.size()
					n.depth = depth
					n.distance_from_anchor = distance
					n.incoming_segment = s
					s.direction = [ node, n ]
					s.reset_line_widths()
					DFS_do(n, s, depth, distance, visited, visited_nodes, visited_segments, leaves)


class DistanceToAnchorSorter:
	static func sort_descending(a,b):
		if a.distance_from_anchor > b.distance_from_anchor:
			return true
		return false
	static func sort_ascending(a,b):
		if a.distance_from_anchor < b.distance_from_anchor:
			return true
		return false


func set_line_widths(structure):
	# (structure as returned from parse_drawing)
	reset_segments(structure)
	
	for a in structure.keys():
		var sorted_leaves : Array = structure[a].leaves.duplicate()
		# sort leaves by distance_from_anchor, longest to shortest
		sorted_leaves.sort_custom( DistanceToAnchorSorter, "sort_ascending" )

		if sorted_leaves.size() == 0:
			break 
			
		#var longest_distance = sorted_leaves[0].distance_from_anchor
		### TODO: base widths need to be configured elsewhere
		var base_width = 40.0
		var tip_width = 5.0
		
		for l in range(sorted_leaves.size()):
			var stop = false
			var this_node = sorted_leaves[l]
			var this_segment = null
			var limit = 0
			var this_leaf_distance = this_node.distance_from_anchor
			#var branch_colour = get_random_colours()[random_colours.size() - l -1]
			var branch_colour = Color(0.160355, 0.237206, 0.441406)

			while stop != true:
				this_segment = this_node.incoming_segment
				if this_segment.line_widths[0] != null:
					# break and stop setting widths
					break
				this_segment.get_node("line2d").default_color = branch_colour

				var distance_this_node = this_node.distance_from_anchor
				this_node = this_segment.direction[0]
				var distance_next_node = this_node.distance_from_anchor
				var w1 = lerp( base_width, tip_width, distance_this_node / this_leaf_distance )
				var w2 = lerp( base_width, tip_width, distance_next_node / this_leaf_distance )
				this_segment.line_widths = [ w1, w2 ]

				if this_node.anchor == true:
					stop = true

				# TODO: still needed?
				limit += 1
				if limit > 10000:
					break


func reset_segments(structure):
	for a in structure.keys():
		for s in structure[a].visited_segments:
			s.line_widths = [null, null]


func get_random_colours():
	if random_colours.size() != 0:
		return random_colours
	for i in range(60):
		print("get_random_colours ", i)
		random_colours.append(Color(rng_branch_colour.randf(), rng_branch_colour.randf(), rng_branch_colour.randf(), 0.6) )
	return random_colours

