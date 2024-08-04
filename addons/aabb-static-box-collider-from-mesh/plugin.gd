@tool
extends EditorPlugin

var currentNode: Node3D;
var generateButton: Button;

func _handles(object) -> bool:
	if object is VisualInstance3D:
		print_debug("Is Visual")
		return true;
	
	elif object is Node3D:
		var root: Node3D = object;
		var children: Array = root.find_children("*", "VisualInstance3D");
		print_debug("Has Visual?: " + str(!children.is_empty()));
		
		return !children.is_empty();
	
	return false;
	
func _edit(object: Object) -> void:
	print_debug(object);
	if object:
		currentNode = object;
	
func _make_visible(visible):
	if !visible:
		remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, generateButton);
		generateButton.queue_free();
		generateButton = null;
		return;
		
	if generateButton:
		return;
	
	generateButton = Button.new();
	generateButton.text = "Generate AABB BoxCollider";
	generateButton.flat = true;
	generateButton.pressed.connect(_onButtonPressed);
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, generateButton);
	
func _onButtonPressed():
	var aabb: AABB;
	if currentNode is VisualInstance3D:
		aabb = currentNode.mesh.get_aabb();
	else:
		var children: Array[Node] = currentNode.find_children("*", "VisualInstance3D");
		var first: VisualInstance3D = children.pop_front();
		aabb = getRelativeAABB(first);
		for child in children:
			aabb = aabb.merge(getRelativeAABB(child));
	
	var body = StaticBody3D.new();
	body.name = "AABB_StaticBody3D";
	body.transform = Transform3D();
	currentNode.add_child(body);
	body.owner = currentNode.owner;
	
	var box = BoxShape3D.new();
	box.extents = Vector3(aabb.size/2);
	
	var coll_shape = CollisionShape3D.new();
	coll_shape.name = "AABB_CollisionShape3D";
	coll_shape.shape = box;
	coll_shape.transform = Transform3D();
	coll_shape.position = aabb.get_center();
	body.add_child(coll_shape);
	coll_shape.owner = currentNode.owner;


func getRelativeAABB(childNode: Node3D):
	var childAABB = childNode.get_aabb();
	var parent = childNode.get_parent_node_3d();
	while parent != currentNode:
		var invTrans = parent.transform.inverse();
		childAABB.size = invTrans.basis * childAABB.size;
		childAABB.position -= invTrans.origin / invTrans.basis.get_scale();
		print_debug("final: ", childAABB);
		parent = parent.get_parent_node_3d();
	return childAABB;
