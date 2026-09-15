extends Node2D
class_name Enemy

const EXPLOSION = preload("uid://ci6p5co2jkjrp")

@onready var hit_effect: HitEffect = %HitEffect
@onready var main_sprite: AnimatedSprite2D = %MainSprite

@export var hp = 2
var start_pos := Vector2.ZERO
var window_size: Vector2

func _ready() -> void:
	window_size = get_viewport_rect().size
	start_pos = global_position
	if start_pos.x < 0:
		rotation_degrees = -90
	elif start_pos.x > window_size.x:
		rotation_degrees = 90

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

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
