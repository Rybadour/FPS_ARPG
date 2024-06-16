extends RigidBody3D
class_name HopperEnemy

@onready var effects: EnemyOnHitEffects = $EnemyOnHitEffects;
@onready var navAgent: NavigationAgent3D = $NavigationAgent3D;

const SPEED = 3;

var health: int = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func onHit(damage: int):
	health -= damage;
	effects.onHit(damage);

func _physics_process(delta):
	if !navAgent.is_target_reachable() || navAgent.is_navigation_finished():
		return
	
	var current = global_transform.origin;
	var next = navAgent.get_next_path_position();
	var newVelocity = (next - current).normalized() * SPEED * delta; 
	
	move_and_collide(newVelocity);
	
func updateTarget(target: Vector3):
	navAgent.target_position = target;
