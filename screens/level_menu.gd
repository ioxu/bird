extends Node2D

onready var active_tool = null
onready var active_tool_label = $active_tool_label

# mouse
var mouse_pressed = false
var mouse_overlapping_areas := []
var mouse_grabbed_areas := []
var mouse_deletable_areas := []
var mouse_status = "none"
var mouse_clicked_pos := Vector2()
var last_mouse_pos := Vector2()
var mouse_drag_offset := Vector2()
var mouse_canvas_click_enabled = true

export(NodePath) var mouse_area_path
onready var mouse_area : Area2D = get_node(mouse_area_path)

# line stuff
onready var line_node_scene = load("res://line_node/line_node.tscn")
onready var line_segment_scene = load("res://line_node/line_segment.tscn")
var last_line_node_activated = null


func _ready():
	print("mouse_area ",mouse_area.get_path())
	active_tool_label.text = "select"
	active_tool = "select"
	self.visible = false


func _input(event):

	if event.is_action_pressed("ui_cancel"):
		self.toggle_visibility()

	if self.visible:
		if event.is_action_pressed("ui_down"):
			print("level_menu down")

		elif event.is_action_pressed("ui_edit_select_point"):
			print("level_menu edit_select_point")
			$tool_panel.switch_to_tool("tool_select")

		elif event.is_action_pressed("ui_edit_add_point"):
			print("level_menu edit_add_point")
			$tool_panel.switch_to_tool("tool_add")

		elif event.is_action_pressed("ui_edit_clear_points"):
			print("level_menu edit_clear_points")
			$tool_panel.switch_to_tool("tool_clear")

		# defined here too because this _input used to
		# consume the event
		elif event is InputEventMouseMotion:
			mouse_area.position = event.position

		# mouse actions
		if event is InputEventMouseButton\
			and event.button_index == BUTTON_LEFT\
			and event.is_pressed()\
			and mouse_status != "dragging":

			mouse_status = "left_clicked"
			mouse_clicked_pos = event.position
			mouse_drag_offset = Vector2(0,0)
			print("mouse_status ", mouse_status)
			for a in mouse_overlapping_areas:
				if "grabbable" in a and a.grabbable:
					mouse_grabbed_areas.append(a)
			mouse_left_clicked(mouse_clicked_pos)

		# middle mouse
		if event is InputEventMouseButton\
			and event.button_index == BUTTON_MIDDLE\
			and event.is_pressed():
			
			mouse_clicked_pos = event.position
			mouse_status = "middle_clicked"
			print("mouse_status ", mouse_status)
			mouse_middle_clicked(event.position)

		# right mouse
		if event is InputEventMouseButton\
			and event.button_index == BUTTON_RIGHT\
			and event.is_pressed()\
			and mouse_status != "dragging":

			mouse_status = "right_clicked"
			mouse_clicked_pos = event.position
			mouse_drag_offset = Vector2(0,0)
			print("mouse_status ", mouse_status)
			for a in mouse_overlapping_areas:
				if "deletable" in a and a.deletable:
					mouse_deletable_areas.append(a)
			mouse_right_clicked(mouse_clicked_pos)

		if mouse_status=="left_clicked" and event is InputEventMouseMotion:
			mouse_status = "dragging"
			print("mouse_status ", mouse_status)

		if (mouse_status == "dragging"\
				or mouse_status == "left_clicked"\
				or mouse_status == "right_clicked")\
				and event is InputEventMouseButton\
				and (event.button_index == BUTTON_LEFT\
				or event.button_index == BUTTON_RIGHT):
			
			if not event.is_pressed():
				mouse_status = "released"
				print("mouse_status ", mouse_status)
				mouse_grabbed_areas.clear()
				mouse_deletable_areas.clear()
				print("mouse_deletable_areas ", mouse_deletable_areas)
				
		# consume all input
		#get_tree().set_input_as_handled()

func _process(delta):
	if active_tool == "select":
		if mouse_status == "dragging":
			mouse_drag_offset = mouse_clicked_pos - mouse_area.position
			for a in mouse_grabbed_areas:
				a.translate(  - (last_mouse_pos - mouse_area.position) )

	last_mouse_pos = mouse_area.position


func mouse_middle_clicked(pos):
	if active_tool == "add":
		# from last_line_node_activated, find connected segments
		# from area, find connected segments
		# if not in, then create new segment
		
		if mouse_overlapping_areas.size() > 0:
			var area = mouse_overlapping_areas[0].shape_owner_get_owner(0).get_parent()
			if area.get("builder_node_type") and area.builder_node_type == "line_node":
				for s in last_line_node_activated.connected_segments:
					if s in area.connected_segments:
						print("s == s ", s )
						return
				#print("connect to ", area.get_path())
				var line_segment = line_segment_scene.instance()
				line_segment.set("from_line_node_path", last_line_node_activated.get_path() )
				line_segment.set("to_line_node_path", area.get_path() )				
				$tree_nodes.add_child(line_segment)
				last_line_node_activated.connect_segment( line_segment )
				area.connect_segment( line_segment )
				print("line_node ",last_line_node_activated.get_name()," segments ", last_line_node_activated.connected_segments)

