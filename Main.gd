extends Node2D


export (PackedScene) var Grid
export (PackedScene) var LightGrid
export (PackedScene) var CheckPoint

var map


# Called when the node enters the scene tree for the first time.
func _ready():
	init_maze(DataInit.cur_point.x, DataInit.cur_point.y)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if DataInit.dialog_show == false:
		$CanvasLayer/Dialog.init_txt()
	$CanvasLayer/Dialog.visible = DataInit.dialog_show
	pass

func draw_maze():
	map = DataInit.map
	for r in range(-2, map.size()):
		for c in range(-2, map[r].size()):
			var ground = Sprite.new()
			ground.texture = load("res://ground.png")
			ground.position = Vector2(10 + c * 32, 10 + r * 32)
			$Background.add_child(ground)
	
	for r in range(map.size()):
		for c in range(map[r].size()):
			var grid
			var index = 0
			if map[r][c] == 255:
				continue
				
			if map[r][c] == 5:
				var check_point = CheckPoint.instance()
				check_point.position = Vector2(10 + c * 32, 10 + r * 32)
				$Item.call_deferred("add_child", check_point)
				continue	
			
			if map[r][c] < 2:
				grid = Grid.instance()
				index = map[r][c]
			elif map[r][c] < 4:
				grid = LightGrid.instance()
				index = map[r][c] - 2
			
				
			grid.position.x = 10 + c * 32
			grid.position.y = 10 + r * 32
			var grid_sprite = grid.get_child(0)
			grid_sprite.frame = index % grid_sprite.hframes
			
			$Item.call_deferred("add_child", grid)
	
	
func clean_maze(r, c, dir):
	for n in $Background.get_children():
		$Background.remove_child(n)
		n.queue_free()
	for n in $Item.get_children():
		if n.name == "Player":
			n.position = Vector2(32*DataInit.GRID_SIZE*DataInit.enters_pos[r][c][dir].x, 32*DataInit.GRID_SIZE*DataInit.enters_pos[r][c][dir].y) + Vector2(DataInit.GRID_SIZE * 16 + 10, DataInit.GRID_SIZE * 16 + 10)
			continue
		$Item.remove_child(n)
		n.queue_free()
	

func _on_Wall0_body_entered(body):
	next_maze(0)


func _on_Wall1_body_entered(body):
	next_maze(1)
	

func _on_Wall2_body_entered(body):
	next_maze(2)
	

func _on_Wall3_body_entered(body):
	next_maze(3)

func next_maze(dir):
	var r = DataInit.cur_point.x
	var c = DataInit.cur_point.y
	if dir == 0:
		r -= 1
	if dir == 1:
		r += 1
	if dir == 2:
		c -= 1
	if dir == 3:
		c += 1
	
	if r >= 0 && r < DataInit.MAZE_NUM && c >= 0 && c < DataInit.MAZE_NUM:
		clean_maze(r, c, dir ^ 1)
		DataInit.cur_point = Vector2(r, c)
		DataInit.map = DataInit.images[r][c]
		
		print(DataInit.cur_point)
		init_maze(r, c)
		
	else:
		print("gg")
		get_tree().change_scene("res://End1.tscn")
		pass

func init_maze(r, c):
	draw_maze()
	DataInit.dialog_show = false
	var key = "s%d%d" % [r, c]
	$CanvasLayer/Dialog.txt_arr = DataInit.words[key]
	
