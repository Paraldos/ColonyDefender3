extends Node2D

@export var movement_speed := 90.0
@export var edge_margin := 6.0
@export var actor: CharacterBody2D

var target_x: float
var touch_id := -1

func _ready() -> void:
	if actor == null:
		actor = get_parent() as CharacterBody2D
	target_x = global_position.x

func _physics_process(delta: float) -> void:
	actor.global_position.x = move_toward(actor.global_position.x, target_x, movement_speed * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and touch_id == -1:
			touch_id = event.index
			_set_target_x(event.position.x)
		elif not event.pressed and event.index == touch_id:
			touch_id = -1
	elif event is InputEventScreenDrag:
		if event.index == touch_id:
			_set_target_x(event.position.x)
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_set_target_x(event.position.x)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_set_target_x(event.position.x)

func _set_target_x(value: float) -> void:
	var viewport_width := get_viewport_rect().size.x
	target_x = clampf(value, edge_margin, viewport_width - edge_margin)