func mouse_right_clicked(pos):
	if active_tool == "add":
		for a in mouse_deletable_areas:
			print("about to destroy ",a.get_path())
			if is_instance_valid(a):
				a.destroy()


func mouse_left_clicked(pos):
	if active_tool == "add" and mouse_canvas_click_enabled:
		# check if mouse is overlapping a line_node
		if mouse_overlapping_areas.size() > 0:
			#mark overlapped node as parent, connect-to
			var area = mouse_overlapping_areas[0].shape_owner_get_owner(0).get_parent()
			
			# left click on line_node
			if area.get("builder_node_type") and area.builder_node_type == "line_node":
				print(" add click builder_node_type ",area.get_path())

				if area.get_activated():
					print("DEACTIVATE")
					area.set_deactivated()
					last_line_node_activated = null
				else:
					print("ACTIVATE")
					if is_instance_valid(last_line_node_activated):
						last_line_node_activated.set_deactivated()
					last_line_node_activated = area
					last_line_node_activated.set_activated()
			
			# left click on line_segment, insert point
			elif area.get("builder_node_type") and area.builder_node_type == "line_segment":
				var area_owner = area.shape_owner_get_owner(0).get_owner()
				var in_node = area.from_line_node
				var out_node = area.to_line_node
				var segment_insert_pos = area_owner.get_node("insert_point_marker").get_global_position()
				print("CLICK LINE_SEGMENT ", area_owner.get_path() )
				
				if is_instance_valid(area):
					area.destroy()
					
				#new line_node
				var line_node = line_node_scene.instance()
				line_node.set_global_position( segment_insert_pos )
				$tree_nodes.add_child(line_node)
				line_node.set_activated()
				
				if is_instance_valid(last_line_node_activated):
					last_line_node_activated.set_deactivated()
					var line_segment = line_segment_scene.instance()
					# segment 0
					line_segment.set("from_line_node_path", in_node.get_path() )
					line_segment.set("to_line_node_path", line_node.get_path() )				
					$tree_nodes.add_child(line_segment)
					in_node.connect_segment( line_segment )
					line_node.connect_segment( line_segment )

					# segment 1
					line_segment = line_segment_scene.instance()
					line_segment.set("from_line_node_path", line_node.get_path() )
					line_segment.set("to_line_node_path", out_node.get_path() )				
					$tree_nodes.add_child(line_segment)
					line_node.connect_segment( line_segment )
					out_node.connect_segment( line_segment )

				last_line_node_activated = line_node
				
				
		else:
			# blank space, add new node and segment
			var line_node = line_node_scene.instance()
			line_node.set_global_position( mouse_area.position )
			$tree_nodes.add_child(line_node)
			line_node.set_activated()
			
			if is_instance_valid(last_line_node_activated):
				last_line_node_activated.set_deactivated()
				var line_segment = line_segment_scene.instance()
				# connect
				line_segment.set("from_line_node_path", last_line_node_activated.get_path() )
				line_segment.set("to_line_node_path", line_node.get_path() )				
				$tree_nodes.add_child(line_segment)
				line_node.connect_segment( line_segment )
				last_line_node_activated.connect_segment( line_segment )

			print("line_node ",line_node.get_name()," segments ", line_node.connected_segments)
			last_line_node_activated = line_node


func _on_mouse_area_area_shape_entered(area_id, area, area_shape, self_shape):
	if self.visible:
		var shape_owner = area.shape_owner_get_owner(area_shape).get_owner()
		print("mouse entered ", shape_owner.get_path())
		mouse_overlapping_areas.append( shape_owner )
	

func _on_mouse_area_area_shape_exited(area_id, area, area_shape, self_shape):
	if self.visible:
		var shape_owner = area.shape_owner_get_owner(area_shape).get_owner()
		print("mouse exited ", shape_owner.get_path())
		mouse_overlapping_areas.remove(mouse_overlapping_areas.find(shape_owner))


func _on_tool_panel_mouse_entered():
	mouse_canvas_click_enabled = false


func _on_tool_panel_mouse_exited():
	mouse_canvas_click_enabled = true


func toggle_visibility():
	self.visible = !self.visible


func _on_tool_panel_on_tool_changed(_tool):
	active_tool = _tool
	active_tool.erase(0,5)
	active_tool_label.text = active_tool
	print("active tool:", active_tool)
	
	if active_tool == "clear":
		print("  CLEAR ALL POINTS")
		last_line_node_activated = null
		for i in $tree_nodes.get_children():
			i.queue_free()

