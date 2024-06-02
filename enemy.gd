extends RigidBody3D
class_name Enemy

@onready var effects: EnemyOnHitEffects = $EnemyOnHitEffects;
var health: int = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func onHit(damage: int):
	health -= damage;
	effects.onHit(damage);
