extends Panel
class_name InventoryPanel

const COLLAPSED_SIZE = 210;
const EXPANDED_SIZE = 455;

var itemTile = preload('res://ui/hud/ItemTile.tscn');

var isExpanded = false;
var items: Array[Item];
@onready var grid: GridContainer = find_child("GridContainer");
@onready var gearSlots: GearSlots = find_child("GearSlots");

var itemTileMap: Dictionary; #Item objectid -> ItemTile;

const activeMouseMode = Input.MOUSE_MODE_CAPTURED;

func _init():
	Input.mouse_mode = activeMouseMode;

# Called when the node enters the scene tree for the fiwrst time.
func _ready():
	custom_minimum_size.x = COLLAPSED_SIZE;
	gearSlots.connect("transferRequest", addItemToList);

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == activeMouseMode:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
			self.visible = true;
			get_tree().paused = true;
		else:
			Input.mouse_mode = activeMouseMode;
			self.visible = false;
			get_tree().paused = false;


func expandToggle():
	if isExpanded:
		custom_minimum_size.x = COLLAPSED_SIZE;
		grid.columns = 1;
		isExpanded = false;
		gearSlots.visible = false;
	else:
		custom_minimum_size.x = EXPANDED_SIZE;
		grid.columns = 3;
		isExpanded = true;
		gearSlots.visible = true;


func pickupItem(item: RealItem):
	if item == null:
		return;
	
	if !gearSlots.isSlotFilled(item.item.slotType):
		gearSlots.assignGear(item);
		return;
	
	addItemToList(item);


func addItemToList(item: RealItem):
	items.append(item);
	var tile: ItemTile = itemTile.instantiate();
	tile.item = item;
	tile.connect("transferRequest", Callable(self, "transferGearToSlot").bind(item));
	grid.add_child(tile);
	itemTileMap[item.get_instance_id()] = tile;


func transferGearToSlot(item: RealItem):
	if gearSlots.isSlotFilled(item.item.slotType):
		var oldItem = gearSlots.removeGear(item.item.slotType);
		addItemToList(oldItem);
	
	gearSlots.assignGear(item);

	var tile = itemTileMap[item.get_instance_id()];
	grid.remove_child(tile);
	tile.queue_free();
	itemTileMap.erase(item.get_instance_id());
