extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var txt_arr = ["aaaaa", "bbbbb", "cccc"]
var cur_id = 0
export var TXT_SPEED = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	init_txt()
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		if cur_id >= txt_arr.size():
			cur_id = 0
			$DialogBox.visible = false
		else:
			show_text()
			print(cur_id)
			cur_id+=1
			print(cur_id)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func show_text():
	$DialogBox.visible = true
	var time = TXT_SPEED * txt_arr[cur_id].length()
	$DialogBox/RichTextLabel.text = txt_arr[cur_id]
	$DialogBox/RichTextLabel.percent_visible = 0
	$DialogBox/Tween.interpolate_property($DialogBox/RichTextLabel, "percent_visible", 0, 1, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$DialogBox/Tween.start()

func init_txt():
	cur_id = 0
	$DialogBox/RichTextLabel.text = "A letter writes..."
	$DialogBox.visible = true
