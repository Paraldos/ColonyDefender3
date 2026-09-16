extends AnimatedSprite2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rotation_degrees = rng.randi_range(0,3) * 90

func _on_animation_finished() -> void:
	queue_free()
