extends Node2D
class_name Enemy

@onready var hit_effect: HitEffect = %HitEffect
@onready var main_sprite: AnimatedSprite2D = %MainSprite
@onready var attack: Attack = %Attack
@onready var attack_container: Node2D = %AttackContainer

@export var hp = 15
var start_pos := Vector2.ZERO
var window_size: Vector2

func _ready() -> void:
	window_size = get_viewport_rect().size
	start_pos = global_position
	if start_pos.x < 0:
		rotation_degrees = -90
		attack_container.rotation_degrees = -90
	elif start_pos.x > window_size.x:
		rotation_degrees = 90
		attack_container.rotation_degrees = 90
	else:
		attack_container.rotation_degrees = 180

func _on_hurtbox_hit_received(hitbox: Hitbox) -> void:
	hit_effect.play()
	AudioManager.play(AudioManager.Sound.HIT, 0.2)
	hp -= hitbox.dmg
	if hp <= 0:
		_death()

func _death():
	Utils.spawn_explosion(global_position)
	queue_free()

func _exit_tree() -> void:
	Utils.enemy_removed.emit()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
