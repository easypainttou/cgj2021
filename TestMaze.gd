extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var maze

# Called when the node enters the scene tree for the first time.
func _ready():
	maze = DataInit.maze
	update()
	pass # Replace with function body.

func _process(delta):
	pass

func _draw():
	draw_maze()
	# draw_rect(Rect2(0, 0, 50, 100), Color(0, 0, 0))
	pass # Replace with function body.

func draw_maze():
	for r in maze.size():
		for c in maze[r].size():
			draw_rect(Rect2(10 + c, 10 + r, 2, 2), Color(maze[r][c], maze[r][c], maze[r][c]))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
