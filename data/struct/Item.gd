class_name Item

var name: String;
var slotType: Globals.SlotType;
var implicits: Array[Modifier];
var affixes: Array[Affix];
var totalWeight: int;

func _init(name: String, slotType: Globals.SlotType, implicits: Array[Modifier], affixes: Array[Affix]):
	self.name = name;
	self.slotType = slotType;
	self.implicits = implicits;
	self.affixes = affixes;
	for affix in affixes:
		totalWeight += affix.totalWeight;
