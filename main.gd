extends Node2D

#onready var level_menu_screen_res = preload("res://screens/level_menu.tscn")
var level_menu = null

func _ready():
#	level_menu = level_menu_screen_res.instance()
#	level_menu.hide()
#	self.add_child(level_menu)
	pass

func _process(_delta):
	pass


func _input(event):
	if event.is_action_pressed("ui_reload"):
		print("RESET")
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()

	if event.is_action_pressed("ui_down"):
		print("main dwon")

#	if event.is_action_pressed("ui_cancel"):
#		# TODO: go to level menu
#		#get_tree().quit()
#		level_menu.toggle_visibility()

func get_all_children(node):
	var array = []
	_do_get_all_children(node, array)
	return array


func _do_get_all_children(node, array):
	for N in node.get_children():
		if N.get_child_count() > 0:
			_do_get_all_children(N, array)
		else:
			array.append(N)
	array.append(node)
