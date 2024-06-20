extends Control
class_name ItemTile

@onready var textureRect: TextureRect = find_child('TextureRect');
@onready var nameLabel: Label = get_node("MarginContainer/MarginContainer/HBoxContainer/Name");
@onready var implicit1: Label = get_node("MarginContainer/MarginContainer/HBoxContainer/Implicit1");
@onready var implicit2: Label = get_node("MarginContainer/MarginContainer/HBoxContainer/Implicit2");

var item: RealItem;
@export var icon: Texture2D;

signal transferRequest()

# Called when the node enters the scene tree for the first time.
func _ready():
	textureRect.texture = icon;
	if (item != null):
		nameLabel.text = item.fullName;
		nameLabel.add_theme_color_override("font_color", item.rarity.color);
		implicit1.text = UIUtils.getModifierText(item.implicits.keys()[0], item.implicits.values()[0]);
		if item.implicits.size() > 1:
			implicit2.text = UIUtils.getModifierText(item.implicits.keys()[1], item.implicits.values()[1]);


func _gui_input(event):
	if event.is_action_released("transfer_request", true):
		transferRequest.emit();
