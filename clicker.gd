extends Area2D

@onready var world_tiles: TileMapLayer = $WorldTiles
@onready var collider: CollisionShape2D = $Collider
@onready var tile_size := world_tiles.tile_set.tile_size
@onready var area := world_tiles.get_used_rect().size * tile_size

var half_size: Vector2

signal cell_toggled(coords: Vector2i)

func _ready() -> void:
	input_event.connect(_on_input_event)
	update_area()
	
func update_area() -> void:
	area = world_tiles.get_used_rect().size * tile_size
	half_size = area / 2.0
	collider.shape.set_size(area)
	collider.position += half_size

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				var area_pos: Vector2 = make_input_local(event).position
				var cell_coords := Vector2i(area_pos / Vector2(tile_size))
				cell_toggled.emit(cell_coords)
