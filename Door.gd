tool
extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (Mesh) var MeshType setget set_mesh
export (float) var timeToOpen = 1.0
var isOpening = false
export var isOpen = false setget Toggle
export var WhereTo = Vector3()
export var ParticlePosition = Vector3() setget set_particle_pos
var Speed = 1
var animation = "idle"
export (NodePath) var ButtonName

func set_particle_pos(value):
	if $Particles:
		ParticlePosition = value
		$Particles.translation = value

func set_mesh(value):
	MeshType = value
	if $Mesh:
		$Mesh.mesh = value
		$Mesh/StaticBody/CollisionShape.shape = value.create_convex_shape()
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	var NodeButton = get_node(ButtonName)
	if NodeButton:
		NodeButton.connect("Pressed",self,"b_open")
		NodeButton.connect("Unpressed",self,"b_close")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animation == "open":
		Open(delta)
	if animation == "close":
		Close(delta)
	pass

func Toggle(value):
	Speed = WhereTo.length()/timeToOpen
	isOpen = value
	$Particles.emitting = true
	if isOpen:
		animation = "open"
	else:
		animation = "close"
	
func Open(delta):
	if $Mesh.translation != WhereTo:
		if (WhereTo - $Mesh.translation).length() < Speed*delta:
			$Mesh.translation = WhereTo
		else:
			$Mesh.translate_object_local(WhereTo.normalized()*Speed*delta)
	else:
		$Particles.emitting = false
		animation = "idle"
	
func Close(delta):
	if $Mesh.translation != Vector3(0,0,0):
		if (-$Mesh.translation ).length() < Speed*delta:
			$Mesh.translation = Vector3(0,0,0)
		else:
			$Mesh.translate_object_local(-$Mesh.translation.normalized()*Speed*delta)
	else:
		$Particles.emitting = false
		animation = "idle"
		
func b_open(name):
	Toggle(true)
	
func b_close(name):
	Toggle(false)