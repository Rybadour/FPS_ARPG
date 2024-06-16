class_name RealItem

var item: Item;
var fullName: String;
var implicits: Dictionary; #StatType -> float
var prefixes: Dictionary; #StatType -> float;
var suffixes: Dictionary; #StatType -> float;
var rarity: RarityConfig;

func _init(item: Item, rarity: RarityConfig):
	self.item = item;
	self.rarity = rarity;
	fullName = item.name;
