extends ItemList

var toolbar_items = ["select", "add point"]

func _ready():
	for item_id in range(toolbar_items.size()):
		add_item( toolbar_items[item_id], null, true )
		select(0,true)


