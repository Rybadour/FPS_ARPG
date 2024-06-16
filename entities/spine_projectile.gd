extends RayCast3D
class_name SpineProjectile

const SPEED = 20;
var velocity: Vector3;

func initWithDirection(direction: Vector3):
	global_transform.origin += direction * 0.1;
	velocity = direction * SPEED;

func _process(delta):
	global_transform.origin += velocity * delta;
	var collider = get_collider();
	if collider == null:
		return;
		
	if collider is Enemy:
		(collider as Enemy).onHit(5);
	
	queue_free();
