tool
extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (Vector3) var WhereTo
export (Vector3) var LookAt
export var SameScene = true;
export (PackedScene) var Scene;
var RotBasis




# Called when the node enters the scene tree for the first time.
func _ready():
	LookAt.y = 0
	LookAt = LookAt.normalized()
	LookAt = - LookAt
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.name == "player":
		print("Opa")
		body.translation = WhereTo
		var angle = body.transform.basis.z.angle_to(LookAt)
		print(body.transform.basis.z)
		if body.transform.basis.z.x < 0:
			angle = -angle
		print(angle)
		body.transform.basis = body.transform.basis.rotated(Vector3.UP,angle)
	pass # Replace with function body.
