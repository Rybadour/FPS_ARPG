extends Panel
class_name GearSlots

signal returnItem(item: RealItem);

var statLabelScene = preload("res://ui/hud/StatLabel.tscn");

@onready var slots: Dictionary = { #SlotType -> GearSlot
	Globals.SlotType.Head: get_node("Head"),
	Globals.SlotType.Weapon: get_node("Weapon"),
	Globals.SlotType.Chest: get_node("Chest"),
	Globals.SlotType.Amulet: get_node("Amulet"),
	Globals.SlotType.Gloves: get_node("Gloves"),
	Globals.SlotType.Ring: get_node("Ring"),
	Globals.SlotType.Boots: get_node("Boots"),
};
@onready var statLabelContainer: GridContainer = get_node("%StatLabels");

var totalStats: Dictionary; #StatType -> float
var statLabels: Dictionary; #StatType -> Label

func getStat(stat: Globals.StatType) -> float:
	return totalStats[stat] if totalStats.has(stat) else 0;


func getStatAsIncrease(stat: Globals.StatType) -> float:
	return 1 + (getStat(stat) / 100);


func assignGear(item: RealItem):
	var slot = slots[item.item.slotType];
	if slot == null:
		return;
	
	addStatsFromItem(item);
	updateStatLabels();
	slot.setItem(item);
	slot.itemTile.connect("transferRequest", Callable(self, "returnItemRequest").bind(item));


func addStatsFromItem(item: RealItem):
	addStats(item.implicits);
	addStats(item.prefixes);
	addStats(item.suffixes);


func addStats(stats: Dictionary):
	for stat in stats.keys():
		var value = totalStats[stat] if totalStats.has(stat) else 0;
		totalStats[stat] = value + stats[stat];


func removeStats(stats: Dictionary):
	for stat in stats.keys():
		if totalStats.has(stat):
			totalStats[stat] -= stats[stat];


func updateStatLabels():
	for stat in totalStats.keys():
		if !statLabels.has(stat):
			statLabels[stat] = statLabelScene.instantiate();
			statLabelContainer.add_child(statLabels[stat]);
		if !statLabels[stat].visible:
			statLabels[stat].visible = true;
			statLabelContainer.add_child(statLabels[stat]);
		if totalStats[stat] <= 0:
			statLabels[stat].visible = false;
			statLabelContainer.remove_child(statLabels[stat]);
		statLabels[stat].text = UIUtils.getModifierText(stat, totalStats[stat]);


func removeGear(slotType: Globals.SlotType):
	var slot = slots[slotType];
	if slot == null:
		return false;
	
	var item = slot.removeItem();
	removeStats(item.implicits);
	removeStats(item.prefixes);
	removeStats(item.suffixes);
	updateStatLabels();
	
	return item;


func isSlotFilled(slotType: Globals.SlotType):
	var slot = slots[slotType];
	if slot == null:
		return false;
	
	return slot.item != null;


func returnItemRequest(item: RealItem):
	returnItem.emit(removeGear(item.item.slotType));
