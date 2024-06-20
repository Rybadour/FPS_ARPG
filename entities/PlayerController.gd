extends CharacterBody3D
class_name PlayerController

var spineScene = preload("./spine_projectile.tscn");

@onready var inventory: InventoryPanel = get_node('../PlayerUI/InventoryPanel');
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
		if pickupTip.droppedItem != null:
			inventory.addItemToList(pickupTip.droppedItem.item);
			pickupTip.unselectItem();
			pickupTip.droppedItem.queue_free();

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
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# Shooting
	if Input.is_action_just_pressed("game_shoot"):
		var mouse = get_viewport().get_mouse_position();
		var spineDirection = cam.project_ray_normal(mouse);
		
		var newSpine = spineScene.instantiate() as SpineProjectile;
		projectiles.add_child(newSpine);
		newSpine.global_transform = cam.global_transform;
		newSpine.initWithDirection(spineDirection);


func onNearItem(droppedItem: DroppedItem):
	pickupTip.setItem(droppedItem);


func onLeaveItem(droppedItem: DroppedItem):
	pickupTip.unselectItem();
