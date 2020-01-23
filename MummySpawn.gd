extends Spatial

export var MummiesToSpawn = 1
var mummy = preload("res://Mummy.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.name == "player":
		if MummiesToSpawn > 0:
			var newMob = mummy.instance()
			get_node("/root").get_node("Spatial").add_child(newMob)
			newMob.transform = get_global_transform()
			newMob.transform.origin += Vector3(0,3,0)
			newMob.unBury()
			newMob.MySpawner = "../" + name
			MummiesToSpawn -= 1
	pass # Replace with function body.
