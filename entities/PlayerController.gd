extends CharacterBody3D
class_name PlayerController

var spineScene = preload("./spine_projectile.tscn");

@onready var projectiles: Node3D = get_node('../PlayerProjectiles');
@onready var cam = $Camera3D;

const SPEED = 4.0;
const JUMP_VELOCITY = 5
const CAM_SENSITIVITY = 0.005;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var lastMouse: Vector2;

var platform = OS.get_name();
var activeMouseMode = Input.MOUSE_MODE_CAPTURED;

func _init():
	Input.mouse_mode = activeMouseMode;
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == activeMouseMode:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		else:
			Input.mouse_mode = activeMouseMode;
			
	if event is InputEventMouseMotion && (Input.mouse_mode == activeMouseMode || platform == "Web"):
		self.rotation.y -= event.relative.x * CAM_SENSITIVITY;
		cam.rotation.x -= event.relative.y * CAM_SENSITIVITY;

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
		var newSpine = spineScene.instantiate() as RigidBody3D;
		newSpine.global_transform = cam.get_camera_transform();
		newSpine.rotate_y(PI/2);
		newSpine.apply_impulse(cam.project_ray_normal(mouse) * 10);
		projectiles.add_child(newSpine);
		
		#var origin = cam.project_ray_origin(mouse);
		#var query = PhysicsRayQueryParameters3D.create(origin, origin + cam.project_ray_normal(mouse) * 1000);
		#query.collision_mask = 0b00000000_00000000_00000000_0000100;
		#query.collide_with_bodies = true;
		#var enemy = get_world_3d().direct_space_state.intersect_ray(query);
		#if !enemy.is_empty():
			#var obj = enemy.get('collider');
			#if obj is Enemy:
				#obj.onHit(1);
