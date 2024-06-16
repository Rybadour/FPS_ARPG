class_name LootGeneration

var rand = RandomNumberGenerator.new();

const ITEM_FROM_ROCK_CHANCE = 1;

var rarities: Dictionary = {
	Globals.ItemRarity.Common: RarityConfig.new(100, 0, Color(255, 255, 255)),
	Globals.ItemRarity.Magic: RarityConfig.new(30, 2, Color(0, 83, 255)),
	Globals.ItemRarity.Rare: RarityConfig.new(10, 4, Color(255, 255, 0)),
};
var totalRarityWeight: int;

func _init():
	for rarity in rarities.values():
		totalRarityWeight += rarity.weight;

var possibleItems: Dictionary = {
	Globals.SlotType.Weapon: ItemConfig.weaponItems,
	Globals.SlotType.Head: ItemConfig.helmetItems,
	Globals.SlotType.Chest: ItemConfig.chestItems,
	Globals.SlotType.Amulet: ItemConfig.amuletItems,
	Globals.SlotType.Ring: ItemConfig.ringItems,
	Globals.SlotType.Gloves: ItemConfig.glovesItems,
	Globals.SlotType.Boots: ItemConfig.bootsItems,
};

func generateLootFromRock():
	if rand.randf() <= ITEM_FROM_ROCK_CHANCE:
		return generateItem();


func generateItem() -> RealItem:
	var itemType = rand.randi_range(0, Globals.SlotType.values().size()-1);
	var itemIndex = rand.randi_range(0, possibleItems[itemType].size()-1);

	var rarityWeight = rand.randi_range(0, totalRarityWeight - 1);
	var chosenRarity: RarityConfig;
	for rarity in rarities.keys():
		if rarities[rarity].weight >= rarityWeight:
			chosenRarity = rarities[rarity];
			break;
		else:
			rarityWeight -= rarities[rarity].weight;

	if chosenRarity != null:
		return generateItemWithStats(possibleItems[itemType][itemIndex], chosenRarity);
	else:
		return null;


func generateItemWithStats(item: Item, rarity: RarityConfig) -> RealItem:
	var realItem = RealItem.new(item, rarity);
	# Roll implicits
	for implicit in item.implicits:
		realItem.implicits[implicit.stat] = generateModifierAmount(implicit.tiers, rand.randi_range(0, implicit.totalWeight));
	
	var affixesAlreadyFound: Array[String];
	for i in rarity.numAffixes:
		var roll = rand.randi_range(0, item.totalWeight);
		for affix in item.affixes:
			if roll < affix.totalWeight:
				var statVal = generateModifierAmount(affix.tiers, roll);
				if affix.type == Globals.AffixType.Prefix:
					realItem.prefixes[affix.stat] = statVal;
				else:
					realItem.suffixes[affix.stat] = statVal;
				break;
				
			else:
				roll -= affix.totalWeight;

	return realItem;


func generateModifierAmount(tiers: Array[ModifierTier], relativeRoll: int):
	for tier in tiers:
		if relativeRoll <= tier.weight:
			return rand.randf_range(tier.statMin, tier.statMax);
		else:
			relativeRoll -= tier.weight;
