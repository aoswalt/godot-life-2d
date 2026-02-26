extends Camera2D

@onready var _zoom: Vector2 = zoom

var panning: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pan_hold"):
		panning = true
	if event.is_action_released("pan_hold"):
		panning = false

	elif event.is_action_pressed("zoom_in"):
		_zoom += Vector2(0.01, 0.01)

		zoom = _zoom
	elif event.is_action_pressed("zoom_out"):
		_zoom -= Vector2(0.01, 0.01)

		if _zoom.x <= 0:
			_zoom.x = 0.01
		if _zoom.y <= 0:
			_zoom.y = 0.01

		zoom = _zoom

	if event is InputEventMouseMotion and panning:
		position -= event.relative / zoom
