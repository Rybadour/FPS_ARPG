extends Control
class_name PickupTip

@onready var itemsText: Label = $ItemsText;
var droppedItems: Array[DroppedItem];

func setItem(item: DroppedItem):
	droppedItems.append(item);
	updateText();
	visible = true;


func unselectItem(item: DroppedItem):
	droppedItems.remove_at(droppedItems.find(item));
	updateText();
	visible = droppedItems.size();


func removeItems():
	for di in droppedItems:
		di.queue_free();
	droppedItems.clear();
	visible = false;


func updateText():
	var text = '';
	for di in droppedItems:
		if text != '':
			text += ', ';
		text += di.item.fullName;
	
	itemsText.text = text;
