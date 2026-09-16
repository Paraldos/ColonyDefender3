extends Node2D
class_name Projectile

@onready var hitbox: Hitbox = %Hitbox

@export var speed := 100.0
var dmg := 1

func _ready() -> void:
	hitbox.dmg = dmg

func _physics_process(delta: float) -> void:
	global_position += Vector2.UP.rotated(global_rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_hitbox_impact() -> void:
	queue_free()
