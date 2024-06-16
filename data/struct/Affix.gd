class_name Affix

var type: Globals.AffixType;
var stat: Globals.StatType;
var tiers: Array[ModifierTier];
var totalWeight: int;

func _init(type: Globals.AffixType, stat: Globals.StatType, tiers: Array[ModifierTier]):
	self.type = type;
	self.stat = stat;
	self.tiers = tiers;
	for tier in tiers:
		totalWeight += tier.weight;
