extends Area2D

export var grabbable = true

signal on_moved

var builder_node_type = "line_node"
var activated = false

func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func translate(vec):
	#print("line_node translate ", vec)
	.translate(vec)
	emit_signal("on_moved", self.position)
	

func get_activated():
	return self.activated

func set_activated():
	activated = true
	$Sprite.visible = false
	$Sprite_hover.visible = false
	$Sprite_activated.visible = true

func set_deactivated():
	activated = false
	$Sprite.visible = true
	$Sprite_hover.visible = false
	$Sprite_activated.visible = false

func _on_line_node_area_shape_entered(area_id, area, area_shape, self_shape):
	#var entered = shape_owner_get_owner(shape_find_owner(area_shape))
	#var entering = shape_owner_get_owner(shape_find_owner(self_shape))
	#print(area.name, " entered ", entered.get_parent().name)
	if area.name == "mouse_area":
		$Sprite_hover.visible = true
		$Sprite.visible = false


func _on_line_node_area_shape_exited(area_id, area, area_shape, self_shape):
	#var exited = shape_owner_get_owner(shape_find_owner(area_shape))
	#var exiting = shape_owner_get_owner(shape_find_owner(self_shape))
	#print(area.name, " exited ", exited.get_parent().name)
	if area.name == "mouse_area":
		$Sprite_hover.visible = false
		$Sprite.visible = true
