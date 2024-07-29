extends Node2D

#--------------------------------------------------------------------------------#
# Code inspired by CodeTrain on YouTube: https://www.youtube.com/@TheCodingTrain #
#--------------------------------------------------------------------------------#

var text: CompressedTexture2D = load("res://visualize_point.png")

var size: Vector2
var offset: int = 5
var q_x_points: int
var q_y_points: int

var point_arr: Array = []

var frame: int = 0
var noise: FastNoiseLite = FastNoiseLite.new()

func declare_matrix(point_arr: Array, x_size: int, y_size: int) -> void:
	for i in x_size + 1:
		point_arr.append([])
		for j in y_size + 1:
			point_arr[i].append(0)

func make_grid() -> void:
	var i: int = 0
	var j: int = 0
	
	while i <= size.x:
		while j <= size.y:
			var pos: Vector2 = Vector2(i, j)
			var point: Point = Point.new(pos) #text, 
			#point.Sprite.scale = point.Sprite.scale / 5
			#add_child(point)
			point_arr[i / offset][j / offset] = point
			j += offset
		j = 0
		i += offset
	
func calc(noise: FastNoiseLite) -> void:
	for i in q_x_points:
		for j in q_y_points:
			
			#código para desenhar malha
			#line.add_point(point_arr[i][j].Position)
			#line.add_point(point_arr[i][j + 1].Position)
			#line.add_point(point_arr[i + 1][j + 1].Position)
			#line.add_point(point_arr[i + 1][j].Position)
			
			#quatro pontos:
			var x: float = i * offset
			var y: float = j * offset
			var a: Vector2 = Vector2(x + (offset/2), y)
			var b: Vector2 = Vector2(x + offset, y + (offset/2))
			var c: Vector2 = Vector2(x + (offset/2), y + offset)
			var d: Vector2 = Vector2(x, y + (offset/2))
			point_arr[i][j].State = ceili(noise.get_noise_3d(x, y, 0))
			point_arr[i + 1][j].State = ceili(noise.get_noise_3d(x + offset, y, 0))
			point_arr[i + 1][j + 1].State = ceili(noise.get_noise_3d(x + offset, y + offset, 0)) 
			point_arr[i][j + 1].State = ceili(noise.get_noise_3d(x, y + offset, 0))
			var state: int = get_state(
				point_arr[i][j].State, 
				point_arr[i + 1][j].State, 
				point_arr[i + 1][j + 1].State, 
				point_arr[i][j + 1].State)
			match state: #at 0 and 15 we don`t draw anything
				1:
					create_line(c, d)
				2:
					create_line(b, c)
				3:
					create_line(b, d)
				4:
					create_line(a, b)
				5:
					create_line(a, d)
					create_line(b, c)
				6:
					create_line(a, c)
				7:
					create_line(a, d)
				8:
					create_line(a, d)
				9:
					create_line(a, c)
				10:
					create_line(a, b)
					create_line(c, d)
				11:
					create_line(a, b)
				12:
					create_line(b, d)
				13:
					create_line(b, c)
				14:
					create_line(c, d)

func get_state(a: float, b: float, c: float, d: float) -> int:
	return a*8 + b*4 + c*2 + d
	
func create_line(p1: Vector2, p2: Vector2) -> void:
	var line: Line2D = Line2D.new()
	line.width = 2
	add_child(line)
	line.add_point(p1)
	line.add_point(p2)

func clear_lines() -> void:
	for n in get_children():
		n.queue_free()

func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.01
	size = get_viewport_rect().size
	q_x_points = size.x / offset
	q_y_points = size.y / offset
	declare_matrix(point_arr, q_x_points, q_y_points)
	make_grid()
	#calc()

func _process(_delta: float) -> void:
	if !frame:
		clear_lines()
		calc(noise)
		noise.offset += Vector3(0.01, 0.01, 1)
	frame += 1
	if frame == 5:
		frame = 0
	pass
