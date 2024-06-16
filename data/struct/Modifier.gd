class_name Modifier

var stat: Globals.StatType;
var tiers: Array[ModifierTier];
var totalWeight: int;

func _init(stat: Globals.StatType, tiers: Array[ModifierTier]):
	self.stat = stat;
	self.tiers = tiers;
	for tier in tiers:
		totalWeight += tier.weight;
