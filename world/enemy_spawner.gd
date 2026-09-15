extends Node2D

@export var possible_enemies: Array[PackedScene] = []

@onready var enemy_container: Node2D = %EnemyContainer
@onready var spawn_points = [%Up, %Left, %Right]

var wave_pending := false
var grace_time := 2.0
var time_betwee_enemies := 1.0
var rng = RandomNumberGenerator.new()
var wave_size := 4
var wave_spacing := 13.0

func _ready() -> void:
	rng.randomize()
	Utils.enemy_removed.connect(_on_enemy_removed)
	await get_tree().create_timer(grace_time).timeout
	_spawn_new_wave()

func _on_enemy_removed():
	await get_tree().process_frame
	if wave_pending:
		return
	if enemy_container.get_child_count() <= 1:
		_spawn_new_wave()

func _spawn_new_wave() -> void:
	if wave_pending or possible_enemies.is_empty():
		return
	wave_pending = true
	var current_enemy = possible_enemies.pick_random()
	var spawn_point: Marker2D = spawn_points.pick_random()

	var direction := -1 if rng.randf() < 0.5 else 1

	for i in wave_size:
		await get_tree().create_timer(time_betwee_enemies).timeout
		var e = current_enemy.instantiate()

		var spawn_position := spawn_point.global_position
		if spawn_point == %Up:
			spawn_position.x += (i - (wave_size - 1) / 2.0) * wave_spacing * direction

		e.position = enemy_container.to_local(spawn_position)
		enemy_container.add_child(e)
	wave_pending = false
