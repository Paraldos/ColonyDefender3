extends Node2D
class_name Enemy

enum Movement {
	STRAIGHT_DOWN,
	SINUS_DOWN,
	SINUS_DOWN_REVERSE,
}

const EXPLOSION = preload("uid://ci6p5co2jkjrp")

@onready var hit_effect: HitEffect = %HitEffect

@export var hp = 5

@export_group("Spawn")
@export var wave_size := 3
@export var wave_time := 10
@export var spawn_spacing := 20.0

@export_group("Movement")
@export var speed := 20.0
@export var movement_type := Movement.STRAIGHT_DOWN
@export var amplitude: float = 10.0
@export var frequency: float = 0.5

func _on_hurtbox_hit_received(hitbox: Hitbox) -> void:
	hit_effect.play()
	AudioManager.play(AudioManager.Sound.HIT, 0.2)
	hp -= hitbox.dmg
	if hp <= 0:
		_death()

func _death():
	var e = EXPLOSION.instantiate()
	e.global_position = global_position
	get_tree().current_scene.add_child(e)
	queue_free()

func _exit_tree() -> void:
	Utils.enemy_removed.emit()

func spawns_from():
	match movement_type:
		_:
			return Utils.Direction.UP

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
