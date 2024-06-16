extends ColorRect
class_name GearSlot

var itemTileScene = preload('res://ui/hud/ItemTile.tscn');

@onready var container: MarginContainer = get_node("MarginContainer");

var item: RealItem;
var itemTile: ItemTile;

func setItem(item: RealItem):
	itemTile = itemTileScene.instantiate();
	itemTile.item = item;
	container.add_child(itemTile);
	self.item = item;
	

func removeItem():
	container.remove_child(itemTile);
	itemTile.queue_free();
	var item = self.item;
	self.item = null;
	return item;
