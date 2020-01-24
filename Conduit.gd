tool
extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var OtherConduits = []
var WhoIsOn = []
export var facesToChange = [0] ##Set per Mesh (Good luck)
var OffMat = preload("res://TempleAssets/Green_Stone_Default.tres")
var OnMat = preload("res://TempleAssets/Green_Stone_On.tres")
export var Generator = false setget set_generator
export (NodePath) var Button = "" 
export (Mesh) var MeshType setget set_mesh
var isOn = false


func set_generator(value):
	Generator = value
	if Generator:
		TurnOn(self)
		isOn = true
	else:
		isOn = false
		TurnOff(self)

func set_mesh(value):
	MeshType = value
	if $Mesh:
		$Mesh.mesh = value
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in facesToChange:
		$Mesh.set_surface_material(i,OffMat)
	if Generator:
		TurnOn(self)
		
	var NodeButton = get_node(Button)
	if NodeButton:
		NodeButton.connect("Pressed",self,"b_TurnOn")
		NodeButton.connect("Unpressed",self,"b_TurnOff")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func TurnOn(Who):
	if Who != self:
		if !(Who in WhoIsOn):
			WhoIsOn.append(Who)
	for i in facesToChange:
		$Mesh.set_surface_material(i,OnMat)
	if len(OtherConduits) != 0:
		for c in OtherConduits:
			var Bagulho = get_node(c)
			if Bagulho:
				if !(Bagulho in WhoIsOn):
					print(c)
					print(Bagulho)
					Bagulho.TurnOn(self)
	pass
func TurnOff(Who):
	if !Generator:
		for c in range(len(WhoIsOn)):
			if WhoIsOn[c] == Who:
				WhoIsOn.remove(c)
		if len(WhoIsOn) == 0:
			for i in facesToChange:
				$Mesh.set_surface_material(i,OffMat)
			for c in OtherConduits:
				var Bagulho = get_node(c)
				if Bagulho != Who:
					print(c)
					print(Bagulho)
					Bagulho.TurnOff(self)
			
		pass
	pass
	
func b_TurnOn(name):
	TurnOn(self)
	
func b_TurnOff(name):
	TurnOff(self)