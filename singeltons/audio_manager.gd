extends Node

enum Sound {
	NOTHING,
	HIT,
	LASER,
}

const SFX_BUS := &"SFX"
const SOUNDS := {
	Sound.HIT: preload("uid://b01mrdoacyylu"),
	Sound.LASER: preload("uid://bki3tfpr3u8ei"),
}

func play(sound: Sound, pitch_variation := 0.0, volume := 0.0) -> void:
	var stream: AudioStream = SOUNDS.get(sound)
	if stream == null:
		return
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = SFX_BUS
	player.pitch_scale = randf_range(1.0 - pitch_variation, 1.0 + pitch_variation)
	player.volume_db = volume
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()

func play_at_pos(sound: Sound, global_position: Vector2, pitch_variation := 0.0) -> void:
	var stream: AudioStream = SOUNDS.get(sound)
	if stream == null:
		return
	var player := AudioStreamPlayer2D.new()
	player.stream = stream
	player.bus = SFX_BUS
	player.pitch_scale = randf_range(1.0 - pitch_variation, 1.0 + pitch_variation)
	add_child(player)
	player.global_position = global_position
	player.finished.connect(player.queue_free)
	player.play()
