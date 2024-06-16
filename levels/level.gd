extends Node3D
class_name Level

var lootGen: LootGeneration = LootGeneration.new();
var droppedItemScene = preload("res://ui/world/dropped_item.tscn");

@onready var droppedLoot: Node3D = $DroppedLoot;
@onready var enemies: Node3D = $Enemies;

func _ready():
	GlobalSignals.connect("EnemyDies", onEnemyDies);


func onEnemyDies(pos: Vector3, level: int):
	var itemConfig = lootGen.generateItem();
	if itemConfig == null:
		return;

	var item = droppedItemScene.instantiate() as DroppedItem;
	droppedLoot.add_child(item);
	item.setItem(itemConfig);
	item.transform.origin = pos;
