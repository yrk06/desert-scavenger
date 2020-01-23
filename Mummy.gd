extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var SPEED = 2
export var ROTATION_SPEED = 1
var isActive = false
var time = 0
var vel = Vector3()
var BuryOffset = Vector3()
var MySpawner
onready var startTranslation = translation 


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape.disabled = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	time += delta
	if isActive:
		var PlayerPos = get_node("../player").transform.origin
		var MyPos = transform.origin
		var dir = PlayerPos - MyPos
		dir.y = 0
		var MyFront = transform.basis.xform(Vector3(0,0,1)).normalized()
		dir = dir.normalized()
		var localDir = transform.basis.xform_inv(dir)
		print(localDir)
		var angle = acos(MyFront.dot(dir))
		var curRot = ROTATION_SPEED
		if localDir.x < 0:
			curRot = -curRot
		vel.x = dir.x*SPEED
		vel.z = dir.z*SPEED
		vel.y -= 1
		if is_on_floor():
			vel.y = clamp(vel.y,-1,100)
		move_and_slide(vel,Vector3(0,1,0),true)	
		if abs(angle) > ROTATION_SPEED*delta:
			rotate(Vector3.UP,curRot*delta)
		var rotated1 = $Leg1Rotator.rotation.x
		var rotated2 = $Leg2Rotator.rotation.x
		$Leg1Rotator.rotate_object_local(Vector3(1,0,0),PI/2*sin(time*5)-rotated1)
		$Leg2Rotator.rotate_object_local(Vector3(1,0,0),PI/2*sin(time*5+PI)-rotated2)
	
	
func unBury():
	$CollisionShape.disabled = false
	isActive = true
	pass
	
func reBury():
	pass

func OnBulletHit(Damage):
	queue_free()
	pass
