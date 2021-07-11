extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	DataInit.dialog_show = false
	var key = "e1"
	$CanvasLayer/Dialog.txt_arr = DataInit.words[key]
	pass # Replace with function body.

func _process(delta):
	if DataInit.dialog_show == false:
		$CanvasLayer/Dialog.init_txt()
	$CanvasLayer/Dialog.visible = DataInit.dialog_show
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
