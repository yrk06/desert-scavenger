tool
extends Spatial


signal TurnedOn
signal TurnedOff

## This Enum is used to know which type of conector it is (in case Rotation is turned on)
enum RT {CORNER,END,STRAIGHT,TJOINT}

##Handle Conection
export (Array, NodePath) var OtherConduits = [] setget set_OtherConduits
export var WhoIsOn = []
var ActiveConection
export var Generator = false setget set_generator
export (NodePath) var Button = "" 

##Handle Rotation
export (bool) var ShouldRotate
export (RT) var RotationType
export var CurrentRotation = 0 setget set_CurrentRotation
export (float) var RotationSpeed = 10
var AngleToRotate = 0
export (NodePath) var RotateButton
##Handle the animation
var animation = "idle"

##Visible aspects
export var facesToChange = [0] ##Set per Mesh (Good luck)
var OffMat = preload("res://TempleAssets/Green_Stone_Default.tres")
var OnMat = preload("res://TempleAssets/Green_Stone_On.tres")
export (Mesh) var MeshType setget set_mesh




var IsOn = false

func set_OtherConduits(value):
	OtherConduits = value

func set_CurrentRotation(value):
	if ShouldRotate:
		ApplyRotation(value-CurrentRotation)
		
func set_animation_angle(value):
	AngleToRotate += value

func set_active_conduits():
	ActiveConection = []
	if !ShouldRotate:
		for c in OtherConduits:
			if c != "":
				ActiveConection.append(c)

##This function is going to Aplly Rotaions when needed
func ApplyRotation(offset):
	
	## We Turn off from every source
	for t in WhoIsOn:
		TurnOff(t)
	
	# Empty the variable to find the new conections
	ActiveConection = []
	
	##Supose we have a max of 4 possible rotations for any
	# point in the conduit. this way, the maximum number the rotation
	# can be is 3 (0 based index)
	CurrentRotation += offset
	if CurrentRotation > 3:
		CurrentRotation -= 4
	## After this, we need to sample all the other points we might use
	var NextPoint = CurrentRotation+1
	var OpositePoint = CurrentRotation+2
	var BackPoint = CurrentRotation+3
	
	if NextPoint > 3:
		NextPoint -=4
		OpositePoint -=4
		BackPoint -=4
	
	if OpositePoint > 3:
		OpositePoint -=4
		BackPoint -=4
	
	if BackPoint > 3:
		BackPoint -=4
		
	## We have all of the 4 possible points, now we need to get which
	# conection should be active
	
	match RotationType:
		RT.CORNER:
			if CurrentRotation < len(OtherConduits):
				if OtherConduits[CurrentRotation] != "":
					ActiveConection.append(OtherConduits[CurrentRotation])
			if NextPoint < len(OtherConduits):
				if OtherConduits[NextPoint] != "":
					ActiveConection.append(OtherConduits[NextPoint])
		RT.END:
			if CurrentRotation < len(OtherConduits):
				if OtherConduits[CurrentRotation] != "":
					ActiveConection.append(OtherConduits[CurrentRotation])
		RT.STRAIGHT:
			if CurrentRotation < len(OtherConduits):
				if OtherConduits[CurrentRotation] != "":
					ActiveConection.append(OtherConduits[CurrentRotation])
			if OpositePoint < len(OtherConduits):
				if OtherConduits[OpositePoint] != "":
					ActiveConection.append(OtherConduits[OpositePoint])
		RT.TJOINT:
			if CurrentRotation < len(OtherConduits):
				if OtherConduits[CurrentRotation] != "":
					ActiveConection.append(OtherConduits[CurrentRotation])
				
			if NextPoint < len(OtherConduits):
				if OtherConduits[NextPoint] != "":
					ActiveConection.append(OtherConduits[NextPoint])
					
			if OpositePoint < len(OtherConduits):
				if OtherConduits[OpositePoint] != "":
					ActiveConection.append(OtherConduits[OpositePoint])
	
	for c in ActiveConection:
		#print(c)
		var CNode = get_node(c)
		if CNode.IsOn:
			if len(CNode.WhoIsOn) > 1 or !(self in CNode.WhoIsOn):
				TurnOn(CNode)
				print("Someone is on")
