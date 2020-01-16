extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal Pressed
export var ButtonName = "default"
export var canBePressed = true
export var once = false
export var timeToReset = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody.add_to_group("buttons")
	
	$Timer.connect("timeout",self,"Reset")
	pass # Replace with function body.

func OnPressed():
	if canBePressed:
		emit_signal("Pressed",ButtonName)
		print("Button: " + ButtonName + " has been pressed")
		if !once:
			$Timer.start()
		canBePressed = false
	
	
func Reset():
	canBePressed = true
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
