extends RigidBody3D
class_name Enemy

const DAMAGE_FADE_SPEED = 0.4;

var health: int = 10;
@onready var damageNum: Label3D = $Damage;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func onHit(damage: int):
	health -= damage;
	damageNum.text = str(damage);
	damageNum.modulate = Color.RED;
	damageNum.outline_modulate = Color.BLACK;
	damageNum.scale = Vector3(1, 1, 1);
	var tween = get_tree().create_tween()
	tween.set_parallel(true);
	tween.tween_property(damageNum, "modulate", Color(Color.RED, 0), DAMAGE_FADE_SPEED)
	tween.tween_property(damageNum, "outline_modulate", Color(Color.BLACK, 0), DAMAGE_FADE_SPEED)
	tween.tween_property(damageNum, "scale", Vector3(0.5, 0.5, 0.5), DAMAGE_FADE_SPEED);
