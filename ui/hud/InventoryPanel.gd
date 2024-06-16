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

# Called when the node enters the scene tree for the first time.
func _ready():
	custom_minimum_size.x = COLLAPSED_SIZE;
	gearSlots.connect("returnItem", addItemToList);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
