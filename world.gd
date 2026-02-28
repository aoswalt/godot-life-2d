extends Node2D

@export var size := Vector2i(100, 100)
@export var speed := 1.0
@export var paused := false

var next_gen_time_max := 1.0
var next_gen_time := next_gen_time_max

var cell_scene: PackedScene = preload("res://cell.tscn")

var cell_map: Dictionary[Vector2i, Node] = { }
var next_map: Dictionary[Vector2i, bool] = { }


func _ready() -> void:
	for y: int in size.y:
		for x: int in size.x:
			var cell: Node = cell_scene.instantiate()
			cell.coords = Vector2i(x, y)
			cell.position = cell.coords * 100
			cell_map[cell.coords] = cell
			add_child(cell)
			
	set_pattern(Vector2i(10, 10), seed_inf_1)


func _process(delta: float) -> void:
	if paused:
		return

	next_gen_time -= delta * speed

	if next_gen_time <= 0:
		next_gen_time = next_gen_time_max - next_gen_time

		for y: int in size.y:
			for x: int in size.x:
				var coords := Vector2i(x, y)
				next_map[coords] = is_alive(coords)

		for y: int in size.y:
			for x: int in size.x:
				var coords := Vector2i(x, y)
				cell_map[coords].alive = next_map[coords]


func is_alive(coords: Vector2i) -> bool:
	var neighbors := 0

	for y_off: int in [-1, 0, 1]:
		for x_off: int in [-1, 0, 1]:
			if x_off == 0 and y_off == 0:
				continue

			var neighbor_coords := coords + Vector2i(x_off, y_off)

			if neighbor_coords.x < 0:
				neighbor_coords.x = size.x - 1
			elif neighbor_coords.x == size.x:
				neighbor_coords.x = 0

			if neighbor_coords.y < 0:
				neighbor_coords.y = size.y - 1
			elif neighbor_coords.y == size.y:
				neighbor_coords.y = 0

			if cell_map[neighbor_coords].alive:
				neighbors += 1

	match neighbors:
		var n when n < 2:
			return false
		2:
			return cell_map[coords].alive
		3:
			return true
		_:
			return false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		paused = !paused


var seed_inf_1: Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(1, 0),
	Vector2i(2, 0),
	Vector2i(4, 0),
	Vector2i(0, 1),
	Vector2i(3, 2),
	Vector2i(4, 2),
	Vector2i(1, 3),
	Vector2i(2, 3),
	Vector2i(4, 3),
	Vector2i(0, 4),
	Vector2i(2, 4),
	Vector2i(4, 4),
]

func set_pattern(coords: Vector2i, pattern: Array[Vector2i]) -> void:
	for cell in pattern:
		cell_map[coords + cell].alive = true
