extends TextureProgressBar

func _ready() -> void:
	Utils.update_health.connect(_on_update_health)

func _on_update_health(current: float, max: float):
	max_value = max
	value = current
