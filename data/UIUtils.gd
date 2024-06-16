extends Node
class_name UIUtils

static func comma_sep(number):
	var string = str(number);
	var mod = string.length() % 3;
	var res = "";

	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ",";
		res += string[i];

	return res;


static func getModifierText(stat: Globals.StatType, value: float):
	var text = '';
	if stat == Globals.StatType.PhysicalPower:
		text = "%.0f" % value + ' Physical Damage';
	elif stat == Globals.StatType.IncreasedPhysicalPower:
		text = '+' + "%.0f" % value + '% Physical Damage';
	elif stat == Globals.StatType.AttackSpeed:
		text = "%.2f" % value + ' Attack Speed';
	elif stat == Globals.StatType.IncreasedAttackSpeed:
		text = '+' + "%.0f" % value + '% Attack Speed';
	elif stat == Globals.StatType.Health:
		text = '+' + "%.0f" % value + ' Health';
	elif stat == Globals.StatType.IncreasedHealth:
		text = '+' + "%.0f" % value + '% Health';
	elif stat == Globals.StatType.FireDamage:
		text = '+' + "%.0f" % value + ' Fire Damage';
	elif stat == Globals.StatType.IncreasedFireDamage:
		text = '+' + "%.0f" % value + '% Fire Damage';
	elif stat == Globals.StatType.ManaCapacity:
		text = '+' + "%.0f" % value + ' Mana Capacity';
	elif stat == Globals.StatType.MovementSpeed:
		text = '+' + "%.0f" % value + '% Move Speed';
	return text;

