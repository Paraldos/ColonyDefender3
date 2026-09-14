extends Marker2D

const PROJECTILY = preload("uid://cdaatms8regd0")

func _on_attack_timer_timeout() -> void:
	var p = PROJECTILY.instantiate()
	p.global_position = global_position
	get_tree().current_scene.add_child(p)
