tool
extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var Resolution = 5 setget UpdateRes
export var Weight = 5 setget UpdateWeight
export var PointOne = Vector3() setget UpdatePointsPO
export var PointTwo = Vector3() setget UpdatePointsPT
export var lenght = 1
export var radius = 0.1

var Meshes = []
var Joints = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func UpdatePointsPO(value):
	PointOne = value
	if $PointOne:
		$PointOne.translate(PointOne - $PointOne.translation)
	UpdateRope()
	
		
func UpdatePointsPT(value):
	PointTwo = value
	if $PointTwo:
		$PointTwo.translate(PointTwo - $PointTwo.translation)
	UpdateRope()
		
func UpdateRes(value):
	Resolution = value
	UpdateRope()
	pass
	
func UpdateWeight(value):
	Weight = value
	UpdateRope()
	pass
	
func UpdateRope():
	print("Updated")
	Meshes = []
	Joints = []
	## We need to dissolve the current rope
	for c in get_children():
		if c.name != "PointOne" and c.name != "PointTwo":
			c.queue_free()
	
	##Now we need to create the rope
	var MinLenght = ($PointOne.translation - $PointTwo.translation).length()
	if lenght < MinLenght:
		print(str(lenght) + "," + str(MinLenght))
		lenght = MinLenght
	for i in range(Resolution+1):
		var CurrentJoint = HingeJoint.new()
		add_child(CurrentJoint)
		CurrentJoint.set_owner(get_tree().get_edited_scene_root())
		Joints.append(CurrentJoint)
	
	for m in range(Resolution):
		var CurrentMesh = MeshInstance.new()
		add_child(CurrentMesh)
		CurrentMesh.set_owner(get_tree().get_edited_scene_root())
		Meshes.append(CurrentMesh)
		var SegShape = CapsuleMesh.new()
		SegShape.mid_height = (lenght/Resolution)*0.5
		SegShape.radius = radius
		CurrentMesh.mesh = SegShape 
	$PointOne.add_child(Joints[0])
	print(Joints[0].name)
	#remove_child(Joints[0])
	#$PointOne.add_child(Joints[0])
	for i in range(Resolution): ##Deus me ajuda que eu me perdi
		pass
	pass