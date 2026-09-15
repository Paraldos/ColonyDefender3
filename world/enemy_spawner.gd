extends Node2D

@export var possible_enemies: Array[PackedScene] = []

@onready var enemy_container: Node2D = %EnemyContainer
@onready var spawn_points = [%Up, %Left, %Right]

var wave_pending := false
var grace_time := 1.0
var time_betwee_enemies := 1.0
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	Utils.enemy_removed.connect(_on_enemy_removed)
	_spawn_new_wave()

func _on_enemy_removed():
	await get_tree().process_frame
	if wave_pending:
		return
	if enemy_container.get_child_count() == 0:
		_spawn_new_wave()

func _spawn_new_wave() -> void:
	if wave_pending or possible_enemies.is_empty():
		return
	wave_pending = true

	await get_tree().create_timer(grace_time).timeout
	var current_enemy = possible_enemies.pick_random()
	var spawn_point: Marker2D = spawn_points.pick_random()

	var spacing := 20.0
	var direction := -1 if rng.randf() < 0.5 else 1

	for i in 3:
		await get_tree().create_timer(time_betwee_enemies).timeout
		var e = current_enemy.instantiate()

		var spawn_position := spawn_point.global_position
		if spawn_point == %Up:
			spawn_position.x += (i - 1) * spacing * direction

		e.position = enemy_container.to_local(spawn_position)
		enemy_container.add_child(e)
	wave_pending = false
