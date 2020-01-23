extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 5
export var damage = 0
var curSpeed = 0
var localDirection = Vector3(0,0,-1)
var moveDirection = Vector3()
var NotCollide = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fire():
	curSpeed = speed
	moveDirection = transform.basis.xform(localDirection)
func addObjectToException(object):
	NotCollide.append(object)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var col_info = move_and_collide(moveDirection*curSpeed)
	if col_info:
		if !(col_info.collider in NotCollide):
			if col_info.collider.has_method("OnBulletHit"):
				col_info.collider.OnBulletHit(damage)
			queue_free()
	pass
