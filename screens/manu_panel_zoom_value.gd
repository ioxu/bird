extends Label

func _on_worksheet_changed_zoom(value):
	var pc = value.x * 100.0
	self.text = "%d%%"%[pc]
