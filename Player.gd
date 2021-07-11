extends KinematicBody2D


export var FAST_TIMES = 5
export var MAX_SPEED = 100
export var ACCELERATION = 500
export var FRICTION = 500

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var velocity = Vector2.ZERO

var fast_k = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	animationTree.active = true
	pass # Replace with function body.


func _physics_process(delta):
	if Input.is_action_pressed("ui_run"):
		fast_k = FAST_TIMES
	else:
		fast_k = 1
	move_state(delta)
	pass


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED * fast_k, ACCELERATION * delta * fast_k)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationState.travel("Walk")
		if !$WalkSE.playing:
			$WalkSE.play()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta * FAST_TIMES)
		animationState.travel("Idle")
		$WalkSE.stop()
	move_and_slide(velocity)
	
