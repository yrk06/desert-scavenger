extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = Vector3()
var rotateTo = 0
var banking = 0
var input = Vector2()
export var GetControlButtonName = "Button"
var isInControl = false
export var SPEED = 7.2
export var ROTATION_SPEED = 0.01
export var ACCELERATION  = 0.5
var curAccel = 0
var curSpeed = 0
var vel = Vector3()
var reset = true
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(GetControlButtonName).connect("Pressed",self,"StartControl")
	pass # Replace with function body.
func StartControl(ButtonName):
	isInControl = !isInControl
	get_node("../player").isInControl = !get_node("../player").isInControl
	if $Camera.current:
		get_node("../player/RotationHelper/Camera").make_current()
	else:
		$Camera.make_current()
	if isInControl:
		reset = true
	pass
	

func process_input(delta):
	input = Vector2()
	direction = Vector3()
	rotateTo = 0
	banking = 0
	if Input.is_action_pressed("walk_front"):
		input.y += 1
	if Input.is_action_pressed("walk_back"):
		input.y -= 1
	if Input.is_action_pressed("walk_right"):
		input.x -= 1
	if Input.is_action_pressed("walk_left"):
		input.x += 1
		
	if Input.is_action_pressed("bank_up"):
		banking +=1
	if Input.is_action_pressed("bank_down"):
		banking -=1
	if Input.is_action_just_pressed("action") && !reset:
		StartControl("Asdrubal")
		
	direction += -transform.basis.z * input.y
	rotateTo += input.x

func process_movement(delta):
	direction = direction.normalized()
	rotate_object_local( Vector3(1,0,0),(banking * ROTATION_SPEED))
	rotate_y(rotateTo * ROTATION_SPEED)
	var hvel = vel
	hvel.y = 0

	var target = direction
	target *= -SPEED

	var accel
	if direction.dot(hvel) > 0:
		accel = ACCELERATION
	else:
		accel = -ACCELERATION

	hvel = hvel.linear_interpolate(target, accel*delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel)
	pass

func _physics_process(delta):
	if isInControl:
		get_node("../player").global_transform = $playerPos.global_transform
		process_input(delta)
		process_movement(delta)
		if reset:
			reset = false