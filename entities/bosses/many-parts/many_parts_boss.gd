extends Node3D

var outerLayerScene = preload("res://entities/bosses/many-parts/outer-layer-box.tscn");

const NUM_OUTER = 30;
const OUTER_RADIUS = 7;
const OUTER_ROTATE_TIME = 4;

@onready var outerLayers: Array[Node3D] = [
	$OuterLayer,
	$OuterLayer2,
	$OuterLayer3,
];

func _ready():
	outerLayers[1].rotate_z(PI/3);
	outerLayers[2].rotate_z(-PI/3);
	
	var i = 0;
	for outerLayer in outerLayers:
		generateOrbital(outerLayer, outerLayerScene, NUM_OUTER, OUTER_RADIUS + i * 0.3);
		i += 1;


func generateOrbital(container: Node3D, prefab: Resource, num: int, radius: float):
	for i in num:
		var part: Node3D = prefab.instantiate();
		container.add_child(part);
		var angle = i * (PI * 2 / num);
		var direction = Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), angle);
		part.transform.origin = (direction * radius);
		part.rotation = Vector3(0, angle, 0);
		
	var tween = get_tree().create_tween();
	var newRotation = container.rotation;
	newRotation.y = TAU;
	tween.tween_property(container, "rotation", newRotation, OUTER_ROTATE_TIME).as_relative();
	tween.set_loops();
