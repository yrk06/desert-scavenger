extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var GetControlButtonName = "Button"
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(GetControlButtonName).connect("Pressed",self,"StartControl")
	pass # Replace with function body.
func StartControl(ButtonName):
	get_node("../player").isInControl = !get_node("../player").isInControl
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
