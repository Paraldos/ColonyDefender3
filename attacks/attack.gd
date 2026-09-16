extends Marker2D
class_name Attack

enum AttackPatterns {
	SINGLE_SHOT,
	SHOTGUN,
	STAR, # fires in four directions
}

const MUZZLE_FLASH = preload("uid://brd6wl1eftmlh")
@export var projectile: PackedScene
@export var attack_pattern := AttackPatterns.SINGLE_SHOT
@export var delay := 0.3
@export var spread := 15.0
@export var muzzle_offset := 12
@export var sfx := AudioManager.Sound.NOTHING
@export var dmg := 5
var attack_timer := Timer.new()
var muzzle_flash: Sprite2D

func _ready() -> void:
	muzzle_flash = MUZZLE_FLASH.instantiate()
	muzzle_flash.visible = false
	add_child(muzzle_flash)

	add_child(attack_timer)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	attack_timer.start(delay)

func _on_attack_timer_timeout() -> void:
	AudioManager.play(sfx, 0.2, -10)
	_muzzle_flash()
	match attack_pattern:
		AttackPatterns.SINGLE_SHOT:
			_shoot(0.0)
		AttackPatterns.SHOTGUN:
			_shoot(-spread)
			_shoot(0.0)
			_shoot(spread)
		AttackPatterns.STAR:
			for i in range(4):
				_shoot(i * 90.0)

func _muzzle_flash():
	muzzle_flash.visible = true
	await get_tree().create_timer(0.1).timeout
	muzzle_flash.visible = false

func _shoot(angle: float) -> void:
	if projectile == null:
		return
	var p := projectile.instantiate() as Node2D
	p.dmg = dmg
	p.global_position = global_position
	p.global_rotation = global_rotation + deg_to_rad(angle)
	get_tree().current_scene.add_child(p)
