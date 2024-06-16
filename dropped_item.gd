extends Node3D

var helmet = preload("res://assets/FBX Isolated/Armour/Helmet_1.fbx");

@onready var item: Node3D = $Item;
const DELAY = 0.2;
const BOUNCE_TIME = 0.7;
const SPIN_TIME = 1.6;

# Called when the node enters the scene tree for the first time.
func _ready():
	var rotTween = get_tree().create_tween();
	rotTween.tween_property(item, "rotation", Vector3(0, TAU, 0), SPIN_TIME).as_relative();
	rotTween.set_loops();
	
	var tween = get_tree().create_tween();
	tween.set_ease(Tween.EASE_IN_OUT);
	tween.set_trans(Tween.TRANS_SINE);
	tween.tween_property(item, "transform:origin", Vector3(0, 0.3, 0), BOUNCE_TIME);
	tween.tween_property(item, "transform:origin", Vector3(0, 0.05, 0), BOUNCE_TIME);
	tween.set_loops();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
