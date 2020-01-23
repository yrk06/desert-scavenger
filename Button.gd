extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal Pressed
signal Unpressed
export var ButtonName = "default"
export var canBePressed = true
export var once = false
export var timeToReset = 1
export var TwoState = false
export var isPressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody.add_to_group("buttons")
	
	$Timer.connect("timeout",self,"Reset")
	pass # Replace with function body.

func OnPressed():
	if canBePressed:
		if TwoState:
			isPressed = !isPressed
			if isPressed:
				emit_signal("Pressed",ButtonName)
			else:
				emit_signal("Unpressed",ButtonName)
		else:
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
