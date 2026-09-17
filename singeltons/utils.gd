extends Node

signal enemy_removed
signal update_health(current_hp, max_hp)

enum Targets {
	PLAYER,
	ENEMY,
}

var explosions = [preload("uid://ci6p5co2jkjrp"), preload("uid://btneeke0y6iw3")]
var player: Player

func spawn_explosion(pos):
	var e = explosions.pick_random().instantiate()
	e.global_position = pos
	get_tree().current_scene.add_child(e)
