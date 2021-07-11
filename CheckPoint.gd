extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("spin")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	DataInit.dialog_show = true
	$EnterSE.play()
	print(1)
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	DataInit.dialog_show = false
	print(2)
	pass # Replace with function body.
