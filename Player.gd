extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var MOUSE_SENS = 0.002
onready var DEFAULT_HALF_HEIGHT = $Body.shape.height
export var CROUCH_HALF_HEIGHT = 0.4
var isCrouching = false
onready var CAMERA_DEFAULT_HEIGHT = $RotationHelper.translation.y
export var DEFAULT_SPEED = 3.6 * 2
export var SPRINT_MOD = 1.2
export var CROUCH_MOD = 0.5

export var GRAVITY = 4
export var JUMP_SPEED = 40

var direction = Vector3()
var vel = Vector3()
var isInControl = true
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$RotationHelper/Camera/Label.rect_position = Vector2(get_viewport().size.x/2,get_viewport().size.y/2)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _physics_process(delta):
	if isInControl:
		process_input(delta)
		process_movement(delta)
	if Input.is_action_just_pressed("action"):
		if $RotationHelper/Action.is_colliding():
			var who = $RotationHelper/Action.get_collider()
			#print(who)
			if who.is_in_group("buttons"):
				who.get_parent().OnPressed()
		pass
	pass

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$RotationHelper.rotate_x(-event.relative.y * MOUSE_SENS)
		self.rotate_y(-event.relative.x * MOUSE_SENS)
		
	$RotationHelper.rotation_degrees.x = clamp($RotationHelper.rotation_degrees.x,-70,70)
	pass
	
func process_input(delta):
	direction = Vector3()
	var camera_rot = $RotationHelper/Camera.get_global_transform()
	var InputDir = Vector2()
	if Input.is_action_pressed("walk_front"):
		InputDir.y += 1
	if Input.is_action_pressed("walk_back"):
		InputDir.y -= 1
	if Input.is_action_pressed("walk_right"):
		InputDir.x += 1
	if Input.is_action_pressed("walk_left"):
		InputDir.x -= 1
	direction += camera_rot.basis.x  * InputDir.normalized().x
	direction += -camera_rot.basis.z  * InputDir.normalized().y
	
	if Input.is_action_pressed("crouch"):
		if !isCrouching:
			crouch()
	elif isCrouching:
		unCrouch()
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			vel.y = JUMP_SPEED
	
func process_movement(delta):
	direction.y = 0
	direction = direction.normalized()
	
	vel.x = direction.x * DEFAULT_SPEED
	vel.z = direction.z * DEFAULT_SPEED
	if isCrouching:
		vel.x *= CROUCH_MOD
		vel.z *= CROUCH_MOD
	
	vel.y -= GRAVITY
	if is_on_floor():
		vel.y = clamp(vel.y,-1,100)
	
	#$RotationHelper/Camera/Label.set_text(str(is_on_floor()))
	move_and_slide(vel,Vector3(0,1,0),true)

func crouch():
	print(translation.y)
	##Set the new capsule height
	$Body.shape.height = CROUCH_HALF_HEIGHT
	##Now we need to offset the casule
	$RotationHelper.translation.y = CAMERA_DEFAULT_HEIGHT - (DEFAULT_HALF_HEIGHT - CROUCH_HALF_HEIGHT)
	
	isCrouching = true
	pass
func unCrouch():
	$Body.shape.height = DEFAULT_HALF_HEIGHT
	$RotationHelper.translation.y = CAMERA_DEFAULT_HEIGHT
	translation.y += DEFAULT_HALF_HEIGHT - CROUCH_HALF_HEIGHT
	isCrouching = false
	pass

func Jump():
	pass