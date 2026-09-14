extends Node2D

@onready var hit_effect: HitEffect = %HitEffect

func _on_hurtbox_hit_received(hitbox: Hitbox) -> void:
	hit_effect.play()
	AudioManager.play_sfx(AudioManager.Sound.HIT, 0.2)
