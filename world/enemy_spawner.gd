extends Node2D

@export var possible_enemies: Array[PackedScene] = []

@onready var enemy_container: Node2D = %EnemyContainer
@onready var spawn_points = {
	Utils.Direction.UP: %Up,
	Utils.Direction.LEFT: %Left,
	Utils.Direction.RIGHT: %Right,
}

var current_enemy
var grace_time := 1.0
var _wave_pending := false

func _ready() -> void:
	Utils.enemy_removed.connect(_on_enemy_removed)
	_spawn_new_wave()

func _on_enemy_removed():
	await get_tree().process_frame
	if enemy_container.get_child_count() == 0:
		_spawn_new_wave()

func _spawn_new_wave() -> void:
	if _wave_pending or possible_enemies.is_empty():
		return
	_wave_pending = true
	await get_tree().create_timer(grace_time).timeout

	current_enemy = possible_enemies.pick_random().instantiate() as Enemy

	var direction = current_enemy.spawns_from()
	var spawn_point := spawn_points[direction] as Marker2D

	var offset_axis := Vector2.RIGHT
	if direction != Utils.Direction.UP:
		offset_axis = Vector2.DOWN

	for i in range(current_enemy.wave_size):
		var e := current_enemy.duplicate() as Enemy
		var offset = (i - (current_enemy.wave_size - 1) * 0.5) * current_enemy.spawn_spacing
		var spawn_position = spawn_point.global_position + offset_axis * offset
		e.position = enemy_container.to_local(spawn_position)

		enemy_container.add_child(e)

	current_enemy.free()
	_wave_pending = false
