extends PanelContainer

signal on_tool_changed

# only one button on this panel can be in pressed state

onready var toolbar_buttons = $MarginContainer/VBoxContainer.get_children()

onready var normal_tex = load("res://screens/edit_mode_edit.png")
onready var hover_tex = load("res://screens/edit_mode_edit_hover.png")
onready var selected_tex = load("res://screens/edit_mode_edit_selected.png")
onready var selected_hover_tex = load("res://screens/edit_mode_edit_selected_hover.png")

var selected_tool = null
var previous_tool = null

func _ready():
	print("icons:")
	for b in toolbar_buttons:
		if b is TextureButton:
			print("  ", b.name)
			b.connect("button_pressed", self, "_on_button_pressed")
	
	toolbar_buttons[0].selected = true
	toolbar_buttons[0].texture_normal = selected_tex
	toolbar_buttons[0].texture_hover = selected_tex

func _on_button_pressed(button):
	print("tool: ",button.name)
	if button.name != selected_tool:
		emit_signal("on_tool_changed", button.name)
	selected_tool = button.name
	for b in toolbar_buttons:
		# shady
		if b is TextureButton:
			if b.selected:
				previous_tool = b
			b.selected = false
			b.texture_normal = normal_tex
			b.texture_hover = hover_tex
	button.selected = true
	button.texture_normal = selected_tex
	button.texture_hover = selected_tex

	if button.temporary:
		#print("TEMPORARY")
		#print("previous tool ", previous_tool.name)
		previous_tool.selected = true
		previous_tool.texture_normal = selected_tex
		previous_tool.texture_hover = selected_tex
		button.selected = false
		button.texture_normal = normal_tex
		button.texture_hover = hover_tex
		selected_tool = previous_tool.name
		emit_signal("on_tool_changed", previous_tool.name)
		
	#get_tree().set_input_as_handled()
