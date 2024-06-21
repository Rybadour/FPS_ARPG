extends RayCast3D
class_name SpineProjectile

const SPEED = 20;

var velocity: Vector3;
var damage: float;

func init(direction: Vector3, damage: float):
	global_transform.origin += direction * 0.1;
	velocity = direction * SPEED;
	self.damage = damage;

func _process(delta):
	global_transform.origin += velocity * delta;
	var collider = get_collider();
	if collider == null:
		return;
		
	if collider is Enemy:
		(collider as Enemy).onHit(damage);
	
	queue_free();
