tool
extends Spatial

export (Array,NodePath) var AssetsToChange
export (Array,Array,int) var FacesToChange 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func CMat(Mat):
	for c in range(len(AssetsToChange)):
		var Asset = get_node(AssetsToChange[c])
		for m in range(len(FacesToChange[c])):
			Asset.set_surface_material(m, Mat)