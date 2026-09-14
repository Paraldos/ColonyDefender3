extends Node2D
class_name Enemy

@onready var hit_effect: HitEffect = %HitEffect
const EXPLOSION = preload("uid://ci6p5co2jkjrp")
@export var hp = 5
@export var movement: EnemyMovement

func _ready() -> void:
	pass

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
