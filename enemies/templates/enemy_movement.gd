extends Node2D
class_name EnemyMovement

enum Movement {
	STRAIGHT_LINE,
	SLOW_SINUS,
	FAST_SINUS,
	LOOPING,
	DRIF_TOWARDS_PLAYER, # player is saved under Utils.player
}

@export var speed := 20.0
@export var movement := Movement.STRAIGHT_LINE

# Sinus
var sinus_amplitude := 10.0
var slow_frequency := 0.3
var fast_frequency := 1.0

# Looping
var loop_radius := 10.0
var loop_frequency := 0.5

# Player Tracking
var steering_speed := 1.5

var window_size: Vector2
var actor: Node2D
var start_pos := Vector2.ZERO
var velocity := Vector2.ZERO
var forward := Vector2.DOWN
var sideways := Vector2.RIGHT
var elapsed_time := 0.0
var previous_offset := Vector2.ZERO

func _ready() -> void:
	if actor == null:
		actor = get_parent() as Node2D
	start_pos = global_position
	window_size = get_viewport_rect().size
	if start_pos.x < 0:
		forward = Vector2.RIGHT
		sideways = Vector2.DOWN
	elif start_pos.x > window_size.x:
		forward = Vector2.LEFT
		sideways = Vector2.DOWN
	else:
		forward = Vector2.DOWN
		sideways = Vector2.RIGHT
	velocity = forward * speed

func _physics_process(delta: float) -> void:
	if not is_instance_valid(actor):
		return

	elapsed_time += delta

	match movement:
		Movement.STRAIGHT_LINE:
			_straight_line(delta)
		Movement.SLOW_SINUS:
			_sinus_movement(delta, slow_frequency)
		Movement.FAST_SINUS:
			_sinus_movement(delta, fast_frequency)
		Movement.LOOPING:
			_looping_movement(delta)
		Movement.DRIF_TOWARDS_PLAYER:
			_drift_towards_player(delta)

func _straight_line(delta: float) -> void:
	actor.global_position += velocity * delta

func _sinus_movement(delta: float, frequency: float) -> void:
	var phase := elapsed_time * frequency * TAU
	var offset := sideways * sin(phase) * sinus_amplitude

	_apply_offset_movement(delta, offset)

func _looping_movement(delta: float) -> void:
	var phase := elapsed_time * loop_frequency * TAU
	var offset := (sideways * (cos(phase) - 1.0) + forward * sin(phase)) * loop_radius

	_apply_offset_movement(delta, offset)

func _apply_offset_movement(delta: float, offset: Vector2) -> void:
	actor.global_position += velocity * delta + offset - previous_offset
	previous_offset = offset

func _drift_towards_player(delta: float) -> void:
	if not is_instance_valid(Utils.player):
		_straight_line(delta)
	var target_direction := actor.global_position.direction_to(Utils.player.global_position)
	if not target_direction.is_zero_approx():
		var weight := 1.0 - exp(-steering_speed * delta)
		var angle := lerp_angle(velocity.angle(), target_direction.angle(), weight)
		velocity = Vector2.from_angle(angle) * speed
