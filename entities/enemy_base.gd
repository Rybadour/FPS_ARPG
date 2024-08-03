extends CharacterBody3D
class_name Enemy

@onready var effects: EnemyOnHitEffects = $Body/EnemyOnHitEffects;
@onready var navAgent: NavigationAgent3D = $NavigationAgent3D;
@onready var body: Node3D = $Body;
@onready var corpseShape: CollisionShape3D = $CorpseShape;

const SPEED = 3;

var health: float = 10;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if navAgent.is_navigation_finished() || navAgent.distance_to_target() <= navAgent.target_desired_distance:
		return
	
	var current = global_transform.origin;
	var next = navAgent.get_next_path_position();
	var newVelocity = (next - current).normalized() * SPEED;
	
	velocity = newVelocity;
	look_at(next);
	move_and_slide();


func onHit(damage: float, globalHitSpot: Vector3 = effects.global_position):
	health -= damage;
	
	effects.onHit(damage, globalHitSpot);
	
	if health <= 0:
		GlobalSignals.emit_signal("EnemyDies", transform.origin, 1);
		var corpse = RigidBody3D.new();
		corpseShape.reparent(corpse);
		body.reparent(corpse);
		get_parent().add_child(corpse);
		corpseShape.disabled = false;
		corpse.apply_impulse(Vector3(0, 1, -0.3));
		queue_free();


func updateTarget(target: Vector3):
	navAgent.target_position = target;


func getIsPassive():
	return true;
