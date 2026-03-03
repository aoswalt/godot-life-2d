extends Node2D

@onready var world_tiles: TileMapLayer = %WorldTiles
@onready var clicker: Area2D = $Clicker

@export var size := Vector2i(100, 100)
@export var speed := 1.0
@export var paused := false

var next_gen_time_max := 1.0
var next_gen_time := next_gen_time_max

var active_map: Dictionary[Vector2i, bool] = { }
var next_map := active_map.duplicate()


func _ready() -> void:
	for y: int in size.y:
		for x: int in size.x:
			var coords := Vector2i(x, y)
			set_cell(coords, false)
			
	clicker.update_area()

	next_map = active_map.duplicate()

	set_pattern(Vector2i(4, 4), seed_inf_1)
	
	clicker.cell_toggled.connect(_on_cell_toggled)


func set_cell(coords: Vector2i, alive: bool) -> void:
	active_map[coords] = alive
	set_tile(coords, alive)


func set_tile(coords: Vector2i, alive: bool) -> void:
	world_tiles.set_cell(coords, 1, Vector2i(1 if alive else 0, 0))


func toggle_cell(coords: Vector2i) -> void:
	var alive := world_tiles.get_cell_atlas_coords(coords).x == 1
	set_cell(coords, !alive)

func _on_cell_toggled(coords: Vector2i) -> void:
	toggle_cell(coords)

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

		var swap_map := active_map
		active_map = next_map
		next_map = swap_map

		for y: int in size.y:
			for x: int in size.x:
				var coords := Vector2i(x, y)
				set_cell(coords, active_map[coords])


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

			if active_map[neighbor_coords]:
				neighbors += 1

	match neighbors:
		var n when n < 2:
			return false
		2:
			return active_map[coords]
		3:
			return true
		_:
			return false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		paused = !paused




func set_pattern(coords: Vector2i, pattern: Array[Vector2i]) -> void:
	for location in pattern:
		set_cell(location + coords, true)


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
