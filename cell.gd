extends Area2D

@export var coords: Vector2i

@export var alive: bool = false

@onready var coll: Node = $CollisionShape2D
@onready var shape: Node = $Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shape.polygon = PackedVector2Array(
		[
			Vector2(-coll.shape.size.x / 2, -coll.shape.size.y / 2),
			Vector2(coll.shape.size.x / 2, -coll.shape.size.y / 2),
			Vector2(coll.shape.size.x / 2, coll.shape.size.y / 2),
			Vector2(-coll.shape.size.x / 2, coll.shape.size.y / 2),
		],
	)

	self.input_event.connect(_on_input_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if alive:
		shape.color.a = 1.0
	else:
		shape.color.a = 0.2


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				alive = !alive