#	for c in WhoIsOn:
#		var isIn = false
#		for a in ActiveConection:
#			if c == get_node(a):
#				isIn = true
#		if !isIn:
#			TurnOff(c)
	animation = "rotate"
	set_animation_angle(-PI*offset/2)
	print(ActiveConection)
		
		
	


##This function start the conection from the editor, this way we can test the circuit
func set_generator(value):
	Generator = value
	if !ShouldRotate:
		set_active_conduits()
	else:
		ApplyRotation(0)
	
	if Generator:
		TurnOn(self)
		IsOn = true
	else:
		IsOn = false
		TurnOff(self)
	

func set_mesh(value):
	MeshType = value
	if $Mesh:
		$Mesh.mesh = value
		$Mesh/StaticBody/CollisionShape.shape = value.create_trimesh_shape()
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	IsOn = false
	WhoIsOn = []
	for i in facesToChange:
		$Mesh.set_surface_material(i,OffMat)
	if !ShouldRotate:
		set_active_conduits()
	else:
		print(ActiveConection)
		ApplyRotation(0)
	if Generator:
		TurnOn(self)
		
	var NodeButton = get_node(Button)
	if NodeButton:
		NodeButton.connect("Pressed",self,"b_TurnOn")
		NodeButton.connect("Unpressed",self,"b_TurnOff")
	var RButton = get_node(RotateButton)
	if RButton:
		RButton.connect("Pressed",self,"b_Rotate")
		RButton.connect("Unpressed",self,"b_Unrotate")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## We'll use this function just ti handle the animation
	if animation == "rotate":
		
		if abs(AngleToRotate) < RotationSpeed * delta:
			## We can snap to the desired rotation when close enough
			$Mesh.rotate_y(AngleToRotate)
			AngleToRotate = 0
			animation = "idle" 
		else:
			
			var direction = AngleToRotate/abs(AngleToRotate)
			$Mesh.rotate_y(RotationSpeed*delta*direction) 
			AngleToRotate -= RotationSpeed*delta*direction
	pass

func TurnOn(Who):
	print(self.name + " Received from " + Who.name)
	var TurnOn = false
	if Who != self:
		for c in ActiveConection:
			if Who == get_node(c):
				TurnOn = true
		if !(Who in WhoIsOn) and TurnOn:
			WhoIsOn.append(Who)
	if TurnOn or Who == self:
		for i in facesToChange:
			if $Mesh:
				$Mesh.set_surface_material(i,OnMat)
		if len(ActiveConection) != 0:
			for c in ActiveConection:
				var Bagulho = get_node(c)
				if Bagulho:
					if !(Bagulho in WhoIsOn):
						print(str(c) + " will be called " + self.name)
						#print(Bagulho)
						Bagulho.TurnOn(self)
		emit_signal("TurnedOn")
		IsOn = true
	pass
func TurnOff(Who):
	if !Generator:
		#print(self.name + " asked to turn of by: " + Who.name)
		#print(WhoIsOn.name)
		for c in range(len(WhoIsOn)):
			if WhoIsOn[c] == Who:
				WhoIsOn.remove(c)
				break
		if len(WhoIsOn) == 0:
			for i in facesToChange:
				$Mesh.set_surface_material(i,OffMat)
			if len(ActiveConection) != 0:
				for c in ActiveConection:
					var Bagulho = get_node(c)
					if Bagulho != Who:
						print(c)
						print(Bagulho)
						Bagulho.TurnOff(self)
			emit_signal("TurnedOff")
			IsOn = false
			
		pass
	pass
	
func b_TurnOn(name):
	TurnOn(self)
	
func b_TurnOff(name):
	TurnOff(self)
	
func b_Rotate(name):
	ApplyRotation(1)
	
func b_Unrotate(name):
	ApplyRotation(-1)