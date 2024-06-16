extends CharacterBody3D
class_name Enemy

@onready var effects: EnemyOnHitEffects = $EnemyOnHitEffects;
@onready var navAgent: NavigationAgent3D = $NavigationAgent3D;

const SPEED = 3;

var health: int = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if navAgent.is_navigation_finished() || navAgent.distance_to_target() <= navAgent.target_desired_distance:
		return
	
	var current = global_transform.origin;
	var next = navAgent.get_next_path_position();
	var newVelocity = (next - current).normalized() * SPEED;
	
	velocity = newVelocity;
	move_and_slide();

func onHit(damage: int):
	health -= damage;
	effects.onHit(damage);

func updateTarget(target: Vector3):
	navAgent.target_position = target;
