extends Node

var commonAffixes: Array[Affix] = [
	Affix.new(Globals.AffixType.Prefix, Globals.StatType.Health, generateAffixTiers(4, 1000, 5, 20, 5)),
	Affix.new(Globals.AffixType.Prefix, Globals.StatType.IncreasedHealth, generateAffixTiers(4, 1000, 5, 20, 5)),
	Affix.new(Globals.AffixType.Prefix, Globals.StatType.IncreasedPhysicalPower, generateAffixTiers(4, 1000, 5, 20, 5)),
	Affix.new(Globals.AffixType.Prefix, Globals.StatType.IncreasedAttackSpeed, generateAffixTiers(4, 1000, 5, 5, 5)),
	Affix.new(Globals.AffixType.Prefix, Globals.StatType.FireDamage, generateAffixTiers(4, 1000, 5, 2, 3)),
	Affix.new(Globals.AffixType.Prefix, Globals.StatType.IncreasedFireDamage, generateAffixTiers(4, 1000, 5, 20, 5)),
];

var weaponItems: Array[Item] = [
	Item.new(
		"Rusty Chisel",
		Globals.SlotType.Weapon, [
			Modifier.new(Globals.StatType.PhysicalPower, [
				ModifierTier.new(1, 5, 8),
			]),
			Modifier.new(Globals.StatType.AttackSpeed, [
				ModifierTier.new(1, 1, 1.25),
			])
		],
		commonAffixes
	)
];

var helmetItems: Array[Item] = [
	Item.new(
		"Baseball Cap",
		Globals.SlotType.Head, [
			Modifier.new(Globals.StatType.ManaCapacity, [
				ModifierTier.new(1, 20, 40),
			])
		],
		commonAffixes
	)
];

var chestItems: Array[Item] = [
	Item.new(
		"Safety Vest",
		Globals.SlotType.Chest, [
			Modifier.new(Globals.StatType.ManaCapacity, [
				ModifierTier.new(1, 20, 40),
			])
		],
		commonAffixes
	)
];

var glovesItems: Array[Item] = [
	Item.new(
		"Fingerless Gloves",
		Globals.SlotType.Gloves, [
			Modifier.new(Globals.StatType.IncreasedAttackSpeed, [
				ModifierTier.new(1, 20, 40),
			])
		],
		commonAffixes
	)
];

var amuletItems: Array[Item] = [
	Item.new(
		"Stinky Lanyard",
		Globals.SlotType.Amulet, [
			Modifier.new(Globals.StatType.FireDamage, [
				ModifierTier.new(1, 5, 10),
			])
		],
		commonAffixes
	)
];

var ringItems: Array[Item] = [
	Item.new(
		"Plastic Ring",
		Globals.SlotType.Ring, [
			Modifier.new(Globals.StatType.FireDamage, [
				ModifierTier.new(1, 5, 10),
			])
		],
		commonAffixes
	)
];

var bootsItems: Array[Item] = [
	Item.new(
		"Sneakers",
		Globals.SlotType.Boots, [
			Modifier.new(Globals.StatType.MovementSpeed, [
				ModifierTier.new(1, 10, 20),
			])
		],
		commonAffixes
	)
];

func generateAffixTiers(numTiers: int, startWeight: int, weightScaling: float, statStart: int, statChange: int):
	var affixes: Array[ModifierTier];
	for i in numTiers:
		affixes.append(ModifierTier.new(startWeight, statStart, statStart + statChange));
		startWeight /= weightScaling;
		statStart += statChange;
	return affixes;
