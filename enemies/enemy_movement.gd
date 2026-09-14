extends Node2D
class_name EnemyMovement

enum Movement {
	STRAIGHT_DOWN,
	SINUS_DOWN,
}

@export var actor: Node2D
@export var speed := 20.0
@export var movement_type := Movement.STRAIGHT_DOWN

@export_group("Sinus Movement")
@export var amplitude: float = 10.0
@export var frequency: float = 0.5

var _elapsed_time: float = 0.0
var _start_pos := Vector2.ZERO

func _ready() -> void:
	if actor == null:
		actor = get_parent() as Node2D
	_start_pos = global_position

func _physics_process(delta: float) -> void:
	if actor == null:
		return
	match movement_type:
		Movement.STRAIGHT_DOWN:
			_move_straight_down(delta)
		Movement.SINUS_DOWN:
			_move_sinus_down(delta)

func _move_straight_down(delta: float) -> void:
	actor.position.y += speed * delta

func _move_sinus_down(delta: float) -> void:
	_elapsed_time += delta
	actor.position.y += speed * delta
	actor.position.x = (_start_pos.x + sin(_elapsed_time * frequency * TAU) * amplitude)
