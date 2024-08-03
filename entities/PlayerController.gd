extends CharacterBody3D
class_name PlayerController

var spineScene = preload("../abilities/spines/spine_projectile.tscn");
var fireballScene = preload("../abilities/fireball/fireball_projectile.tscn");

@onready var inventory: InventoryPanel = get_node('../PlayerUI/InventoryPanel');
@onready var gearSlots: GearSlots = %GearSlots;
@onready var projectiles: Node3D = get_node('../PlayerProjectiles');
@onready var pickupTip: PickupTip = get_node('../PlayerUI/PickupTip');
@onready var cam = $Camera3D;

const SPEED = 4.0;
const JUMP_VELOCITY = 5
const CAM_SENSITIVITY = 0.005;
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var lastMouse: Vector2;
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		self.rotation.y -= event.relative.x * CAM_SENSITIVITY;
		cam.rotation.x -= event.relative.y * CAM_SENSITIVITY;
	
	if Input.is_action_just_pressed("interact_world"):
		if !pickupTip.droppedItems.is_empty():
			for di in pickupTip.droppedItems:
				inventory.addItemToList(di.item);
			pickupTip.removeItems();

func _physics_process(delta):
	get_tree().call_group("enemies", "updateTarget", global_transform.origin);
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var modifiedSpeed = SPEED * gearSlots.getStatAsIncrease(Globals.StatType.MovementSpeed);
	if direction:
		velocity.x = direction.x * modifiedSpeed;
		velocity.z = direction.z * modifiedSpeed;
	else:
		velocity.x = move_toward(velocity.x, 0, modifiedSpeed);
		velocity.z = move_toward(velocity.z, 0, modifiedSpeed);

	move_and_slide()

	# Shooting
	if Input.is_action_just_pressed("game_shoot"):
		var mouse = get_viewport().get_mouse_position();
		var shootDirection = cam.project_ray_normal(mouse);
		
		var newSpine = spineScene.instantiate() as SpineProjectile;
		projectiles.add_child(newSpine);
		newSpine.global_transform = cam.global_transform;
		var modifiedDamage = 4 + gearSlots.getStat(Globals.StatType.PhysicalPower);
		modifiedDamage *= gearSlots.getStatAsIncrease(Globals.StatType.IncreasedPhysicalPower);
		newSpine.init(shootDirection, modifiedDamage);
		
		#var newFireball = fireballScene.instantiate() as FireballProjectile;
		#projectiles.add_child(newFireball);
		#newFireball.global_transform = cam.global_transform;
		#var modifiedDamage = 4 + gearSlots.getStat(Globals.StatType.PhysicalPower);
		#modifiedDamage *= gearSlots.getStatAsIncrease(Globals.StatType.IncreasedPhysicalPower);
		#newFireball.init(shootDirection, modifiedDamage); 


func onNearItem(droppedItem: DroppedItem):
	pickupTip.setItem(droppedItem);


func onLeaveItem(droppedItem: DroppedItem):
	pickupTip.unselectItem(droppedItem);
