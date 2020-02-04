tool
extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (Vector3) var WhereTo
export (Vector3) var LookAt
export var SameScene = true;
export (PackedScene) var SceneToLoad;
export var SceneName = "Default"
export (Vector3) var WhereToLoad
export (NodePath) var NodeToFree
export (float) var FadeTimes = 1
var RotBasis
var player
var FadeSpeed



# Called when the node enters the scene tree for the first time.
func _ready():
	LookAt.y = 0
	LookAt = LookAt.normalized()
	LookAt = - LookAt
	FadeSpeed = 1.0/FadeTimes
	print(FadeSpeed)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.name == "player":
		player = body
		player.isInControl = false
		$Control/AnimationPlayer.play("FadeOut",-1,FadeSpeed)
		
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		if SceneToLoad:
			var scene = SceneToLoad.instance();
			scene.translation = WhereToLoad
			scene.name = SceneName
			get_tree().get_root().add_child(scene)
		Teleport()
		$Control/AnimationPlayer.play("FadeIn",-1,FadeSpeed)
	if anim_name == "FadeIn":
		if NodeToFree:
			get_node(NodeToFree).queue_free()
	pass # Replace with function body.


func Teleport():
	print("Opa")
	player.translation = WhereTo
	var angle = player.transform.basis.z.angle_to(LookAt)
	print(player.transform.basis.z)
	if player.transform.basis.z.x < 0:
		angle = -angle
	print(angle)
	player.transform.basis = player.transform.basis.rotated(Vector3.UP,angle)
	player.isInControl = true