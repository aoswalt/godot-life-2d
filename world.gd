extends Node2D

signal cell_clicked

@export var size: Vector2i = Vector2(100, 100)

var cell_scene: PackedScene = preload("res://cell.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cell_clicked.connect(_on_cell_clicked)

	for y: int in size.y:
		for x: int in size.x:
			var cell: Node = cell_scene.instantiate()
			cell.coords = Vector2i(x, y)
			cell.cell_clicked = cell_clicked
			cell.alive = x + y % 5 != 0
			cell.position.x = 100 * x
			cell.position.y = 100 * y
			add_child(cell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cell_clicked(coords: Vector2i, alive: bool) -> void:
	print(coords, alive)
