extends Spatial

signal TurnedOn
signal TurnedOff
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (Array, NodePath) var Conduits


# Called when the node enters the scene tree for the first time.
func _ready():
	for c in Conduits:
		var Cond = get_node(c)
		Cond.connect("TurnedOn",self,"SomeoneIsOn")
		Cond.connect("TurnedOff",self,"SomeoneIsOff")

func SomeoneIsOn(who):
	for c in range(len(Conduits)):
		if get_node(Conduits[c]) == who:
			emit_signal("TurnedOn",c)

func SomeoneIsOff(who):
	for c in range(len(Conduits)):
		if get_node(Conduits[c]) == who:
			emit_signal("TurnedOff",c)
