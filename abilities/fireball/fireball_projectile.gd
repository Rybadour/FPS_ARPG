extends Node3D
class_name FireballProjectile

@onready var body: RigidBody3D = $RigidBody3D;
@onready var explosion: Area3D = $RigidBody3D/Explosion;

const SPEED = 15;

var velocity: Vector3;
var damage: float;
var explodeNextFrame: bool = false;

func _ready():
	body.connect("body_entered", onCollide);

func init(direction: Vector3, damage: float):
	body.apply_impulse(direction * SPEED);
	self.damage = damage;

func onCollide(other: PhysicsBody3D):
	explodeNextFrame = true;
	var bodies = explosion.get_overlapping_bodies();
	for body in bodies:
		if body is Enemy:
			(body as Enemy).onHit(damage);
	queue_free(); 

func _physics_process(delta):
	if !explodeNextFrame:
		return;
	
	
