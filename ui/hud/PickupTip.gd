extends Control
class_name PickupTip

@onready var itemName: Label = $ItemName;
var droppedItem: DroppedItem;

func setItem(item: DroppedItem):
	droppedItem = item;
	itemName.text = droppedItem.item.fullName;
	visible = true;


func unselectItem():
	itemName.text = '';
	visible = false;
