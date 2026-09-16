extends Node2D
class_name Projectile

@onready var hitbox: Hitbox = %Hitbox

@export var speed := 80.0

var targets := Utils.Targets.PLAYER
var dmg := 1

func _ready() -> void:
	hitbox.dmg = dmg
	hitbox.collision_mask = 0
	hitbox.set_collision_mask_value(2, targets == Utils.Targets.PLAYER)
	hitbox.set_collision_mask_value(1, targets == Utils.Targets.ENEMY)

func _physics_process(delta: float) -> void:
	global_position += Vector2.UP.rotated(global_rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_hitbox_impact() -> void:
	queue_free()
