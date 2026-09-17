extends CharacterBody2D
class_name Player

@onready var hit_effect: HitEffect = %HitEffect
var explosions = [preload("uid://ci6p5co2jkjrp"), preload("uid://btneeke0y6iw3")]
var max_hp := 30
var current_hp := max_hp

func _ready() -> void:
	Utils.player = self
	await get_tree().physics_frame
	Utils.update_health.emit(current_hp, max_hp)

func _on_hurtbox_hit_received(hitbox: Hitbox) -> void:
	hit_effect.play()
	AudioManager.play(AudioManager.Sound.HIT, 0.2)
	current_hp -= hitbox.dmg
	Utils.update_health.emit(current_hp, max_hp)

func _on_hitbox_impact() -> void:
	hit_effect.play()
	AudioManager.play(AudioManager.Sound.HIT, 0.2)
	current_hp -= 10
	Utils.update_health.emit(current_hp, max_hp)
