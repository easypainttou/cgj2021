extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var MAZE_NUM = 3


export var ROW_NUM = 10
export var COL_NUM = 10
export var GRID_SIZE = 5
export var WALL_SIZE = 1

var dialog_show = false

var rng = RandomNumberGenerator.new()

var big_maze
var images
var cur_point
var enters_pos = matrix3d(MAZE_NUM, MAZE_NUM, 4)

var map

var words
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	generate_images()
	cur_point = Vector2(MAZE_NUM >> 1, MAZE_NUM >> 1)
	
	map = images[cur_point.x][cur_point.y]
	
	var file = File.new()
	file.open("res://words.json", File.READ)
	var txt = file.get_as_text()
	var json =  parse_json(txt)
	words = json
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func generate_images():
	big_maze = generate_maze(MAZE_NUM, MAZE_NUM)
	var enter = get_random_door(MAZE_NUM, MAZE_NUM)		
	big_maze[enter.x][enter.y][enter.z] = 1
	var exit = enter
	while exit == enter:
		exit = get_random_door(MAZE_NUM, MAZE_NUM)
	big_maze[exit.x][exit.y][exit.z] = 1

	images = matrix2d(MAZE_NUM, MAZE_NUM)
	
	
	
	for r in MAZE_NUM:
		for c in MAZE_NUM:
			var maze = generate_maze(ROW_NUM, COL_NUM)
			var door_r
			var door_c
			if (big_maze[r][c][0] == 1):
				door_r = 0
				door_c = rng.randi() % COL_NUM
				maze[door_r][door_c][0] = 1
				enters_pos[r][c][0] = Vector2(door_c, door_r)
			if (big_maze[r][c][1] == 1):
				door_r = ROW_NUM - 1
				door_c = rng.randi() % COL_NUM
				maze[door_r][door_c][1] = 1
				enters_pos[r][c][1] = Vector2(door_c, door_r)
			if (big_maze[r][c][2] == 1):
				door_r = rng.randi() % ROW_NUM
				door_c = 0
				maze[door_r][door_c][2] = 1
				enters_pos[r][c][2] = Vector2(door_c, door_r)
			if (big_maze[r][c][3] == 1):
				door_r = rng.randi() % ROW_NUM
				door_c = COL_NUM - 1
				maze[door_r][door_c][3] = 1
				enters_pos[r][c][3] = Vector2(door_c, door_r)
			images[r][c] = generate_small_image(maze)
	

func generate_maze(row_num, col_num):
	var maze = matrix3d(row_num, col_num, 5)
	var r = 0
	var c = 0
	var history = [Vector2(r, c)]
	while history:
		maze[r][c][4] = 1
		var check = []
		if r > 0 && maze[r - 1][c][4] == 0:
			check.append("U")
		if r < row_num - 1 && maze[r + 1][c][4] == 0:
			check.append("D")
		if c > 0 && maze[r][c - 1][4] == 0:
			check.append("L")
		if c < col_num - 1 && maze[r][c + 1][4] == 0:
			check.append("R")
		
		if check.size() > 0:
			history.append(Vector2(r, c))
			var move_direction = check[rng.randi() % check.size()]
			if move_direction == "U":
				maze[r][c][0] = 1
				r -= 1
				maze[r][c][1] = 1
			if move_direction == "D":
				maze[r][c][1] = 1
				r += 1
				maze[r][c][0] = 1
			if move_direction == "L":
				maze[r][c][2] = 1
				c -= 1
				maze[r][c][3] = 1
			if move_direction == "R":
				maze[r][c][3] = 1
				c += 1
				maze[r][c][2] = 1
		else:
			var last = history.pop_back()
			r = last.x
			c = last.y
	return maze

func generate_small_image(maze):
	var image = matrix2d(ROW_NUM * GRID_SIZE, COL_NUM * GRID_SIZE)
	
	for row in range(0, ROW_NUM):
		for col in range(0,COL_NUM):
			var cell_data = maze[row][col]
			for i in range(GRID_SIZE*row+WALL_SIZE,GRID_SIZE*row+GRID_SIZE -WALL_SIZE):
				for j in range(GRID_SIZE*col+WALL_SIZE,GRID_SIZE*col+GRID_SIZE -WALL_SIZE):
					image[i][j] = 255
			if cell_data[2] == 1: 
				for j in range(GRID_SIZE*row+WALL_SIZE,GRID_SIZE*row+GRID_SIZE -WALL_SIZE):
					for k in range(0, WALL_SIZE):
						image[j][GRID_SIZE*col + k] = 255
			if cell_data[0] == 1: 
				for j in range(GRID_SIZE*col+WALL_SIZE,GRID_SIZE*col+GRID_SIZE -WALL_SIZE):
					for k in range(0, WALL_SIZE):
						image[GRID_SIZE*row][j + k] = 255
			if cell_data[3] == 1: 
				for j in range(GRID_SIZE*row+WALL_SIZE,GRID_SIZE*row+GRID_SIZE -WALL_SIZE):
					for k in range(0, WALL_SIZE):
						image[j][GRID_SIZE*col+GRID_SIZE - 1 - k] = 255
			if cell_data[1] == 1: 
				for j in range(GRID_SIZE*col+WALL_SIZE,GRID_SIZE*col+GRID_SIZE -WALL_SIZE):
					for k in range(0, WALL_SIZE):
						image[GRID_SIZE*row+GRID_SIZE -1- k][j] = 255
	#draw the maze
	for r in image.size():
		for c in image[r].size():
			if image[r][c] == 0:
				if rng.randi() % 1000 < 2:
					image[r][c] = rng.randi() % 2 + 2
				else:
					image[r][c] = rng.randi() % 2
	#print(image)
	var check_r = rng.randi() % ROW_NUM
	var check_c = rng.randi() % COL_NUM
	
	# check point
	image[check_r * GRID_SIZE + WALL_SIZE + 1][check_c * GRID_SIZE + WALL_SIZE + 1] = 5
	
	return image
	

func get_random_door(row_num, col_num):
	var direction = rng.randi() % 4
	var r
	var c
	if direction == 0:
		r = 0
		c = rng.randi() % (col_num)
	if direction == 1:
		r = row_num - 1
		c = rng.randi() % (col_num)
	if direction == 2:
		r = rng.randi() % (row_num)
		c = 0
	if direction == 3:
		r = rng.randi() % (row_num)
		c = col_num - 1
	return Vector3(r, c, direction)

func matrix3d(width, height, depth):
	var array = []
	array.resize(width)    # X-dimension
	for x in width:    # this method should be faster than range since it uses a real iterator iirc
		array[x] = []
		array[x].resize(height)    # Y-dimension
		for y in height:
			array[x][y] = []
			array[x][y].resize(depth)    # Z-dimension
			for z in depth:
				array[x][y][z] = 0
	return array

func matrix2d(width, height):
	var array = []
	array.resize(width)    # X-dimension
	for x in width:    # this method should be faster than range since it uses a real iterator iirc
		array[x] = []
		array[x].resize(height)    # Y-dimension
		for y in height:
			array[x][y] = 0
	return array
