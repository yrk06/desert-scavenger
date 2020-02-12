tool
extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (Mesh) var MeshType setget set_mesh
export (bool) var UsePackedScene = false setget set_uPS
export (PackedScene) var PS_MeshType setget set_PS_mesh
var PS
export (float) var timeToOpen = 1.0
export (int) var threshold = 1
var currentInput = 0
var isOpening = false
export var isOpen = false setget Toggle
export var WhereTo = Vector3()
export (Array,int) var FacesToChange
export (Material) var OpenMat
export (Material) var CloseMat
export var ParticlePosition = Vector3() setget set_particle_pos
var Speed = 1
var animation = "idle"
export (NodePath) var ButtonName

export (Array, NodePath) var circuit


func set_particle_pos(value):
	if $Particles:
		ParticlePosition = value
		$Particles.translation = value

func set_uPS(value):
	UsePackedScene = value
	if UsePackedScene:
		set_mesh(null)
	else:
		set_PS_mesh(null)
func set_mesh(value):
	if !UsePackedScene or value == null:
		MeshType = value
		if $Mesh:
			$Mesh.mesh = value
			if value != null:
				$Mesh/StaticBody/CollisionShape.shape = value.create_convex_shape()
			else:
				$Mesh/StaticBody/CollisionShape.shape = null
			
	pass
	
func set_PS_mesh(value):
	if UsePackedScene or value == null:
		PS_MeshType = value
		if PS:
			PS.queue_free()
		if PS_MeshType != null:
			PS = PS_MeshType.instance()
			add_child(PS)
			PS.set_owner(self)
			PS.name = "PS_Mesh"
		else:
			PS = null
# Called when the node enters the scene tree for the first time.
func _ready():
	var NodeButton = get_node(ButtonName)
	if NodeButton:
		NodeButton.connect("Pressed",self,"b_open")
		NodeButton.connect("Unpressed",self,"b_close")
	print(circuit)
	for c in circuit:
		var CNode = get_node(c)
		if CNode:
			CNode.connect("TurnedOn",self,"c_open")
			CNode.connect("TurnedOff",self,"c_close")
	
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
		if UsePackedScene:
			if PS.has_method("ChangeMat"):
				PS.TurnOnMat(OpenMat);
		else:
			for i in FacesToChange:
				$Mesh.set_surface_material(i,OpenMat)
		animation = "open"
	else:
		if UsePackedScene:
			if PS.has_method("ChangeMat"):
				PS.TurnOnMat(CloseMat);
		else:
			for i in FacesToChange:
				$Mesh.set_surface_material(i,CloseMat)
		animation = "close"
	
func Open(delta):
	var Objeto
	if UsePackedScene:
		Objeto = PS
	else:
		Objeto = $Mesh
	if Objeto.translation != WhereTo:
		if (WhereTo - Objeto.translation).length() < Speed*delta:
			Objeto.translation = WhereTo
		else:
			Objeto.translate_object_local(WhereTo.normalized()*Speed*delta)
	else:
		$Particles.emitting = false
		animation = "idle"
	
func Close(delta):
	var Objeto
	if UsePackedScene:
		Objeto = PS
	else:
		Objeto = $Mesh
	if Objeto.translation != Vector3(0,0,0):
		if (-Objeto.translation ).length() < Speed*delta:
			Objeto.translation = Vector3(0,0,0)
		else:
			Objeto.translate_object_local(-Objeto.translation.normalized()*Speed*delta)
	else:
		$Particles.emitting = false
		animation = "idle"
		
func b_open(name):
	currentInput +=1
	if currentInput >= threshold:
		Toggle(true)
	
func b_close(name):
	currentInput -=1
	if currentInput < threshold:
		Toggle(false)
	
func c_open():
	currentInput +=1
	if currentInput >= threshold:
		Toggle(true)
	
func c_close(): 
	currentInput -=1
	if currentInput < threshold:
		Toggle(false)