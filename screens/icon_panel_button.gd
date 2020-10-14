extends TextureButton

signal button_pressed

export var selected : bool = false
export var temporary : bool = false # fires signals but reverts to previous button

func _ready():
	pass


func _on_toolbar_button_pressed():
	#self.selected = true
	emit_signal("button_pressed", self)

