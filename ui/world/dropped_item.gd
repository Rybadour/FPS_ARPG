extends Node3D
class_name DroppedItem

const DELAY = 0.2;
const BOUNCE_TIME = 0.7;
const SPIN_TIME = 1.6;

var helmet = preload("res://entities/equipment/helmet.tscn");
var sword = preload("res://entities/equipment/sword.tscn");
var chest = preload("res://entities/equipment/chest.tscn");
var gloves = preload("res://entities/equipment/gloves.tscn");
var amulet = preload("res://entities/equipment/amulet.tscn");
var ring = preload("res://entities/equipment/ring.tscn");
var boots = preload("res://entities/equipment/boots.tscn");

@onready var itemContainer: Node3D = $Item;

var item: RealItem;

# Called when the node enters the scene tree for the first time.
func _ready():
	var rotTween = get_tree().create_tween();
	rotTween.tween_property(itemContainer, "rotation", Vector3(0, TAU, 0), SPIN_TIME).as_relative();
	rotTween.set_loops();
	
	var tween = get_tree().create_tween();
	tween.set_ease(Tween.EASE_IN_OUT);
	tween.set_trans(Tween.TRANS_SINE);
	tween.tween_property(itemContainer, "transform:origin", Vector3(0, 0.3, 0), BOUNCE_TIME);
	tween.tween_property(itemContainer, "transform:origin", Vector3(0, 0.05, 0), BOUNCE_TIME);
	tween.set_loops();

func setItem(newItem: RealItem):
	item = newItem;
	var itemModel;
	if item.item.slotType == Globals.SlotType.Head:
		itemModel = helmet.instantiate();
	elif item.item.slotType == Globals.SlotType.Weapon:
		itemModel = sword.instantiate();
	elif item.item.slotType == Globals.SlotType.Chest:
		itemModel = chest.instantiate();
	elif item.item.slotType == Globals.SlotType.Gloves:
		itemModel = gloves.instantiate();
	elif item.item.slotType == Globals.SlotType.Amulet:
		itemModel = amulet.instantiate();
	elif item.item.slotType == Globals.SlotType.Ring:
		itemModel = ring.instantiate();
	elif item.item.slotType == Globals.SlotType.Boots:
		itemModel = boots.instantiate();
	itemContainer.add_child(itemModel);
