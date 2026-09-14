extends Node2D
class_name EnemyMovement

var _actor: Node2D
var _elapsed_time: float = 0.0
var _start_pos := Vector2.ZERO

func _ready() -> void:
	if _actor == null:
		_actor = get_parent() as Node2D
	_start_pos = global_position

func _physics_process(delta: float) -> void:
	if _actor == null:
		return
	match _actor.movement_type:
		_actor.Movement.STRAIGHT_DOWN:
			_move_straight_down(delta)
		_actor.Movement.SINUS_DOWN:
			_move_sinus_down(delta)
		_actor.Movement.SINUS_DOWN_REVERSE:
			_move_sinus_down_reverse(delta)

func _move_straight_down(delta: float) -> void:
	_actor.position.y += _actor.speed * delta

func _move_sinus_down(delta: float) -> void:
	_elapsed_time += delta
	_actor.position.y += _actor.speed * delta
	_actor.position.x = (
		_start_pos.x + sin(_elapsed_time * _actor.frequency * TAU) * _actor.amplitude
	)

func _move_sinus_down_reverse(delta: float) -> void:
	_elapsed_time += delta
	_actor.position.y += _actor.speed * delta
	_actor.position.x = (
		_start_pos.x - sin(_elapsed_time * _actor.frequency * TAU) * _actor.amplitude
	)
